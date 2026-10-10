# Unbloarchy update process

This document describes the intended update behavior now that Unbloarchy is
package-backed. It covers the blessed update path plus what happens when a user attempts to
bypass it:

1. `unbloarchy update` — the blessed interactive Unbloarchy update flow.
2. `sudo pacman -Syu` — guarded by Unbloarchy and aborted with instructions unless
   the user explicitly bypasses the guard.

The design goal is:

- `unbloarchy update` owns the visible update pipeline: package transaction,
  migrations, post-update hooks, update-state refresh, and restart checks.
- Migrations run per-user after pacman finishes, because they may need `$HOME`,
  DBus/session state, a graphical session, sudo, or user interaction.
- Users who bypass `unbloarchy update` are nudged back by the pacman guard; if they
  explicitly bypass it, their session is notified when migrations are pending.

## State and coordination files

| Path | Owner | Purpose |
| --- | --- | --- |
| `${XDG_RUNTIME_DIR:-/tmp}/unbloarchy-update.lock` | user | Prevent overlapping update runs. Owned by `unbloarchy-update-lock`; compatibility wrappers inherit/respect it. |
| `${XDG_RUNTIME_DIR}/unbloarchy-update-stay-awake/` | user | Private mode-0700 inhibitor coordination state. If no runtime directory is available, the helper uses the validated mode-0700 `/tmp/unbloarchy-$UID/` fallback. |
| `/tmp/unbloarchy-update.log` | user | Transcript of `unbloarchy update`, used by `unbloarchy-update-analyze-logs`. |
| `~/.local/state/unbloarchy/current/` | user | Generated active theme, selected theme name, and current background symlink. |
| `~/.local/state/unbloarchy/migrations/` | user | Per-user migration markers. |
| `~/.local/state/unbloarchy/reboot-required` | user | Optional reboot marker checked by `unbloarchy-update-restart`. |
| `~/.local/state/unbloarchy/restart-*-required` | user | Optional service/app restart markers checked by `unbloarchy-update-restart`. The shell needs no marker: it is restarted unconditionally after every update. |

## Migration layout

See [`migrations.md`](../agents/skills/migrations.md) for the full migration model, authoring
guidelines, and troubleshooting notes.

Migrations live in:

```text
migrations/*.sh
```

They run as the current user through:

```bash
unbloarchy-migrate
```

Completion state is per-user:

```text
~/.local/state/unbloarchy/migrations/<migration filename>
```

Every user gets a chance to run every migration. Migrations run as the user;
privileged work should invoke the appropriate helper or privilege prompt.
Migrations must be idempotent; if one user already applied a machine-wide repair,
the migration should no-op for other users.

When invoked by the update, migrations share its single sudo authorization. The standalone migration runner has its own security changes in the migration-boundary PR; this update change does not establish that standalone boundary. Historical migrations remain strictly ordered.

For watchers and diagnostics, `unbloarchy-migrate --pending` prints pending
migration names and exits `0` when any are pending. When no migrations are
pending, it prints nothing and exits non-zero.

## Raw pacman guard

The `omarchy` package installs an ALPM pre-transaction hook alongside its guard
binary:

```text
/usr/share/libalpm/hooks/00-unbloarchy-update-guard.hook
/usr/bin/unbloarchy-update-pacman-guard
```

It triggers on package upgrades and runs:

```bash
unbloarchy-update-pacman-guard
```

The guard detects direct pacman system-upgrade commands like `pacman -Syu` or
`pacman --sync --refresh --sysupgrade`. If the upgrade was not launched by an
Unbloarchy update command, the hook exits non-zero with `AbortOnFail`, which stops
the transaction before packages are changed.

`unbloarchy-update-system-pkgs`, `unbloarchy-refresh-pacman`, `unbloarchy-reinstall-pkgs`,
and `unbloarchy-channel-set` run pacman through the hidden `unbloarchy-update-pacman`
helper (the v4 upgrader sets `UNBLOARCHY_UPDATE_PACMAN=1` directly):

```bash
sudo env UNBLOARCHY_UPDATE_PACMAN=1 systemd-run --scope --quiet --collect pacman ...
```

so the guard allows Unbloarchy-owned update flows. The `systemd-run --scope`
wrapper registers the transaction as a PID 1 scope: upgrading systemd reexecs
the system and user managers mid-transaction, and a pacman left inside a
user-session scope can be SIGKILLed by that reexec. On unbooted systems (such
as the installer chroot) the helper runs pacman directly. A user can intentionally bypass
the guard with:

```bash
sudo env UNBLOARCHY_ALLOW_DIRECT_PACMAN=1 pacman -Syu
```

The guard does not start `unbloarchy update` itself because pacman is already in a
transaction setup path; it only aborts with instructions.

The `omarchy` package also installs ALPM hooks for `omarchy-settings` /
`omarchy-settings-dev` installs and upgrades. The pre-transaction hook runs
`unbloarchy-hyprland-reload-guard pause` to disable live Hyprland config reloads
while `/usr/share/unbloarchy/default/hypr/**` is replaced. The post-transaction
hook runs `unbloarchy-hyprland-reload-guard resume`, forces one `hyprctl reload`,
and restores the session's previous `misc.disable_autoreload` and
`debug.suppress_errors` values.

## Path 1: `unbloarchy update`

High-level flow:

```text
unbloarchy-update
  ├─ ensure transcript logging through script(1) → /tmp/unbloarchy-update.log
  ├─ unbloarchy-update-lock
  │    └─ acquire the update lock and run unbloarchy-update inside it
  ├─ unbloarchy-update-requires-free-space
  │    └─ abort below the configured free-space threshold on /
  ├─ confirm unless -y
  ├─ authorize sudo once, then keep the timestamp fresh in the background
  ├─ unbloarchy-update-pkg-prune
  │    └─ trim the pacman cache to two versions per package, deliberately
  │       before the snapshot since the cache lives on the snapshotted subvolume
  ├─ create snapper snapshot (skipped silently without snapper; snapper
  │  installed but unconfigured fails the snapshot loudly, pointing at
  │  install/config/snapper.sh, and the update continues without one)
  ├─ unbloarchy-update-stay-awake start
  ├─ run system-package updates
  ├─ run migrations
  ├─ automatically remove orphan packages and run log analysis
  ├─ unbloarchy-update-status
  │    └─ refresh or clear the shell update indicator
  ├─ restart marked services and the shell
  ├─ run the post-update hook, then update mise tools
  ├─ stop the keepalive and invalidate sudo, then update AUR packages with
  │  no-update authentication, and invalidate again
  ├─ unbloarchy-update-stay-awake stop
  │    └─ release the sleep inhibitor and restore shell idle state, if changed
  └─ offer the unprivileged reboot prompt
```

Important behavior:

- Protected update entrypoints require the session's canonical `UNBLOARCHY_PATH` to match their own checkout or the packaged `/usr/bin` entrypoint before selecting commands or the sudo wrapper. This preserves intentionally trusted development checkouts while rejecting a command paired with a different source root. System phases use a fixed command search path; user PATH is restored for hooks and mise.
- Mixed-trust update entrypoints start Bash in privileged mode, discard `BASH_ENV`, `ENV`, and exported-function records before launching helpers, and reject an ordinary `bash path/to/command` invocation. Run them as executables (normally through the `unbloarchy` CLI); `/usr/bin/bash -p path/to/command` is the explicit interpreter form. This keeps shell startup injection from replacing the no-update sudo boundary.
- In dev-link mode, `unbloarchy update` fast-forwards the active checkout from its configured upstream before changing system packages or running migrations.
- The update asks for the sudo password once, right after confirmation. It first invalidates any existing timestamp so that prompt always belongs to this update, then a background keepalive refreshes the timestamp every minute so long downloads, migrations, hooks, and mise never outlast it. Everything except AUR shares that one authorization: package prune, snapshot, stay-awake, keyring, system packages, migrations, orphan removal, service restarts, the post-update hook, and mise. Stay-awake sees `UNBLOARCHY_UPDATE_SUDO_SESSION=1`, uses that authorization non-interactively whatever its stdin is, and leaves it to the update instead of revoking it. The authorization runs a command rather than `sudo -v`, so passwordless sudo still needs no prompt. Standalone commands that keep their own cold boundary, such as `unbloarchy-refresh-pacman`, still revoke if a post-update hook calls them.
- AUR builds run third-party PKGBUILD code, so they run last and never see the update's authorization. The update stops the keepalive, invalidates the timestamp, and runs yay with the no-update wrapper as its sudo command and its credential loop disabled; an AUR install prompts per command without publishing a reusable timestamp. The timestamp is invalidated again afterwards and on every exit.
- This lifecycle controls authorization created by the protected workflow. `sudo -N` prevents cache updates but can use an existing valid credential, and `sudo -k` revokes the current session's timestamp. It does not isolate the account from unrelated concurrent authentication in another workflow.
- Sleep inhibition authenticates before detaching, drops the held command back to the caller, and closes both update lock descriptors before the persistent process starts. Cleanup accepts only caller-owned, mode-0600, single-link state and revalidates the recorded PID, process start time, owner, and random token immediately before every signal.
- Channel switching establishes the same boundary before dev link/unlink, refresh and package operations. It keeps the wrapper first when changing source roots, carries the original user PATH into update hooks and mise, and checks after each package transaction that the wrapper still exists before any further privileged step, since a transaction can replace the running tree with a release that predates it; when it is gone, or the destination otherwise lacks it, the switch stops after the package switch with instructions to run that release's update from a fresh session rather than letting a bare `sudo` or an updater that authenticates without `--no-update` publish a timestamp. Failed and interrupted channel switches revoke on exit.
- `-y` exports `UNBLOARCHY_UPDATE_UNATTENDED=1` and suppresses Unbloarchy confirmation prompts. Conflict handoff reports and skips instead of blocking. Orphan packages are automatically removed during every update. Privileged commands still require the one sudo authorization, and AUR installs can prompt separately.
- The free-space requirement uses a 10 GiB threshold and stops the update before
  confirmation when it is not met. If free space cannot be determined, the
  check is silently skipped. Set `UNBLOARCHY_UPDATE_FORCE=1` to bypass the check.
- `unbloarchy update` checks/runs migrations in the same visible terminal via
  `unbloarchy-migrate` after pacman finishes.
- A failure should leave enough output in `/tmp/unbloarchy-update.log` and the
  terminal transcript to debug.

## Path 2: direct `sudo pacman -Syu` attempt

High-level flow:

```text
sudo pacman -Syu
  ├─ pre-transaction guard aborts and tells the user to run unbloarchy update
  └─ if explicitly bypassed, upgrades unbloarchy and related packages
  └─ at that user's next login
       ├─ graphical-session.target starts
       ├─ unbloarchy-migrate-notify.service starts after it
       ├─ unbloarchy-migrate-notify checks unbloarchy-migrate --pending
       ├─ if this user has missing migration state, show notification
       └─ click opens terminal: unbloarchy-migrate
```

Login is deliberately the only trigger. A watcher on the packaged migration
directory cannot distinguish a bypassed `pacman -Syu` from the package
transaction inside a normal `unbloarchy update`, so it fired notifications for
migrations that `unbloarchy-migrate` was about to apply in the visible update
terminal. The retired unit was `unbloarchy-update-user-notify.path`.

Retiring that watcher through a migration cannot come in time for the update
that retires it: pacman writes the migration directory, the watcher fires, and
only then does `unbloarchy-migrate` reach the migration that stops it. So the
notifier also refuses to run while `unbloarchy update` holds its
`$XDG_RUNTIME_DIR/unbloarchy-update.lock`, which covers the stale watcher and any
trigger added later — during an update, every pending migration is by
definition already being applied a step away. It checks again after waiting for
the notification server, since that wait is long enough for an update to start
underneath it.

The notifier reads only its own user's runtime directory, never the `/tmp` path
`unbloarchy-update` falls back to when `XDG_RUNTIME_DIR` is unset. A shared lock
file belongs to whoever created it first, so honouring it would let one user
silence another user's notification. Missing an update and showing a redundant
toast is the better failure.

Suppression is why `unbloarchy-update-stay-awake` starts its sleep inhibitor with
the lock descriptor closed. That inhibitor outlives the step that starts it, so
an update killed before cleanup would otherwise leave it holding the flock
indefinitely — blocking later updates and, now that the notifier reads the same
lock, silencing migration notifications at every login.

Fallbacks:

- `unbloarchy-provision-first-run` enables `unbloarchy-migrate-notify.service`, which also
  covers users created after install: their per-user migration markers are
  missing, so their first login prompts them to run every shipped migration.
- The package ships `unbloarchy-update-user-notify.service` as a symlink onto
  `unbloarchy-migrate-notify.service`. Users set up before the rename hold an
  absolute `graphical-session.target.wants` symlink to the old path, and the
  migration that repoints it only runs for users who run an update — the
  opposite of who the notifier is for. The alias can be dropped once installs
  have run migration `1785095882`.
- The notifier is ordered after `graphical-session.target`, so an action that
  launches through `uwsm-app` cannot block the target that gates UWSM's app
  daemon.
- The notifier waits for a live notification server before sending, because
  `graphical-session.target` can be reached before the shell claims
  `org.freedesktop.Notifications`.
- The notifier is only a prompt. It does not run migrations in the background.
- A session that is already open when another user updates is not re-checked;
  it picks the migrations up at its next login, or whenever that user runs
  `unbloarchy-migrate` or `unbloarchy update`.
- Direct pacman updates do not run `unbloarchy-hook post-update` unless the user
  explicitly runs that hook; without a package-update marker, the only pending
  state we can derive is missing per-user migration markers.

## Shell update indicator

The bar widget `unbloarchy.system-update` runs:

```bash
unbloarchy-update-available
```

`unbloarchy-update-available` checks the active Unbloarchy sources for updates:

- new upstream commits for the active dev-linked checkout
- `omarchy-dev`, when installed
- otherwise `omarchy`, when installed

The dev check fetches the checkout's configured upstream before comparing it
with `HEAD`. A failed fetch is quiet and falls back to the existing remote-
tracking state.

Exit codes:

- `0` — Unbloarchy updates are available; stdout is the update list.
- non-zero — no Unbloarchy updates are available; stdout says Unbloarchy is up to date.

The widget runs this check on shell startup and every six hours. Clicking the
update icon launches `unbloarchy-update` in a floating terminal.

## Channels and versions

Updates install whatever the active channel points at. `unbloarchy-channel-set
<stable|rc|edge|dev>` switches channels: the three package channels select
which pacman repo the mirrorlist points at (and swap between the `omarchy` and
`omarchy-dev` packages through a guard-allowed pacman run), while `dev` links
the runtime to a git checkout via the dev-link mechanism, after which
`unbloarchy update` fast-forwards that checkout instead of upgrading a package.
Channel switching runs the `pre-refresh-pacman` hook once, during its refresh
step: cold, behind the no-update wrapper, after the package config is re-synced
and before the refresh transaction. It does not run if the switch fails earlier.

There is no version file at runtime. `unbloarchy-version` derives the version from
`pacman -Q` on whichever package is installed, or reports `dev (<hash>)` for a
linked checkout, and `unbloarchy-version-channel` sniffs the mirrorlist and
pacman.conf to answer which channel is active.

The `version` file at the repository root does exist, but only as build input:
the PKGBUILDs in `omarchy-pkgs` derive `pkgver` from it. This fork carries its
own version, `<upstream version>.unbloarchy.<n>` (`4.0.0.alpha.unbloarchy.1`),
rather than tracking upstream's string verbatim, so `unbloarchy version` never
reports a number that upstream shipped. Two constraints follow. It must be a
valid pacman `pkgver`, so it uses `.` separators and never a `-`: pacman splits a
package version at the last `-` into `pkgver` and `pkgrel`, and a hyphen would be
read as that separator. And it must sort **above** the upstream version it
derives from, or an existing install is never offered the upgrade — which is why
`.unbloarchy.1` is appended rather than prepended with `~`. When upstream moves
past this fork's declared baseline, bump the baseline and the counter together;
pacman will otherwise correctly report that the mirror's newer package is an
upgrade.

## Update-related binaries

This inventory is intentionally opinionated. Some commands are useful as stable
leaf commands; others exist mostly because the old update flow accreted small
scripts.

| Binary | Current purpose | Keep? / Question |
| --- | --- | --- |
| `unbloarchy-update` | Public user command. Adds transcript logging, confirmation, snapshot, and restart checks around the locked, sleep-inhibited update pipeline. | **Keep.** This is the blessed entry point and orchestrates the update pipeline. |
| `unbloarchy-update-lock` | Hidden command wrapper that holds the per-user update lock while its child runs. | **Keep internal/hidden.** Isolates update concurrency and lock descriptor handling. |
| `unbloarchy-update-stay-awake` | Hidden helper that starts or stops update-owned sleep and idle inhibition, restoring only the state it changed. | **Keep internal/hidden.** Keeps inhibitor ownership and cleanup together. |
| `unbloarchy-update-status` | Hidden helper that refreshes or clears the shell update indicator after rechecking available updates. | **Keep internal/hidden.** Keeps shell status synchronization out of the main pipeline. |
| `unbloarchy-update-confirm` | Gum confirmation copy for `unbloarchy update`. | **Question.** Could be inlined into `unbloarchy-update`; separate file only helps keep copy isolated. |
| `unbloarchy-update-dev` | Fast-forwards the active dev-linked checkout from its configured upstream; no-ops for package-backed installs. | **Keep.** Runs before package updates so a checkout conflict stops the update before system mutation. |
| `unbloarchy-update-keyring` | Ensures Unbloarchy keyring and Arch keyring are current before the main transaction. | **Keep, but review.** It uses targeted `pacman -Sy` for keyring bootstrapping; acceptable for this special case but should remain tightly scoped. |
| `unbloarchy-update-system-pkgs` | Runs `unbloarchy-update-pacman -Syu --noconfirm` with `--overwrite '/usr/share/unbloarchy/*'`, capturing stderr to a report file; on failure it execs `unbloarchy-update-system-pkgs-when-conflicted`. | **Keep for now.** Small leaf command, clear/testable. |
| `unbloarchy-update-system-pkgs-when-conflicted` | Hidden conflict handler: quarantines unowned conflicting files under `/var/lib/unbloarchy/replaced`, retries the upgrade once, restores files the upgrade didn't claim, and hands package-vs-package conflicts to an interactive pacman run (never under `-y`). | **Keep internal/hidden.** Keeps conflict recovery out of the happy path. |
| `unbloarchy-update-pkg-prune` | Trims the pacman cache to two versions per package (`paccache -rk2`) before the snapshot, keeping the offline downgrade path while capping snapshot growth. | **Keep internal/hidden.** |
| `unbloarchy-update-requires-free-space` | Aborts the update below a 10 GiB free-space threshold on `/`; silently skipped when free space cannot be determined; `UNBLOARCHY_UPDATE_FORCE=1` bypasses. | **Keep internal/hidden.** |
| `unbloarchy-migrate` | Public migration command. Waits for pacman, then runs all pending migrations for the current user. Supports `--pending`. | **Keep.** This replaces the discarded `unbloarchy-update-user-finalize` name and no longer needs `--force`. |
| `unbloarchy-update-pacman-guard` | ALPM pre-transaction guard that aborts direct `pacman -Syu` style upgrades unless Unbloarchy set `UNBLOARCHY_UPDATE_PACMAN=1` or the user explicitly set `UNBLOARCHY_ALLOW_DIRECT_PACMAN=1`. | **Keep internal/hidden.** This is what nudges users back to `unbloarchy update`. |
| `unbloarchy-update-pacman` | Hidden helper that runs a guard-approved pacman transaction as a PID 1 scope (`systemd-run --scope`) so a mid-transaction systemd reexec cannot kill it; runs pacman directly when not booted under systemd. | **Keep internal/hidden.** Single place that owns how Unbloarchy invokes pacman for system mutation. |
| `unbloarchy-migrate-notify` | Internal login-time notification helper. Uses `unbloarchy-migrate --pending` and shows a notification only when this user has pending migrations. | **Keep internal/hidden.** Clear name now that the public command is `unbloarchy-migrate`. |
| `unbloarchy-update-user-notify` | Hidden compatibility wrapper for `unbloarchy-migrate-notify`. | **Temporary.** Keep only for old callers. |
| `unbloarchy-update-available` | Update checker for shell widget and post-update refresh. | **Keep.** Could eventually be renamed `unbloarchy-update-check`, but current name matches widget semantics. |
| `unbloarchy-update-aur-pkgs` | Updates AUR packages with `yay -Sua` if foreign packages exist and AUR is reachable. | **Question.** Unbloarchy is package-backed now, but users may still install AUR packages. Keep for now. |
| `unbloarchy-update-mise` | Runs `MISE_MINIMUM_RELEASE_AGE=0 mise up` for mise-managed tools — the override of mise's release-age cooldown is the point. | **Keep.** Mise-managed tools are intentionally part of the blessed update path. |
| `unbloarchy-update-orphan-pkgs` | Lists orphans and prompts before removal unless passed `-y`, as the update pipeline does; standalone noninteractive mode only reports. | **Keep for now.** Automates cleanup during updates and supports standalone review. |
| `unbloarchy-update-analyze-logs` | Scans `/tmp/unbloarchy-update.log` for known failure patterns, currently initramfs generation. | **Keep/expand.** Useful safety net; should grow only for high-signal checks. |
| `unbloarchy-update-restart` | Restarts components selected by `restart-*-required` markers, always restarts the shell, and prompts for reboot after kernel/Hyprland updates. Internal phase flags let the update finish sudo-capable restarts before user hooks and defer only the unprivileged reboot prompt. | **Keep.** Important final step; may eventually include service-restart checks. |
| `unbloarchy-update-firmware` | Manual firmware update command using fwupd. Not part of the normal update pipeline. | **Keep separate.** Firmware is not a routine system update step. |
| `unbloarchy-update-time` | Restarts `systemd-timesyncd`. | **Question.** Not really an update command. Consider renaming/moving under system/time maintenance. |

## Closed decisions

1. **Migrations run per-user from the update pipeline**
   - `unbloarchy update` runs `unbloarchy-migrate` after pacman finishes.
   - Package-time migration runners do not apply migrations inside pacman.
   - Every user has per-user migration markers, and migrations must be
     idempotent when they repair machine-wide state.

2. **Migration notification naming**
   - The real helper is `unbloarchy-migrate-notify`, started by
     `unbloarchy-migrate-notify.service`.
   - `unbloarchy-update-user-notify` remains only as a hidden compatibility wrapper.

3. **Update pipeline ownership**
   - `unbloarchy-update` owns the full update pipeline now.

4. **Mise remains in the blessed update path**
   - `unbloarchy-update-mise` intentionally runs as part of `unbloarchy update`.

5. **Orphan cleanup stays in the update path for now**
   - It is prompt-only and never removes packages noninteractively.

6. **Direct pacman user follow-up is based on actual migration state**
   - Direct `sudo pacman -Syu` no longer uses a fake user-update marker.
   - User notifications are shown only when `unbloarchy-migrate --pending` finds
     missing per-user migration state.

## Remaining concerns

1. **Pacman guard scope**
   - The guard detects direct pacman sysupgrade invocations and allows Unbloarchy
     commands that set `UNBLOARCHY_UPDATE_PACMAN=1`.
   - We may regret blocking some legitimate package-manager frontends or
     maintenance flows. Keep an eye on what should be allowed versus redirected
     to `unbloarchy update`.

2. **Pacnew/pacsave handling is still missing**
   - Package-backed Unbloarchy should warn about or help process `.pacnew` and
     `.pacsave` files after updates.
