# Plan: Rebrand — Omarchy to Unbloarchy, end to end

Revision 1.

## Current status (2026-10-03)

The no-fork compatibility wrappers, legacy package-source aliases, runtime links, and migration are implemented in this repository and focused-test verified. No changes to `omarchy-pkgs` are required; the user plans to build the ISO themselves, so end-to-end package/ISO installation remains unverified here. A contributor issue, [#4](https://github.com/Magiclovekorean/unbloarchy/issues/4), covers visually stale wallpaper wordmarks, the SDDM logo, and outdated screenshots; the user is not planning to do those asset updates personally. Ordinary unbranded wallpapers should remain untouched. Full shell-suite/channel-test confirmation and live desktop visual verification still need a suitable target. Older progress-log entries below are historical snapshots; later entries supersede their open/blocked statuses.

## Problem

The repo has been rebranded once, and only in the README: `8f49c4fc Rename the project to Unbloarchy in the README`. Everything else still says Omarchy, everywhere, including the parts a user actually sees. Issue #1 ("Should rebrand") asks for a rebrand "for ethical reasons (so it doesn't resemble the official omarchy)" plus removal of `omarchy.org` URLs, and neither has happened beyond that single commit.

The scope is larger than a find-and-replace. `omarchy` appears 15,058 times across 1,317 files, and it is load-bearing in at least ten structurally different ways that a blind substitution would silently break:

- **476 executables** in `bin/` are `omarchy-*`. They are the entire user-facing CLI, the router's discovery source, and the sudoers/PAM/ALPM-hook target names.
- **324 distinct `OMARCHY_*` environment variables** cross bash, Quickshell QML (`Quickshell.env`), Hyprland Lua (`os.getenv`), systemd `Environment=`, and sudo `env_keep`.
- **`$OMARCHY_PATH`** resolves to `/usr/share/omarchy`, and roughly 140 path literals across the tree embed the brand.
- **The router hard-codes the brand in 13 places**, including the discovery glob at `bin/omarchy:318`. Rename the files without editing it and the CLI discovers zero commands and fails silently.
- **The metadata schema is keyed on the string `omarchy`**: `bin/omarchy:205` parses `^[[:space:]]*#[[:space:]]*omarchy:([[:alnum:]_-]+)=(.*)$`. Miss the 476 header lines and every command silently loses its summary, args, `hidden` flag, and `requires-sudo` flag.
- **`omarchy-security-functions` is a trust anchor**, not just a filename: 5 entrypoints source it by sibling path, `default/omarchy/sudo-no-update/sudo:10` reaches it through a relative `../../../bin/` hop, and its basename-vs-`$OMARCHY_PATH` check (`:48-55`) is the mechanism `AGENTS.md` documents as the `-p` regression that `test/cli` guards.
- **Window classes and layer-shell namespaces** (`org.omarchy.*`, `omarchy-bar`, `omarchy-menu`, `omarchy-osd`, and 13 more) are matched by Hyprland rules in `default/hypr/apps/omarchy-shell.lua:4,13`. Rename the producer without the consumer and the overlays stop animating correctly.
- **Bar and widget ids** (`omarchy.clock`, `omarchy.bar`, ~60 total) are persisted in user `~/.config/omarchy/shell.json` and are the argument vocabulary of `omarchy bar put|move|set`.
- **Arch package names** are `omarchy`, `omarchy-settings`, `omarchy-keyring`, `omarchy-nvim`, `omarchy-dev`, `linux-omarchy`, and the `oma*` tools — all built in `omarchy-pkgs`, none of it in this repo.
- **5,905 occurrences in tests**, including `test/cli` assertions on the literal strings `"Omarchy command center"` and `"omarchy theme set <theme-name>"`.

## Shape

One coordinated rename, landed as a sequence of reversible commits, with `./test/cli` and `./test/shell` green at every boundary and no commit that leaves the tree in a state where the router cannot find its own commands.

The rename covers every in-repo identifier: executables, env vars, install root, config and state paths, systemd units, PAM files, sudoers entries, tmpfiles, sysctl, udev, Limine, Snapper, shell plugin ids, window classes, layer-shell namespaces, icon font family, theme names, hostname default, all prose, and the agent skills. Arch package names, the `omarchy.org` pacman mirrors, `linux-omarchy`, and the `oma*` tools stay as they are — they are upstream-provided dependencies this repo does not build.

Two compatibility layers keep the rest of the ecosystem working without requiring an Unbloarchy fork of `omarchy-pkgs`: **tracked generated `omarchy-*` wrappers** in `bin/`, which the existing package recipe installs through its `bin/*` loop and which forward to `unbloarchy-*`; and a **`migrations/<epoch>.sh`**, so an existing install upgrades in place instead of breaking. `OMARCHY_PATH` is exported alongside `UNBLOARCHY_PATH` as a deprecated alias for the same reason — it is the one env var external tooling reads. The shim generator also provides exact legacy source-path aliases for defaults the upstream PKGBUILD selects by their old filenames.

Brand artwork splits in two. The icon set is left alone: `icon.png`, `icon.txt`, and the `U+E900` glyph stay byte-identical, because the glyph is the menu icon (`shell/plugins/menu/BarWidget.qml:15`) and `etc/fastfetch/config.jsonc:72` prints it next to the OS name. The ASCII wordmark does not — both `logo.txt` and `logo.svg` spell OMARCHY, so both are regenerated as UNBLOARCHY in the original block letterforms. `unbloarchy ascii` is a separate renderer and is left on Delta Corps Priest 1.

## Rejected approaches

- **Blind `sed -i 's/omarchy/unbloarchy/g'` over the tree.** The word is not one class of thing. It is a command prefix, an env-var prefix, a filesystem path component, a window class, a layer namespace, a plugin id, a font family, a package name, a hostname, a domain, and a human-readable brand. One global substitution converts the human-readable brand correctly and every other class wrongly, in a way that still runs and still lints.
- **Surface-only rebranding** (prose, menu labels, manual, `omarchy --help` output) and stopping there. Cheapest and fully reversible, and it was the first option offered — but it leaves `omarchy` in the hostname, `~/.config/omarchy`, the systemd unit list, and every command name, so the system still reads as Omarchy to anyone who opens a terminal. That does not serve the stated goal.
- **Keeping `bin/omarchy-*` names and rebranding only the prose around them.** Avoids the router rewrite and the shim generator entirely. Rejected because half the visible surface is the command names themselves, and because the router's `${file_binary#omarchy-}` stem derivation makes the brand structural to routing rather than cosmetic.
- **Renaming the Arch package names too** (`omarchy` → `unbloarchy`, `omarchy-settings` → `unbloarchy-settings`, `linux-omarchy` → `linux-unbloarchy`, plus `omarchy-nvim` and the `oma*` tools). The PKGBUILDs live in `omarchy-pkgs`; renaming a package means renaming the pacman repo, the mirror, the signing key, and every `pacman -S` invocation in the installer, and the GPG key that verifies `pkgs.omarchy.org` would no longer match the package name. Out of scope.
- **Standing up Unbloarchy-owned pacman mirrors and a pkg repo.** The mirror is a large infrastructure project with its own signing-key lifecycle, entirely separate from the rename, and it would delay the rebrand by months for no gain in brand surface. `pkgs.omarchy.org` stays.
- **A single mega-commit.** A 15,058-occurrence rename across 1,317 files is unreviewable and unrevertable as one commit, and the router/metadata/security-library coupling means a partial application is worse than none.

## Design

### The identity map

The rename is applied through an explicit substitution table, not a global replace. Each class gets its own rule, and the table is the reviewable artifact. Ordered most-specific first, because several rules share the literal string `omarchy`:

| Class | Rule | Example |
|---|---|---|
| Arch package names | **no change** | `omarchy-settings`, `linux-omarchy`, `omawrite` stay |
| Pacman mirror URLs | **no change** | `https://pkgs.omarchy.org/stable/$arch` stays |
| External repo references | repoint at this fork | `omacom/omarchy` → `Magiclovekorean/unbloarchy` |
| External `oma*` command deps | **no change** | `omarchy-nvim-refresh`, `omarchy-install-emacs` stay |
| `omarchy.org` prose hyperlinks | **remove** | `https://omarchy.org/discord` in docs, manual, skills |
| Icon font family | `unbloarchy` | `fontFamily: "omarchy"` → `"unbloarchy"` |
| Plugin/widget ids | `unbloarchy.*` | `omarchy.clock` → `unbloarchy.clock` |
| Layer-shell namespaces | `unbloarchy-*` | `omarchy-bar` → `unbloarchy-bar` |
| Window/app classes | `org.unbloarchy.*` | `org.omarchy.agent` → `org.unbloarchy.agent` |
| Notification contracts | `unbloarchy-*` | `app_name === "omarchy-action"`, hint `omarchy-exec-argv` |
| Metadata key | `# unbloarchy:` | parser regex at `bin/unbloarchy:205` moves with it |
| Env vars | `UNBLOARCHY_*` | `OMARCHY_PATH` also exported as a deprecated alias |
| Install root | `/usr/share/unbloarchy` | plus `/etc/unbloarchy.conf`, `/var/lib/unbloarchy` |
| User paths | `~/.config/unbloarchy`, `~/.local/state/unbloarchy` | handled by the migration for existing installs |
| Unit/conf filenames | `unbloarchy-*` / `unbloarchy_*` | matches the `etc/` naming convention |
| Command prefix | `unbloarchy-*` | `bin/omarchy-theme-set` → `bin/unbloarchy-theme-set` |
| Display text | "Unbloarchy" / "unbloarchy" | menu labels, summaries, `GROUP_DESCRIPTIONS` |
| GPG keyring / hostname | `unbloarchy` (hostname only) | `install/provisioning/setup-form.sh:84` |

Two rules are deliberately **not** applied to generated art: `icon.png`, `icon.txt`, and the `U+E900` glyph stay as-is. `logo.svg` and `logo.txt` are regenerated, because both spell the old name.

### Phase 0 — Groundwork

Capture the baseline before touching anything: run `./test/cli` and `./test/shell` on the current tree and keep the output as the reference, so a later failure is attributable to the rename rather than pre-existing. Then write the transform as a **throwaway script under `/tmp`**, driven by the table above. It is not committed: it is scaffolding, and committing a rename script invites someone to re-run it against a half-renamed tree.

Establish the commit cadence: one commit per phase, each green on `./test/cli` and `./test/shell`.

### Phase 1 — Rename in place, then fix inbound references

`git mv` the paths, then repair every reference to them. Renaming paths and rewriting references are one commit, because half of either is a broken tree.

```
bin/omarchy                                    → bin/unbloarchy
bin/omarchy-*                     (475)       → bin/unbloarchy-*
default/omarchy/                              → default/unbloarchy/
default/omarchy/omarchy-menu.jsonc            → default/unbloarchy/unbloarchy-menu.jsonc
config/omarchy/                               → config/unbloarchy/
default/agents/skills/omarchy/                → default/agents/skills/unbloarchy/
default/agents/skills/omarchy-app/            → default/agents/skills/unbloarchy-app/
default/fonts/omarchy/omarchy.ttf             → default/fonts/unbloarchy/unbloarchy.ttf
default/sddm/omarchy/                         → default/sddm/unbloarchy/
default/wayland-sessions/omarchy.desktop      → default/wayland-sessions/unbloarchy.desktop
default/plymouth/omarchy.plymouth             → default/plymouth/unbloarchy.plymouth
default/uwsm/env.d/10-omarchy                 → default/uwsm/env.d/10-unbloarchy
default/environment.d/10-omarchy-fcitx.conf   → 10-unbloarchy-fcitx.conf
default/fontconfig/conf.avail/50-omarchy.conf → 50-unbloarchy.conf
default/systemd/zram-generator.conf.d/90-omarchy.conf → 90-unbloarchy.conf
default/systemd/user/omarchy-*.service  (7)   → default/systemd/user/unbloarchy-*.service
install/omarchy-base.packages                 → install/unbloarchy-base.packages
install/omarchy-other.packages                → install/unbloarchy-other.packages
install/provisioning/omarchy-provision-owner.service → install/provisioning/unbloarchy-provision-owner.service
etc/sudoers.d/omarchy-{dns,passwd-tries,theme-browser,tzupdate} → etc/sudoers.d/unbloarchy-*
etc/tmpfiles.d/omarchy-nopasswd-sudo.conf     → etc/tmpfiles.d/unbloarchy-nopasswd-sudo.conf
etc/udev/rules.d/60-omarchy-io-scheduler.rules → etc/udev/rules.d/60-unbloarchy-io-scheduler.rules
etc/sysctl.d/90-omarchy-file-watchers.conf    → etc/sysctl.d/90-unbloarchy-file-watchers.conf
etc/mkinitcpio.conf.d/omarchy_hooks.conf      → etc/mkinitcpio.conf.d/unbloarchy_hooks.conf
etc/limine-entry-tool.d/omarchy-{defaults,uki}.conf → etc/limine-entry-tool.d/unbloarchy-*.conf
etc/profile.d/omarchy.sh                      → etc/profile.d/unbloarchy.sh
docs/omarchy-shell.md                          → docs/unbloarchy-shell.md
manual/01-welcome-to-omarchy.md               → manual/01-welcome-to-unbloarchy.md
manual/14-omarchy-cli.md                       → manual/14-unbloarchy-cli.md
manual/49-omarchy-on.md                        → manual/49-unbloarchy-on.md
test/shell.d/omarchy-kernel-migration-test.sh → test/shell.d/unbloarchy-kernel-migration-test.sh
```

Then repair the inbound references, which is the real volume of the work: `OMARCHY_PATH/bin/omarchy-*` call sites, `~/.config/omarchy`, `~/.local/state/omarchy`, `~/.local/share/omarchy`, `/var/lib/omarchy`, `/usr/share/omarchy`, `/etc/omarchy.conf`, `OMARCHY_PROG`, `OMARCHY_BIN_DIR`.

Two files are **not** renamed even though they match: `test/shell.d/fixtures/legacy-icon-font/omarchy.ttf` (a fixture that must keep the old name, since it exists to prove the migration cleans up the legacy font) and `default/snapper/root`, whose `omarchy` string is a snapper config-template name that the migration must find under the old name.

### Phase 2 — The router and the security library

These two break silently, so they get explicit attention and their own commit rather than riding the bulk substitution.

**The router.** `bin/omarchy` is 1,118 lines and hard-codes the brand in 13 places:

- `:318` — the discovery glob `"$OMARCHY_BIN_DIR"/omarchy-*`. This is the blocker. A `for` over a non-matching glob leaves the loop body unexecuted, `load_commands` registers nothing, and the CLI reports "no such command" for everything. No error, no diagnostic.
- `:254` — `local stem="${file_binary#omarchy-}"`, which drives group/name/route derivation for every command.
- `:257` — `local fallback_route="omarchy ${stem//-/ }"`.
- `:269` — `local route="omarchy $group"`, the canonical route prefix.
- `:337`, `:347`, `:357`, `:392`, `:396` — child and group lookups building `omarchy-$group`.
- `:413-415` — direct-route resolution: `route="omarchy $(join_words ...)"` and `binary="omarchy-$(join_words "-" ...)"`.
- `:442`, `:934`, `:953` — further route prefixes.

**The metadata parser.** `:205` matches `^[[:space:]]*#[[:space:]]*omarchy:([[:alnum:]_-]+)=(.*)$`, and the recognized keys are `group`, `name`, `summary`, `args`, `examples`, `alias`/`aliases`, `requires-sudo`, `hidden` (`:211-242`). Unknown keys are silently dropped (`:240-241`), so a typo is invisible. All 476 `# omarchy:...=` header lines must become `# unbloarchy:...=` in the same commit as the regex. `:248` (which excludes `omarchy:`-prefixed comments from the fallback-summary heuristic) and `:268` (the `"Run the ${stem//-/ } command"` default) move too. `agents/skills/command-metadata.md` documents this convention and updates in the same commit.

`GROUP_DESCRIPTIONS` (`:29-97`, 69 entries, 10 of which say "Omarchy") is reworded by hand — these are user-facing help strings, and mechanical substitution would produce "Unbloarchy shell bar layout", which is fine, but it needs review for grammar.

**The security library.** `bin/omarchy-security-functions` renames to `bin/unbloarchy-security-functions` together with all six call sites, because a half-moved trust anchor is a security regression rather than a lint failure:

- 5 entrypoints via `source "${security_entrypoint%/*}/omarchy-security-functions"` — `bin/omarchy-channel-set:11-12`, `bin/omarchy-refresh-pacman:11-12`, `bin/omarchy-sudo-passwordless:11-12`, `bin/omarchy-update-stay-awake:12-13`, `bin/omarchy-update:14-15`.
- `default/omarchy/sudo-no-update/sudo:9-10` via a relative `${n%/*}/../../../bin/` hop, so the library name and the sudo wrapper's packaged depth must agree.
- The library's own guard at `:48-55` compares the invoked command's basename against `$OMARCHY_PATH` before granting privilege, refusing a same-named binary found outside the trusted tree. `AGENTS.md` documents this as the boundary that permits the exact `#!/bin/bash -p` form, and `test/cli` has a regression that rejects an ordinary Bash launch carrying a decoy `-p`. That regression must keep passing after the rename.

**The absolute `/usr/bin/*` pin cluster.** Eight scripts hard-pin an installed path that deliberately does not follow `$OMARCHY_PATH`, because they must survive `omarchy dev link`. They move as one indivisible group with the sudoers, PAM, and ALPM hook files that name them:

- `bin/omarchy-dns:46` `PACKAGED_PATH=/usr/bin/omarchy-dns` (re-exec at `:66,68`), matched by `etc/sudoers.d/omarchy-dns`
- `bin/omarchy-theme-set-browser-policy:33` (re-exec `:69,71`), matched by `etc/sudoers.d/omarchy-theme-browser`
- `bin/omarchy-install-chromium-claude:14` (re-exec `:40,42`)
- `bin/omarchy-sudo-passwordless:33` `readonly INSTALLED_SELF=/usr/bin/omarchy-sudo-passwordless`, used at `:335,415,417,420,443`, and named by the ALPM hook `Exec = /usr/bin/omarchy-sudo-passwordless __package-removing` (`:226`)
- `bin/omarchy-windows-vm:65` probes `/usr/bin/omarchy-windows-vm`; `:1585` and `:164` use it as a log prefix
- `bin/omarchy-setup-security-fingerprint:15-19` — PAM `pam_exec.so quiet /usr/bin/omarchy-hw-laptop-closed`, which must be a literal absolute path that survives dev-link
- `bin/omarchy-refresh-limine:8` — cleans `/boot/EFI/Linux/omarchy_linux.efi`, named by `CUSTOM_UKI_NAME="omarchy"` in `etc/limine-entry-tool.d/omarchy-defaults.conf:13`
- `bin/omarchy-apply-lock:12` — `PATH=/usr/share/omarchy/bin:...` when running as root

Each repoints at `/usr/bin/unbloarchy-*`. The generated shims (Phase 7) keep the old paths resolving, which is what preserves the `omarchy-settings`-owned ALPM hooks and sudoers entries in the other repo.

### Phase 3 — Environment variables

324 unique `OMARCHY_*` → `UNBLOARCHY_*` across bash, QML (`Quickshell.env`), Lua (`os.getenv`), systemd `Environment=`, and sudo `env_keep`. The test-only variables (`OMARCHY_TEST_*`, `OMARCHY_ACCEPTANCE_*`) rename too — a partial rename is how a suite ends up asserting on a variable nothing sets.

`default/bash/env-bootstrap` is the single source of truth and states its own contract in comments, so it is edited first and everything else follows from it:

- `/etc/omarchy.conf` → `/etc/unbloarchy.conf`, and `/usr/share/omarchy` → `/usr/share/unbloarchy`
- exports `UNBLOARCHY_PATH`, and **also exports `OMARCHY_PATH` as a deprecated alias** so that `omarchy-iso`, `omarchy-settings`, and any user dotfile still resolve
- the dev-link `PATH` prepend guard becomes `if [ "$UNBLOARCHY_PATH" != /usr/share/unbloarchy ]`

Its four documented sources move in step: `/etc/profile.d/unbloarchy.sh`, `/etc/skel/.bashrc`, `/usr/share/uwsm/env.d/10-unbloarchy`, and the bash rc chain under `$UNBLOARCHY_PATH/default/bash/envs`.

The rest of the phase is bookkeeping with real failure modes:

- `install/user/first-run/enable-user-units.sh:16-24` hard-codes the systemd enable list, so it moves with the 7 renamed units in `default/systemd/user/`, and with the two units written at runtime — `omarchy-nvme-suspend-fix.service` (written to `/etc/systemd/system/`) and `omarchy-provision-autologin-once.service` (`bin/omarchy-provision-owner:794`).
- PAM files `/etc/pam.d/omarchy-lock-password` (`bin/omarchy-apply-lock:31`) and `/etc/pam.d/omarchy-lock-fingerprint` (`bin/omarchy-apply-lock:46`, removed at `:52`; also `bin/omarchy-setup-security-fingerprint:61`, `bin/omarchy-remove-security-fingerprint:40-42`, `install/user/first-run/setup-fingerprint.hook:7`) move with their QML readers at `shell/plugins/lock/Service.qml:485,619`.
- `/etc/tmpfiles.d/omarchy-nopasswd-sudo.conf:5` retargets `r! /etc/sudoers.d/99-omarchy-nopasswd-*`.
- Lock files and log tags: `omarchy-theme-set.lock` (`bin/omarchy-theme-set:18`), the `omarchy-sudo-passwordless` lock, `$XDG_RUNTIME_DIR/omarchy.log` (`bin/omarchy-debug`), `$OMARCHY_PATH/shell` log `theme-set-herdr-machines.log` (`:446`), the journald tag `omarchy-shell` (`bin/omarchy-launch-shell:19,85,89`), and `/var/log/omarchy-install.log` (`bin/omarchy-apply-system:77`).
- `OMARCHY_SETUP_CONTEXT` ∈ {`runtime`, `iso-chroot`, `provision-owner`} keeps its values — `omarchy-iso` sets them, so the values are part of the cross-repo contract even though the variable name is not.

### Phase 4 — Shell and QML identities

These are runtime contracts matched by the compositor, not labels. Every producer moves together with its consumer or the desktop breaks in ways no test catches.

**Layer-shell namespaces** (16): `omarchy-bar`, `omarchy-bar-drag-ghost`, `omarchy-bar-move-ghost`, `omarchy-menu`, `omarchy-emojis`, `omarchy-clipboard`, `omarchy-keyboard-panel`, `omarchy-keyboard-panel-dismiss`, `omarchy-osd`, `omarchy-reminders`, `omarchy-network-qr`, `omarchy-background`, `omarchy-lock-preview`, `omarchy-image-selector`, `omarchy-polkit`, `omarchy-notifications` (`shell/plugins/notifications/Service.qml:1005`), `omarchy-speed-test`. The two consumer rules are `default/hypr/apps/omarchy-shell.lua:4` (bar) and `:13` (a regex alternation over the popup set). That file renames to `default/hypr/apps/unbloarchy-shell.lua` in the same commit, since Hyprland loads it by path.

**Window and app classes**: `org.omarchy.screensaver`, `org.omarchy.about`, and `org.omarchy.agent` (fixed in `bin/omarchy-agent`), plus the shell's own `appid: "omarchy"` at `shell/shell.qml:1611`. The `default/hypr/apps/{system,terminals}.lua` rules that match them move too.

**Bar and widget ids** (~60): `omarchy.bar` (`shell/shell.qml:172`) and the 15 ids in `config/omarchy/shell.json:10-63` — `omarchy.clock`, `omarchy.menu`, `omarchy.workspaces`, `omarchy.indicators`, `omarchy.elsewhen`, `omarchy.keyboard-layout`, `omarchy.weather`, `omarchy.system-update`, `omarchy.tray`, `omarchy.agents`, `omarchy.bluetooth`, `omarchy.network`, `omarchy.audio`, `omarchy.monitor`, `omarchy.power`. These are the argument vocabulary of `unbloarchy bar put|move|set` (`bin/omarchy-bar:43-47,147,151,167-168`) and they are also the IPC targets of 11 `shell/plugins/**/Panel.qml` files. `default/omarchy/shortcuts` names them too (`panel omarchy.clipboard`). Note the legacy predecessor `omacom.elsewhen` → `omarchy.elsewhen` rename in `migrations/1790528634.sh` as precedent for exactly this migration.

**Notification contracts**: `app_name === "omarchy-action"` at `shell/plugins/notifications/NotificationLogic.js:120,126` and the `omarchy-exec-argv` desktop hint at `NotificationLogic.js:150` ↔ `bin/omarchy-notification-send:150,179`.

**Icon font family**: `"iconFont":"omarchy"` in 6 manifests (`shell/plugins/lock/manifest.json:8`, `shell/plugins/polkit/manifest.json:8`, `shell/plugins/bar/widgets/{KeyboardLayout,Tray}.manifest.json:20`, `shell/plugins/bar/widgets/Indicators.manifest.json:70`) and `fontFamily: "omarchy"` at `shell/plugins/menu/BarWidget.qml:16`.

There are no DBus well-known names and no `StartupWMClass=omarchy` in any shipped `.desktop`, which is one less thing to migrate.

### Phase 5 — Brand text and assets

- `logo.txt` and `logo.svg` both regenerate as "Unbloarchy" in the same block style. They are one wordmark in two forms — the SVG is a vectorisation of the ASCII grid, not separate artwork — so leaving either one spelling OMARCHY would ship a mismatched pair. `icon.txt` and `icon.png` are untouched and stay byte-identical. Letters the original already had (`O M A R C H Y`) are reused verbatim from `git show HEAD:logo.txt`; only `U N B L` are new, drawn in the font's own vocabulary — 3-wide stems, 3-space counters, ` ▄█`/`█▄ ` rounded stem caps and `▀` bar terminals. `logo.svg` is regenerated on the original's 15-unit grid (10 letter paths, one per letter, vertically merged rectangles) rather than retraced, so its geometry is exact instead of carrying the old file's fractional tracing drift.
- `bin/unbloarchy-ascii` keeps the Delta Corps Priest 1 FIGlet font, but its examples and usage text change from `Omarchy` to `unbloarchy` (`:5`). It is **not** the font the logo is drawn in — the logo is a narrower face with 9-wide letters against Delta Corps Priest 1's 11 — so both the `:3` summary and the `:13` usage text stop claiming the logo was drawn in it. `manual/41-branding.md:49` carries the same false claim and is corrected; its `~/.config/unbloarchy/branding/screensaver.txt` example at `:52` was already rebranded and needed no change.
- The icon font's *family*, *file*, and *install path* rename to `unbloarchy` (`/usr/share/fonts/unbloarchy/unbloarchy.ttf`); the `U+E900` glyph artwork stays. `default/fonts/unbloarchy/README.md` is rewritten to describe the new family, and its charset table keeps `e900-e90e` so `test/shell.d/menu-test.sh:662` still holds.
- Generated theme-name artifacts all move: `omarchy-system` (Pi, `default/themed/pi.json.tpl:3`), `Omarchy` (Claude `claude.json.tpl:2`, T3 `t3code.json.tpl:2`, VS Code `vscode-theme.json:2`), `omarchy` (Hermes skin `hermes.yaml.tpl:1` + `bin/omarchy-theme-set-hermes:16`, Helix `bin/omarchy-install-editor-helix:11,16` → `~/.config/helix/themes/omarchy.toml`, VS Code extension `local.omarchy-theme-1.0.0` under `~/.vscode/extensions/omarchy-theme/`), SDDM `Current=omarchy` in `etc/sddm.conf.d/10-theme.conf`, the Plymouth theme, and `default/snapper/root` → `/etc/snapper/config-templates/unbloarchy`.
- `default/wayland-sessions/omarchy.desktop` → `unbloarchy.desktop`, with `Name=Unbloarchy (Hyprland uwsm)` and `Comment=Unbloarchy Hyprland session managed by uwsm`. Its `Exec=` line has no brand in it.
- `etc/fastfetch/config.jsonc:72` prints `"\ue900 OS"`; the glyph stays, the adjacent OS name becomes Unbloarchy.
- `install/provisioning/setup-form.sh:84` changes the default hostname from `omarchy` to `unbloarchy`, and the prompt placeholder at `:155-161` follows.
- `etc/limine-entry-tool.d/unbloarchy-defaults.conf` changes `TARGET_OS_NAME="Omarchy"` → `"Unbloarchy"`, `interface_branding: Omarchy Bootloader` → `Unbloarchy Bootloader` (`default/limine/limine.conf:4`), `CUSTOM_UKI_NAME` → `unbloarchy` (which moves `/boot/EFI/Linux/omarchy_linux.efi` and the `bin/unbloarchy-refresh-limine:8` cleanup with it), and `BOOT_ORDER` keeps `linux-omarchy` because the kernel package is not renamed.
- `default/sddm/unbloarchy/metadata.desktop` gets `Name=Unbloarchy` and an `Author=Unbloarchy` line.

### Phase 6 — Documentation, attribution, and external links

**Prose rewrite**: all 51 manual pages that mention the brand, 11 `docs/` files, 7 `plans/` files, `AGENTS.md`'s "Privilege Escalation" pointer, and the 7 repo `agents/skills/` guides. The manual's section titles follow their filenames, so `01-welcome-to-unbloarchy.md` and `14-unbloarchy-cli.md` need their headings and cross-links updated in step.

**Remove every `omarchy.org` hyperlink** from fork-owned prose. Upstream-only package/signature endpoints remain explicitly identified as upstream dependencies; the diagnostic uploader is a pending policy decision. The files and lines to address include:

- `.github/SECURITY.md:5,7,17,41` — the security team link, the `security@omarchy.org` address, and two security-credits links. All of these point at an upstream team that does not handle Unbloarchy reports; they get replaced with this fork's own reporting path.
- `.github/ISSUE_TEMPLATE/config.yml:7` — the Discord link in the support-URLs block.
- `manual/02-getting-started.md:5` (the ISO link) and `:39` (the community support link)
- `manual/06-themes.md:9` and `manual/43-making-your-own-theme.md:45` — the extra-themes page and the `omacom-io/omarchy-site` repo
- `manual/48-security.md:31,33` — these stay as explicit upstream keyring/signature references, not Unbloarchy-owned links
- `README.md:59`
- `default/agents/skills/unbloarchy/SKILL.md:16`, `.../contributing.md:14,29`, and `default/agents/skills/diagnose-crash/reporting.md:30`

**Keep** the functional mirror URLs, untouched: `default/pacman/pacman-{stable,rc,edge}.conf`, `default/pacman/mirrorlist-{stable,rc,edge}`, the detection greps in `bin/unbloarchy-version-channel`, and `migrations/1788112314.sh:8-10`. `bin/unbloarchy-theme-set-obsidian:23` keeps `https://omarchy.org` as the theme's `authorUrl`, since the themes are upstream's.

**Repoint this fork's own references** at `Magiclovekorean/unbloarchy`:

- `bin/unbloarchy-channel-set:52` — the dev channel currently clones `https://github.com/omacom/omarchy.git` into `~/omarchy`. That is a live runtime dependency on the upstream repo, and the most consequential single line in the rebrand: after this change, `unbloarchy channel set dev` develops against the fork.
- `default/agents/skills/diagnose-crash/reporting.md:43,44,62,77,85` — `gh --repo omacom/omarchy` → `--repo Magiclovekorean/unbloarchy`
- `default/agents/skills/unbloarchy/contributing.md:6,12,46,57` — the repo URL, discussions, `gh issue create`, and `gh repo fork`
- `bin/unbloarchy-upgrade-to-quattro:968` — the legacy fallback that curls `https://github.com/omacom/omarchy/archive/refs/heads/master.tar.gz` and then requires the extracted root to be `omarchy-master/` (`:969-970`). Repoint at the fork and expect `unbloarchy-master/`. This is a legacy-migration path with no live callers on a fresh install, so it is low risk either way.
- `bin/unbloarchy-update-confirm:11` — the "What's new" URL becomes this fork's releases.
- `manual/30-updates.md:5,13` and `manual/32-shell-plugins.md:98` and `manual/49-unbloarchy-on.md:9,13,17` — channel, plugin-development, and VM-guide links, each marked as pointing at Omarchy's official documentation.

**Attribution and legal posture.** This lands in the same release as the rename, not after it, because the install keeps the upstream logo, the `omarchy` and `omarchy-settings` package names, `linux-omarchy`, the `oma*` tools, and the `pkgs.omarchy.org` mirror — so the system will still visibly and nominally resemble Omarchy, and the statements below are what make that honest rather than misleading.

- `LICENSE` keeps `Copyright (c) David Heinemeier Hansson` verbatim; MIT requires retaining it and the fork does not relicense upstream's work.
- A **non-affiliation** statement in `README.md`, the `LICENSE` header, and `manual/01-welcome-to-unbloarchy.md`: Unbloarchy is an unofficial, independent fork of Omarchy, is not affiliated with, endorsed by, or sponsored by Omarchy LLC or David Heinemeier Hansson, and any issue found here should be reported to the fork, not upstream.
- A **trademark** statement alongside it: "Omarchy" is a trademark of its respective owner, used here only to identify the upstream project that this fork derives from, with no implication of endorsement or sponsorship.
- Every place the manual or docs still link to Omarchy's wiki, manual, or discussions says so at the point of the link — that the destination is *Omarchy's official documentation, not Unbloarchy's* — rather than leaving the reader to assume the link resolves to the fork's own docs.
- `README.md` credits `https://github.com/omacom/omarchy` as the upstream project, and the build section still clones `omarchy-iso` and `omarchy-pkgs` from upstream (that is a real dependency, not a branding leftover).

### Phase 7 — The compat shim generator

A `/usr/share/omarchy` compatibility path alone does **not** keep command names working. The unmodified upstream `omarchy` PKGBUILD copies executable entries from `bin/*` into `/usr/bin` and its `/usr/share/omarchy/bin/` symlink farm. Keep old command names in the source tree so that build installs both names without any `omarchy-pkgs` fork.

`install/helpers/generate-compat-shims.sh` walks the executable `bin/unbloarchy-*` files and emits one executable forwarding wrapper per command, idempotently. These generated wrapper files are tracked, not ignored: the package source must contain them before the existing package recipe runs. It also creates the bare `bin/omarchy` router wrapper, which the current `bin/*` loop does install:

- `bin/omarchy` → `exec unbloarchy "$@"`
- `bin/omarchy-<x>` → `exec unbloarchy-<x> "$@"`
- `bin/omarchy-security-functions` → a **source-forwarding stub** (`source "${0%/*}/unbloarchy-security-functions"`), not an `exec`, because six files source it and `exec` would run it in a subshell and discard every function it defines
- `bin/omarchy-dev-font` is special-cased rather than shimmed: it is Python invoked as `python3`, not executed, and it hardcodes the font path at `:5` (docstring), `:580` (the real default resolution), and `:605` (help text), plus brand strings at `:2,3,4,556,607,645,648` that all move with the rest

The generator also creates exact legacy source-path aliases used by the upstream `omarchy-settings` PKGBUILD, including old UWSM, font, session, systemd, and hook filenames. It does not rewrite unrelated upstream identities such as package names, window classes, or skill directories. The wrappers keep `/usr/bin/omarchy-*` working for the `omarchy-settings`-owned ALPM hooks, sudoers entries, PAM `pam_exec`, and `omarchy-iso` chroot entrypoints while forwarding command behavior to `unbloarchy-*`.

The upstream package continues to own `/usr/share/omarchy`; runtime bootstrap and install setup expose `/usr/share/unbloarchy` as its compatibility path. No changes to the upstream package repository are needed.

### Phase 8 — The migration

`migrations/<epoch>.sh`, read against `agents/skills/migrations.md` first. `migrations/1788848726.sh` (moving the icon font and purging its legacy `~/.local/share/fonts` and `~/.config` copies) and `migrations/1790528634.sh` (renaming a shell plugin id) are the two closest precedents — both are the same shape of job, and both are the reason this migration is routine rather than novel.

The migration moves an existing install forward, in this order so no step observes a half-moved tree:

- **Config and state**: `~/.config/omarchy` → `~/.config/unbloarchy`, `~/.local/state/omarchy` → `~/.local/state/unbloarchy`, `~/.local/share/omarchy` → `~/.local/share/unbloarchy`. The state tree carries `current/{theme,theme.name,next-theme,background}`, `theme-backgrounds`, `toggles/` (and `toggles/crash-capture-off`, `toggles/hypr/`), `workspace-layouts`, `done/{finalize-user,first-run-user}`, `migrations/`, `agents/usage/`, `backup/status.json`, `provisioning/`, and the `upgrade-to-quattro-*` scratch dirs. `docs/file-layout.md` states the intended split: `~/.local/state` for generated theme state, `~/.config` for what a user might version in a dotfile manager.
- **Widget ids**: rewrite the 15 ids in `~/.config/unbloarchy/shell.json` plus `omarchy.bar`, so an upgraded user's bar layout survives. This is the highest-value line in the migration; without it every widget silently disappears from the bar.
- **Systemd**: `systemctl --user disable` the 7 old units, rename, `enable` the new ones, then `systemctl --user daemon-reload`. Include the two runtime-written units and the legacy `omarchy-seamless-login.service` from `bin/omarchy-upgrade-to-quattro:1314,1436-1438`.
- **System files**: `/etc/omarchy.conf` → `/etc/unbloarchy.conf` (preserving a `omarchy dev link` checkout in its `OMARCHY_PATH`), `/var/lib/omarchy` → `/var/lib/unbloarchy`, `/var/log/omarchy-install.log` → `/var/log/unbloarchy-install.log`, the two `/etc/pam.d/omarchy-lock-*` files, the 4 `etc/sudoers.d/omarchy-*` entries, tmpfiles, sysctl, udev rules, the mkinitcpio and Limine confs, and `/etc/snapper/config-templates/omarchy`.
- **Fonts**: purge `~/.local/share/fonts/omarchy.ttf` and the historically-wrong `~/.config/omarchy.ttf` before installing the new family, because Qt will keep matching a stale copy and silently render the old glyphs — the failure `agents/skills/icon-font.md:73` warns about.
- **Install root**: `/usr/share/omarchy` → `/usr/share/unbloarchy`, then create the compat symlink, then re-run the shim generator so `/usr/bin/omarchy-*` exists before any hook fires.

### Phase 9 — Tests and verification

5,905 occurrences across ~310 files. The bulk is mechanical, but three classes need hand attention because they assert on literals:

- `test/cli` (177 occurrences) pins `CLI="$ROOT/bin/omarchy"`, `ln -s "$CLI" "$TMPDIR/omarchy"`, the `find "$ROOT/bin" -name 'omarchy-*'` discovery loop, the `# omarchy:summary=` schema assertion, `"Omarchy command center"`, `"omarchy theme set <theme-name>"`, `omarchy-system`, `omarchy-camera…`, 5 named binaries plus `omarchy-apply-{system,hardware,lock}`, the `.local/state/omarchy/current/*` and `.config/omarchy/themed` fixtures, and `.local/state/omarchy` itself. The `-p` decoy regression must keep passing against the renamed security library.
- `test/shell.d/menu-test.sh` pins `defaultById['update.omarchy'].icon === '\ue900'` (`:206`) and the font charset `e900-e90e` (`:662`).
- `test/shell.d/ascii-test.sh` has 11 fixtures passing `Omarchy` to `omarchy-ascii`; they become `unbloarchy`, and the "no glyph for digits" assertions (`:111,117,129`) still hold because Delta Corps Priest 1 draws letters and spaces only.
- `test/acceptance` pins `/tmp/omarchy-acceptance`, `OMARCHY_PATH=/usr/share/omarchy`, `--sync-omarchy`, and `OMARCHY_ACCEPTANCE_*`; `test/acceptance.d/` adds 167 occurrences across 9 files.

Gates: `./test/cli`, `./test/shell`, then `./test/all`. `test/all` and `test/shell` are pure runners and need no changes themselves.

Then visual verification per `agents/skills/visual-verification.md`, because most of this rename is invisible to the test suite: the menu (label, icon, and the `Learn` entry's target), the bar and every widget, the OSD, the screensaver, the lock screen, the notifications panel, the polkit agent, the about dialog, `fastfetch`, the SDDM greeter, the Plymouth boot splash, the Limine bootloader menu, and `unbloarchy ascii` output in a terminal.

## Sequencing

Each step is one commit, green on `./test/cli` and `./test/shell`:

1. Phase 0 groundwork and baseline capture
2. Phase 1 path renames plus inbound references
3. Phase 2 router, metadata schema, security library, absolute pins
4. Phase 3 env vars and `env-bootstrap`
5. Phase 4 shell namespaces, window classes, widget ids, font family
6. Phase 5 brand text and assets
7. Phase 6 documentation, attribution, external links
8. Phase 7 generated command wrappers and legacy package-source aliases, with no external PKGBUILD changes
9. Phase 8 migration
10. Phase 9 test fixes and visual verification

Phases 1-4 are the risky ones and want the most careful review, because a mistake there produces a tree that passes its own tests while the desktop is subtly wrong. Phases 6-8 are the ones that can slip if attention fades.

## Open questions

1. **`logs.omarchy.org`.** **Decided: disable the uploader.** The user confirmed it is not stats collection and chose removal over keeping the upstream endpoint or making it configurable. Landed as `918faa4f`; see the 2026-10-03 entry below.
2. **Branded wallpaper art, SDDM logo, and screenshots.** Leave ordinary wallpapers unchanged. OCR spot-checks detected the old Omarchy wordmark in multiple `themes/*/backgrounds/*unbloarchy*` images and in `default/sddm/unbloarchy/logo.png`; the SDDM QML and metadata are already branded Unbloarchy, so the logo artwork is the stale part. The existing `preview*.png`, `unlock.png`, and relevant `manual/images/*.webp` also need an audit for old command labels/branding. The user does not plan to refresh these personally; they created #4 inviting a contributor to inspect and update affected assets in a PR. This contributor task is not a blocker for the user's ISO build.
3. **`omarchy-iso` invocation.** Decision: keep compatibility wrappers so the upstream ISO builder can continue calling `omarchy-apply-system`, `omarchy-provision-user`, and `omarchy-apply-hardware` in the target chroot. The wrappers and the package source aliases are generated and tracked in this repository; the upstream `omarchy-pkgs` checkout remains unchanged. This avoids maintaining an Unbloarchy-specific package-repository fork.
4. **`version`.** **Decided: an independent version.** Landed as `87a7f135` as `4.0.0.alpha.unbloarchy.1`, not the `4.0.0-unbloarchy.1` sketched here — see that entry for why the hyphen form is unsafe and why the ordering had to be checked rather than assumed.

## Progress log

Append-only. Newest entry last.

### 2026-10-02 — Phase 0 groundwork, Phase 1-4 mass transform applied

Status: Phase 0 complete. Phases 1-4 applied to the working tree but **uncommitted**, because the verification gate below could not be run.

**Baseline (captured on a machine with a full FHS, not in the Nix dev sandbox):**

- `./test/cli` — passing.
- `./test/shell` — 3215 `ok`, 48 `not ok`, 36 unique failures, all attributable to missing host tooling (`jq`, `magick`, `lua`, `gio`, `socat`, `updatedb`, `docker`, `mise`). Logs in `/tmp/opencode/`.

**Transform applied**

- 585 tracked paths renamed; 1305 files rewritten; 773 `omarchy` occurrences remain, all reviewed as intentional.
- Protected and left untouched: upstream packages (`omarchy`, `omarchy-settings`, `omarchy-settings-dev`, `omarchy-dev`, `omarchy-keyring`, `omarchy-nvim*`, `omarchy-emacs`, `linux-omarchy*`), upstream mirrors and `pkgs.omarchy.org` / `logs.omarchy.org`, the `omacom` GitHub org, external `oma*` commands, `icon.png` / `icon.txt` / `U+E900`, and the legacy bridge `bin/unbloarchy-upgrade-to-quattro` (only its `# unbloarchy:*` metadata header was rewritten). `logo.svg` was originally listed here too; it moved out of this list when the wordmark was regenerated in Phase 5, because it spells the old name.
- Intentionally still spelled the old way: `test/shell.d/fixtures/legacy-icon-font/omarchy.ttf`.

**Three transform bugs found in review and fixed by hand**

1. `test/shell.d/config-test.sh` — the upstream `omarchy-pkgs` package directory `"unbloarchy/PKGBUILD"` → `"omarchy/PKGBUILD"`.
2. `test/shell.d/version-test.sh` — the comment `provides=(unbloarchy)` → `provides=(omarchy)`, since that describes the upstream `omarchy-dev` package's `provides` declaration.
3. `test/shell.d/version-test.sh` — `version unbloarchy` → `version omarchy`, matching the `pacman -Q` argument `bin/unbloarchy-version` actually passes.

Root cause for all three: the throwaway transform protected `omarchy-dev` / `omarchy-settings*` but not the bare `omarchy` package name.

**Phase 3 alias**

`default/bash/env-bootstrap` now exports `OMARCHY_PATH` mirroring `UNBLOARCHY_PATH`, so pre-rename software still resolves the checkout without becoming a second source of truth.

**Verification gate — NOT MET**

`./test/cli` and `./test/shell` cannot execute in the Nix dev sandbox: `/bin` is empty (every `#!/bin/bash` fails with `bad interpreter`), and `jq`, `magick`, `lua`, `gio`, `socat`, and `/usr/lib` are absent. The suites must be run on a real target before these phases are committed. What did run here:

- `bash bin/unbloarchy commands --check` — passes, 473 commands.
- `bash bin/unbloarchy commands` — renders, 403 lines.
- `bash -n` across all 802 bash-shebang files — clean.

**Still outstanding**

Phase 2 absolute `/usr/bin/unbloarchy-*` pin review, Phase 5 brand text and assets, Phase 6 documentation/attribution, Phase 7 shim generator, Phase 8 migration, Phase 9 test fixes and visual verification. Phase 7 remains externally blocked until `omarchy-pkgs` calls the generator in `prepare()`.

### 2026-10-02 — Verification gate met; Phases 1-4 committed

Status: the verification gate from the previous entry is now met. Phases 1-4 are committed as `c68863a7` plus seven focused follow-up commits. Phase 5-9 work is still outstanding.

**Getting the suites to run**

The Nix dev sandbox has no `/bin` and is missing `jq`, `magick`, `lua`, `gio`, and `socat`, so both suites used to abort on the first file. Two throwaway helpers unblocked them without touching the system: `/tmp/opencode/with-bash.sh` unshares a mount namespace and binds the Nix `bash` over `/bin`, and `/tmp/opencode/run-suite.sh` supplies the missing tools. Neither is committed.

A pre-rename worktree at `/tmp/opencode/pre-rename` (from `14a8db5e`) gives a **same-sandbox** baseline, which is the only fair comparison here — the earlier full-FHS baseline counts a different set of environmental failures.

**Results**

- `./test/cli` — 118 `ok`, 0 `not ok`, exit 0.
- `./test/shell` — 3156 `ok`, 40 `not ok`, exit 127, identical to the same-sandbox baseline (3156/40). All 40 remaining failures are environmental (`/usr/bin/python3`, `vercmp`, sibling `omarchy-pkgs` checkout). Per-suite assertion counts match the baseline for all 268 suites, so nothing is silently aborting.

Counting per-suite assertions mattered: four suites were dying mid-file on a bare `grep` under `set -e`, which showed as a lower total rather than as a failure. Per-suite parity with the baseline is what surfaced them.

**Bugs the suites found, beyond the previous entry's three**

The transform protected multi-part upstream names but not the bare ones, and it skipped the legacy bridge body wholesale. Both assumptions were wrong:

1. `bin/unbloarchy-update-available` assigned `package=unbloarchy`; `bin/unbloarchy-update-system-pkgs-when-conflicted` parsed the conflict report with `^unbloarchy(-dev|...)`; the three ALPM hooks declared `Depends = unbloarchy`. The Arch package is still `omarchy`, so all four were silently looking for a package that does not exist.
2. `test/shell.d/update-available-test.sh` stubbed pacman to match the wrong name, hiding #1.
3. The Neovim provider fixtures had been rebranded, breaking the sha256 allowlist in `migrations/1788996284.sh`. They model historical upstream bytes and are restored.
4. **The legacy bridge was rebranded in the wrong direction.** Leaving its body alone was not the safe choice: everything it does *after* `install_unbloarchy_quattro_packages` was still calling renamed commands under old names, so the theme refresh, update steps, migrations, sleep lock, and application launchers either ran legacy binaries or matched nothing. `enable_user_unit omarchy-sleep-lock.service` was the worst of these — the unit no longer exists and the helper returns 0 on a miss, so it did nothing at all. Post-install steps now use the new commands, helpers, `/usr/share/unbloarchy` paths, and `UNBLOARCHY_*` variables. Steps that *read or remove* the old system keep their `omarchy` spelling.
5. `preserve_kernel_cmdline_root` now checks both `unbloarchy_linux*.efi` and `omarchy_linux*.efi`. Pre-rename UKIs are still on disk and still bootable, so matching only the new name would let one boot unverified.

**Three mechanically-rebranded test expectations were wrong** and are corrected to name pre-rename artifacts: the `omarchy-snapshot` call (it runs before the packages go in), the dev-link `ExecStart` string being repaired, and the stale `99-omarchy-nofile.conf` drop-in (Unbloarchy ships no nofile drop-in of its own). A fourth, `root_path`, was the reverse case: my first change added `/usr/share/omarchy/bin` to root's `PATH`, and the suite was right to reject it — that is a user-writable legacy checkout path and belongs off the root `PATH`.

**Still outstanding**

Phase 2 absolute `/usr/bin/unbloarchy-*` pin review, Phase 5 branded wallpaper audit/regeneration and visual verification, Phase 6 final reference review, Phase 7 external PKGBUILD integration, Phase 8 rename migration, Phase 9 visual verification. The generator and its focused test now exist in this repository; ISO compatibility is still incomplete until `omarchy-pkgs` calls the generator in `prepare()` and explicitly packages the bare `bin/omarchy` router shim. Absolute zero-failure runs still need a real target; the sandbox cannot reach them.

### 2026-10-02 — Phase 5 wordmark regenerated in both forms

Status: the Phase 5 wordmark is regenerated, pinned by a new suite, and verified. Phase 5 is otherwise incomplete — the wallpaper logos and the `omarchy-iso` invocation are still open questions below — and Phases 6-9 are untouched.

**The plan's artwork rule was wrong, deliberately overruled**

The plan protected `logo.svg` on the grounds that the icon set carries no ASCII and so cannot spell the old name. That reasoning does not transfer to the wordmark: `logo.txt` *and* `logo.svg` both spelled OMARCHY, so protecting one would ship a mismatched pair with the old name visible in the vector form. Both regenerate; `icon.png`, `icon.txt`, and `U+E900` stay byte-identical.

**The logo font is not Delta Corps Priest 1**

The committed `logo.txt` is a narrower face than the FIGlet renderer uses — 9-wide letters against Delta Corps Priest 1's 11 — so the previous `unbloarchy-ascii` summary claiming it drew "the font the Unbloarchy logo is drawn in" was simply false. The claim turned out to be load-bearing in three places rather than the one the plan named: `bin/unbloarchy-ascii:3` (the `:summary` metadata), `bin/unbloarchy-ascii:13` (the `usage()` heredoc), and `manual/41-branding.md:49`, which told users the font would match the wordmark they could see in the same file. All three now name the font and state plainly that it is not the wordmark's face. `bin/unbloarchy-ascii` stays on Delta Corps Priest 1 and `2f65300d`'s own reference rendering was always correct; only the prose around it was wrong. A repo-wide grep for the claim, `delta corps`, and `figlet` found no fourth instance.

**What was drawn**

`O M A R C H Y` are reused verbatim from `git show HEAD:logo.txt` rather than redrawn, so the surviving letters are byte-identical to the original. Only `U N B L` are new, built from the font's own vocabulary: 3-wide stems, 3-space counters, ` ▄█`/`█▄ ` rounded stem caps, `▀` bar terminals, 2-column letter gaps. Two review findings drove the final `N`: a curved diagonal read as a blob, and the first solid variant read as illegible at a glance, so it settled on a straight 3-wide diagonal with an **open bottom** and rounded feet — no baseline bar to close the counters. C's row 5 also carried a lone `▀` that rendered as a speck between C and H; it is removed, which is the only edit to a reused letter.

Result: 113 columns by 9 rows. The grid is 9 tall rather than 10 because `M` supplied the ascender row that trimmed away — without it there is nothing above the rounded caps — while `R`'s descender keeps the ninth row.

**The SVG is a vectorisation, not a retrace**

The old `logo.svg` was traced and carried fractional drift; its viewBox was `0 0 1215 285`, and 285 is not a multiple of the 15-unit column it shared with the ASCII. The new one is generated from the same grid the ASCII is, on 15 units per column and 30 per row (two 15-unit half-blocks), as 10 letter paths of vertically merged rectangles — 181 subpaths in all. `viewBox="0 0 1695 270"` where `1695 = 113 * 15` and `270 = 9 * 30`. A headless Chromium render is 209,700 dark pixels, exactly the 932 filled half-cells times 225 square units.

**`test/shell.d/logo-test.sh` pins the pair together**

11 assertions: the exact wordmark text, the 113×9 grid, `sha256sum` pins on both icon files, the viewBox derived from the grid rather than hardcoded, one path per letter, every subpath a plain rectangle on the 15-unit grid, and the SVG's rebuilt half-cell occupancy compared against `logo.txt`'s. That last one is the point — nothing generates either file at install time, so a hand edit to one would otherwise desync the pair silently. Also checks `unbloarchy-show-logo` still prints it and that `unbloarchy-provision-owner` still measures `logo.txt` rather than assuming a width.

The suite was mutation-tested rather than trusted. Nine mutations were tried and each failed the assertion it should: nudging a rect off-grid, deleting a rect, doubling a rect's width, altering the viewBox, adding an eleventh path, flipping a single half-block cell in `logo.txt`, adding one trailing blank to a row, and touching either icon file. Every file was confirmed byte-identical after restore. One attempt to flip a cell first reported no failure and turned out to be a bad mutation rather than a gap — the `sed` pattern targeted row 2, which begins `███` and not ` ▄█`, so it never matched; retargeted at row 1 it fails as expected.

The width measurement is deliberately locale-proof. `awk`'s `length()` and bash's `${#line}` both count bytes under `LC_ALL=C`, which turns 113 columns into 263 and would have made the suite fail on a byte-only locale for no real reason. The count is instead taken after substituting the block characters for single-byte digits, so what is measured is all ASCII. The suite passes 11/11 under `LC_ALL` unset, `C`, and `C.UTF-8` — worth checking explicitly, because `ascii-test.sh` already pins C-locale behaviour elsewhere in this suite and the two must not disagree.

**Two tests cannot pass under the sandbox runner, and it is not the working tree**

`unbloarchy-plymouth-set` and `unbloarchy-provision-user` both refuse early on `(( EUID == 0 ))`. `run-suite.sh` enters `unshare --user --map-root-user`, so `EUID` is 0 inside the runner even though the user is uid 1000 outside it. Any assertion covering those commands' non-root path is unreachable here by construction. Confirmed by stashing the logo changes and re-running: same two failures.

**Results**

- `./test/cli` — 118 `ok`, 0 `not ok`, exit 0.
- `./test/shell` — 3167 `ok`, 40 `not ok`, exit 127. Baseline was 3156/40; the +11 is this new suite, and the `not ok` set is identical to baseline apart from one random temp path inside a failure message.
- Targeted: `ascii-test.sh` 17/0, `logo-test.sh` 11/0, `branding-about-animation-test.sh` 23/0, `plymouth-set-test.sh` 2/1, `provision-user-test.sh` 0/1.
- `bash bin/unbloarchy commands --check` — passes, 473 commands, which is what proves the corrected `unbloarchy-ascii` summary still parses as metadata.
- `bash -n` across all 784 bash-shebang tracked files — clean.

**Still outstanding in Phase 5**

The two rules deliberately not applied to `icon.*` and `U+E900` are now fully discharged, and `manual/41-branding.md` needed no path changes — its `~/.config/unbloarchy/branding/` examples were already rebranded. The empty untracked `default/fonts/omarchy/` directory left behind by the rename is gone; a grep for `default/fonts/omarchy` found no referent, and the surviving `omarchy.ttf` hits are the unrelated legacy user font at `~/.local/share/fonts/omarchy.ttf`. The user has now confirmed that ordinary wallpapers stay untouched and only visibly branded Omarchy wordmarks should be regenerated. The candidate image contents still need a visual audit; the earlier `*omarchy*.webp` filename inventory was stale. The upstream ISO compatibility decision is also recorded: keep the generated shims.

### 2026-10-02 — Phase 6 fork links and attribution

Status: Phase 6 is partially applied. Fork-owned issue, discussion, release, development-checkout, and manual links now point at Unbloarchy; links to upstream package repos, mirrors, and community guides are labeled as upstream dependencies. The README, license header, and welcome page now state the fork's independent status and non-affiliation/trademark posture. Security reporting now directs users to this repository's private vulnerability reporting when available, instead of Omarchy's security team. Manual descriptions of package ownership, mirrors, release signatures, and upstream community material were corrected to avoid implying that Unbloarchy operates those services.

The diagnostic uploader was inspected: it uploads support logs, hardware/system details, and installed-package lists to `logs.omarchy.org`, not stats. The user’s answer was conditional on the purpose and DHH’s likely preference, so the implementation is left unchanged pending a clear policy decision; the manual/agent contribution guide disclose the destination and advertised 24-hour expiry. The user also confirmed ordinary wallpaper art should stay as-is while only visible Omarchy wordmarks should be regenerated; asset inspection/regeneration/visual verification is still pending. The compatibility-shim decision for the upstream ISO tools is to keep the shims.

Verification: `bash bin/unbloarchy commands --check` passes (473 commands); `bash -n` passes on the changed shell scripts; and `git diff --check` is clean. The focused channel test could not run: direct execution fails because this sandbox has no `/bin/bash` (`bad interpreter`), and `/tmp/opencode/with-bash.sh /tmp/opencode/run-suite.sh bash test/shell.d/channel-test.sh` gets past that but fails because the runner lacks `/usr/bin/readlink`. The `test/shell.d/channel-test.sh` expected clone URL was updated with the runtime change. Other remaining upstream-looking references are intentional package/mirror infrastructure, inherited theme attribution, legacy-upgrade behavior, the support uploader pending the decision above, and historical upstream community references identified as such.

### 2026-10-02 — Phase 7 shim generator implemented

Status: the in-repository part of Phase 7 is implemented and tested. `install/helpers/generate-compat-shims.sh` emits executable per-command shell forwarding shims, a source-forwarding security-library shim, a Python forwarding shim for `unbloarchy-dev-font`, and a bare `omarchy` router shim. It is repeatable, removes only stale generated shims, refuses to overwrite unmanaged paths, and all generated files are gitignored. `test/shell.d/compat-shims-test.sh` covers argument forwarding, sourcing, Python dispatch, idempotence, newly added commands, stale-shim cleanup, and unmanaged-file protection.

The upstream integration remains outstanding: `omarchy-pkgs` must invoke the generator in `prepare()` before its `bin/omarchy-*` glob and explicitly install `bin/omarchy` to `/usr/bin/omarchy`; that bare filename does not match the glob. This external repo is not present in the checkout, so the ISO build remains unverified and is not yet fully compatible.

Verification: focused shim test passes with `/tmp/opencode/with-bash.sh bash test/shell.d/compat-shims-test.sh` (4 assertions). `bash -n` passes on the generator and test, `bash bin/unbloarchy commands --check` passes (473 commands), and `git diff --check` is clean. Direct test execution fails here because the sandbox has no `/bin/bash`.

### 2026-10-03 — Phases 5-7 committed, with one unverified assertion

Status: Phases 5, 6, and 7 are now committed as `050ea6d1`, `3fe6dd53`, and `2a12df06`. The three were separate working-tree changes that had been reviewed and tested together; they are separated here because they are independent changes and the wordmark, the fork's public links, and the packaging compatibility layer can each be reverted without the others. Phase 8 is still unwritten and Phase 9's visual verification has not run.

**One line in Phase 6 is unverified, and it is not fixable here**

`test/shell.d/channel-test.sh` pins the dev-channel clone URL that `3fe6dd53` changed, and that suite never actually executes in this sandbox. It produces zero TAP lines in the full-suite run, which is why it does not show up in the `not ok` count at all. Running the pre-rename worktree's own copy of the same suite through the same runner gives the identical silent abort, so this is a pre-existing environmental limit — the privileged entrypoint needs `/usr/bin/readlink`, `/usr/bin/sudo`, and a real `-p` Bash startup — and not a regression from the rename.

This is the same silent-abort shape that per-suite parity caught earlier in the rebrand: a suite that dies under `set -e` before its first assertion lowers the total rather than adding a failure. The changed URL is correct by inspection and matches `bin/unbloarchy-channel-set:52`, but it needs a real target to confirm.

**Do not "improve" the sandbox runner by supplying `/usr/bin`**

An attempt to unblock the above by overlaying a symlink farm onto the sandbox's near-empty `/usr/bin` made things look better and was worse. `./test/shell` rose from 3171 `ok` to 3230, but the `not ok` set changed identity rather than shrinking: the privileged-entrypoint suites stopped failing `127` on a missing interpreter and started failing `126` inside the security checks, and seven assertions failed that had not failed before. A higher pass count with a churned failure set is not an improvement, so the overlay was reverted and the runner restored to bind `/bin` only.

**Results on the committed tree**

- `./test/cli` — 118 `ok`, 0 `not ok`, exit 0.
- `./test/shell` — 3171 `ok`, 40 `not ok`, exit 127. Phase 5 was 3167/40, so the +4 is `compat-shims-test.sh`, and the `not ok` set is byte-identical to the Phase 5 baseline after normalising temp paths.
- Targeted: `logo-test.sh` 11/0, `compat-shims-test.sh` 4/0, `ascii-test.sh` 17/0, `channel-test.sh` 0/0 (silent abort, above).
- `bash bin/unbloarchy commands --check` — passes, 473 commands; `bash -n` clean on every changed script; `git diff --check` clean.

**Still outstanding**

Phase 2's absolute `/usr/bin/unbloarchy-*` pin review has still not been done — the one Phase 2 item to note here is that `default/systemd/user/unbloarchy-speaker-tuning.service` had its `Documentation=` URL repointed at this fork during Phase 6, initially against the local `rebrand-unbloarchy` branch, which is not a ref that exists for anyone who clones the repository. It is now `quattro`, matching `origin/HEAD`. Phase 5's branded-wallpaper audit, Phase 7's external `omarchy-pkgs` integration, Phase 8's migration, and Phase 9's visual verification all remain open, and an absolute zero-failure run still needs a real target.

### 2026-10-03 — Phase 8 migration and the fresh-install compat links

Status: Phase 8 is committed as `0e585f65` and the fresh-install half of the compat surface as `1d174023`. Phase 2's absolute-pin audit is closed with no code change, and Phase 9's automated gates have been run against the result. Phase 5's wallpaper audit is now partially answered — see below — and visual verification still needs a real target.

**Phase 2 closed with no change**

All eight hardcoded `/usr/bin/unbloarchy-*` pins are correctly repointed. Every remaining `/usr/share/omarchy` reference is confined to `bin/unbloarchy-upgrade-to-quattro`, which deliberately reasons about a pre-rename installation and is protected by design. Nothing needed changing.

**The migration, and the two cases that were not obvious**

`migrations/1791018295.sh` follows the ordering Phase 8 specifies, and `test/shell.d/rename-migration-test.sh` covers it with 11 assertions that run the real script against a redirected filesystem root. Writing the test found three things that inspection had missed:

- **A symlinked legacy tree cannot be moved.** `~/.config/omarchy` is often a symlink into a pre-rename checkout. `mv` strips the checkout bare, and dropping the link discards the user's own layout — which is the one thing the migration exists to preserve. The contents are now copied across and the checkout left intact.
- **`/usr/share/omarchy` is only an install root if it holds `bin/`.** The first draft keyed on the directory name alone, which both risked deleting a directory of the user's own and hard-`exit`ed on the ambiguity. That exit was the worse of the two faults: it fires after everything else has already run, so the box is left permanently half-migrated with a queue that re-runs and fails identically every time. It now warns, leaves the directory alone, and continues.
- **`/usr/lib/systemd/user` was missing from the drop-in walk.** A unit left under its old name beside the new one has no referent but is still loaded, putting two instances of one unit in a session. The existing already-installed-wins rule drops the old copy rather than producing that pair.

The bar-layout rewrite was validated before the script was written: applying its jq program to the pre-rename `config/omarchy/shell.json` reproduces the packaged post-rename `config/unbloarchy/shell.json` exactly, and running it twice is a no-op.

**A gap the audit found between the phases**

The plan states the `/usr/share/omarchy` symlink is created by install scripts, and nothing in the tree did it — the migration only covered upgrades, so a fresh install and an upgraded one behaved differently. `install/config/compat-links.sh` closes that. It also creates `/usr/bin/omarchy`, which the package's `bin/omarchy-*` glob does not match. Both are symlinks rather than packages, so `pacman -Qo` never claims them, and both are skipped when the old path is already occupied. They target the packaged root rather than tracking `$UNBLOARCHY_PATH` when that is a dev checkout: a system-wide link resolving into a home directory breaks every root-owned caller the moment the checkout moves.

**Results**

- `./test/cli` — 118 `ok`, 0 `not ok`, exit 0.
- `./test/shell` — 3182 `ok`, 40 `not ok`, exit 127. Previous was 3171/40, so the +11 is `rename-migration-test.sh`, and the `not ok` set is identical to the previous baseline after normalising temp paths.
- Targeted: `rename-migration-test.sh` 11/0, `logo-test.sh` 11/0, `compat-shims-test.sh` 4/0, `ascii-test.sh` 17/0.
- `shellcheck` is clean on `migrations/1791018295.sh` and `install/config/compat-links.sh`; `bash -n` clean on both.

**`logo.svg` is correct, including its dark-on-dark appearance**

The wordmark SVG reads as a solid dark rectangle in a viewer that renders transparency as black. That is a viewer artifact, not a defect: the glyph is black on a transparent field, so both read as the same value. Measured, the file is transparent with mean alpha 0.458 against the wordmark's 932/2034 = 45.8% filled cells, and the geometry reproduces `logo.txt` cell for cell. The pre-rename file has the identical `fill="none"` plus `<g fill="#000">` construction, so upstream's renders the same way. Decided to leave it.

**Wallpaper and SDDM logo audit**

OCR spot-checks found the old Omarchy wordmark in several theme images, including multiple files named `backgrounds/unbloarchy.webp`; the earlier claim that all these gradients were unbranded was incorrect. The SDDM theme's QML and metadata use Unbloarchy, but its `logo.png` still reads as the Omarchy mark. Issue #4 now invites contributors to visually audit and replace only assets with visibly stale branding, including these wallpaper marks, the SDDM logo, and outdated screenshot labels. Ordinary wallpapers remain out of scope.

**Still outstanding**

Phase 7's external `omarchy-pkgs` integration is unchanged and still blocked on a repository that is not in this checkout. Phase 5's screenshot regeneration needs a running session. Phase 9's visual verification needs a real target, and an absolute zero-failure run needs one too.

### 2026-10-03 — Reference audit, and the two open questions decided

Status: every phase is now either committed or blocked on something outside this checkout. This entry covers a final audit of the 895 remaining `omarchy` occurrences, the six defects it found, and the two decisions the user took on open questions 1 and 4. Landed as seven commits on top of `df62ff78`.

**The audit, and the one failure mode it kept finding**

The transform's protection list was written in terms of what the brand *names inside this repository*. What it did not model was that some identifiers this tree merely *refers to* are owned by repositories it does not contain. The `omarchy-iso` harness is the clearest case: its scripts and flags are spelled `omarchy-iso-make`, `omarchy-iso-test`, and `--sync-omarchy`, and the rename rewrote all three to `unbloarchy-`. Every one of those instructions was a command that does not exist. Restored in `ba4ae351`, with a note in `agents/skills/acceptance-tests.md` explaining that the sibling repository's identifiers keep upstream spelling while only the path argument naming this checkout is rebranded, because that is exactly the judgement the rename got wrong and the next reader will face.

The same class produced four more, and it generalises to *any* destination whose path segment the rename rewrote:

- `manual/32-shell-plugins.md:98` pointed into `omacom/omarchy` at `docs/unbloarchy-shell.md`. The doc was renamed here; upstream still has `docs/omarchy-shell.md`, so the link was a 404. Repointed at this fork's own doc, matching how `docs/audio-tuning.md` was already handled.
- `manual/48-security.md:33` told readers an upstream ISO signature lives at `iso.omarchy.org/unbloarchy-x.x.x.iso.sig`. Upstream publishes the ISO under its own name. Restored, with a sentence saying why the filename keeps the prefix.
- `manual/32-shell-plugins.md:104` called `omarchyplugins.com` the community plugin directory and linked `unbloarchyplugins.com`, a domain this fork does not own. Restored and labelled as Omarchy's, since it is still where Unbloarchy users will look.
- `manual/49-unbloarchy-on.md:5` pointed at `unbloarchy-mac/unbloarchy-mac`. The `omarchy-mac` organisation is a third-party Asahi project, not `omacom`. Restored.

The last three were found by extracting every URL in the tree before and after the rename and diffing the two sets, which is cheap and worth repeating for any rename that touches path strings. Reading for brand leftovers would not have found them: each of those URLs still contained no misspelled brand.

**The uploader is gone, and the command that used it says so**

`bin/unbloarchy-debug` loses its "Upload log" choice, and with it the `ping` reachability probe that existed only to decide whether to offer it. `bin/unbloarchy-upload-log` keeps its per-source log collection — `install`, `this-boot`, `last-boot`, `installed`, `system-info`, which `unbloarchy debug` does not offer — and stops at the local file: it prints where it wrote, says what the file contains, points at this fork's issue tracker, and **exits non-zero**. The non-zero exit is deliberate. The command is named `upload-log`; a zero exit would let any caller read it as a completed upload, and there are no in-tree callers today but nothing prevents one tomorrow. Both `curl` call sites to `logs.omarchy.org` are gone, and the string appears nowhere in the tree now.

**The Discord was not ours either**

The same audit turned up a claim rather than a broken link: `unbloarchy-launch-discord-community` opened `discord.gg/tXFUdasqhY`, which is Omarchy's invite, under a summary that called it "the Unbloarchy Discord community", and `manual/25-web-apps.md` called it "Unbloarchy's own". Pre-rename, `manual/25` correctly said "Omarchy's own". The links kept working and the labels did not. Fixed in `f4767162` by labelling the invite as upstream's at every point it is offered, including the command's summary, which is the only place the menu names it. No invented replacement URL.

**`4.0.0.unbloarchy.1`, not `4.0.0-unbloarchy.1`**

Open question 4's sketched example would have broken packaging. The `version` file's only consumer is the `pkgver` of the PKGBUILDs in `omarchy-pkgs` — nothing at runtime reads it, since `unbloarchy-version` derives from `pacman -Q` — and pacman splits a package version at the last `-` into `pkgver` and `pkgrel`. A hyphen would therefore be read as that separator, leaving `unbloarchy.1-1` where a pkgrel belongs.

The other half was an ordering claim, and `vercmp` is absent from this sandbox, so rather than assert it I ported pacman's `vercmp` to a throwaway script and checked four comparisons: the fork's version sorts above its upstream baseline (so an existing install is offered the upgrade), below a future upstream alpha (so pacman correctly reports a newer mirror package as an upgrade, which is the maintainer-bump signal), above a bare `4.0.0`, and above the `4.0.0~unbloarchy.1` form that a `~` would have produced. All four behaved as the design requires. `docs/update-process.md` records both constraints and the bump rule, because the hyphen hazard is invisible until a package build splits the string.

**Also fixed, small**

`bin/unbloarchy-dev-pkg-test` documented a default checkout of `~/Work/unbloarchy/unbloarchy-installer` while its code used `~/Work/unbloarchy/omarchy-installer` — the prose rename and the code rename disagreed, so the help text described a default that never existed. Both now say `~/Work/unbloarchy/unbloarchy`, matching the directory name `git clone https://github.com/Magiclovekorean/unbloarchy.git` actually produces.

**Results**

- `./test/cli` — 118 `ok`, 0 `not ok`, exit 0.
- `./test/shell` — 3211 `ok`, 37 `not ok`, exit 127. The `not ok` set is byte-identical to the last recorded full run after normalising temp paths, so nothing in this entry moved it. All 37 are environmental: absent `plocate` / `omasnap` / `magick` / `jq` / `lua` / `socat` / `mise`, `EUID 0` refusals, and the missing sibling `omarchy-pkgs` checkout.
- **The previous entry's shell figures were wrong.** It recorded 3182/40; the recorded log for that same tree (`all2.log`, taken after `df62ff78`) is 3211/37, and a clean re-run reproduces it. The stale numbers were not the tree's fault, but any future comparison made against 3182/40 would read as 29 regressions.
- `bash bin/unbloarchy commands --check` — passes, 473 commands. `bash -n` clean across all 805 tracked bash-shebang files. `git diff --check` clean.

**Still outstanding, all blocked on something not in this checkout**

Phase 7's `omarchy-pkgs` integration, which needs the generator called from `prepare()` and the bare `bin/omarchy` installed explicitly. Phase 5's `preview*.png` / `unlock.png` / `manual/images/*.webp` regeneration, and Phase 9's visual verification, which need a running session. An absolute zero-failure run needs a real target. `test/shell.d/channel-test.sh` still produces zero TAP lines here and needs a real target to confirm the Phase 6 clone-URL change.

### 2026-10-03 — Compatibility wrappers without a package-repository fork

The user clarified that Unbloarchy must not require a fork of `omarchy-pkgs`. The compatibility approach is therefore implemented in this repository: `install/helpers/generate-compat-shims.sh` writes packageable `bin/omarchy-*` forwarding wrappers and the bare `bin/omarchy` router wrapper, plus only the exact legacy `default/` paths selected by the existing upstream PKGBUILDs. The wrapper files are tracked with command changes rather than ignored build artifacts; the upstream package's existing `bin/*` loop installs them without any PKGBUILD edits. `omarchy-security-functions` forwards by sourcing the renamed library, and `omarchy-dev-font` uses a Python forwarding wrapper.

The generator also supplies old filenames for the explicitly selected upstream defaults, so the source package recipes can continue to resolve those inputs after the rename. The runtime's `/usr/share/omarchy` package root remains upstream-compatible; Unbloarchy's `/usr/share/unbloarchy` path is supplied by the in-repo compatibility setup. The sibling `omarchy-pkgs` working tree was restored with no changes.

Verification: `test/shell.d/compat-shims-test.sh` passes all five checks, including generating an alias, copying it with an upstream-style package install command, and invoking the old name with exact argument forwarding. `bash -n` and `git diff --check` pass. A complete package build and live installation have not been run, and desktop screenshots/visual checks still require a running target session.

This supersedes the earlier Phase 7 and open-question-3 entries that marked external PKGBUILD integration as blocked. No package-repository fork or change is required for the wrapper route.

Follow-up verification: `compat-shims-test.sh`, `rename-migration-test.sh`, `dev-env-path-test.sh`, `config-test.sh`, and `test/cli` all pass when run through the available Nix shell and Bash binder. The checks confirm package-loop wrapper copying and dispatch, legacy package-default source paths, root/bootstrap compatibility, and migration behavior. `bash -n` on the changed shell scripts and `git diff --check` pass; the sibling `omarchy-pkgs` checkout remains clean.

What remains is target-dependent rather than an upstream-repository code change: an actual Arch package/ISO build and installation have not been exercised; the full shell suite still needs a suitable target to distinguish environmental failures and confirm the silent-aborting channel test. The user plans to build the ISO themselves, so package/ISO success remains unverified in this checkout pending that run. Branded wallpaper/SDDM logo refresh and screenshot updates are handed off to contributors through #4, not assigned to the user. Until the package/ISO build and install are exercised, describe no-fork compatibility as implemented and focused-test verified, not as end-to-end installation verified.
