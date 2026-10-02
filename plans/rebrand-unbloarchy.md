# Plan: Rebrand — Omarchy to Unbloarchy, end to end

Revision 1.

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

Two compatibility layers keep the rest of the ecosystem working: a **generated `omarchy-*` shim set** in `bin/`, so the `omarchy-pkgs` PKGBUILD's `bin/omarchy-*` glob still produces `/usr/bin/omarchy-*`; and a **`migrations/<epoch>.sh`**, so an existing install upgrades in place instead of breaking. `OMARCHY_PATH` is exported alongside `UNBLOARCHY_PATH` as a deprecated alias for the same reason — it is the one env var external tooling reads.

Brand artwork is deliberately left alone: `logo.svg`, `icon.png`, and the `U+E900` glyph stay, because the glyph is the menu icon (`shell/plugins/menu/BarWidget.qml:15`) and `etc/fastfetch/config.jsonc:72` prints it next to the OS name. What regenerates is text: `logo.txt` becomes "Unbloarchy", and `unbloarchy ascii` renders "unbloarchy" in the same FIGlet font the kept logo is drawn in.

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

Two rules are deliberately **not** applied to generated art: `logo.svg`, `icon.png`, `icon.txt`, and the `U+E900` glyph stay as-is.

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

- `logo.txt` regenerates as "Unbloarchy" in the same block style. `icon.txt`, `logo.svg`, and `icon.png` are untouched.
- `bin/unbloarchy-ascii` keeps the Delta Corps Priest 1 FIGlet font — the font the kept logo is drawn in — but its examples and usage text change from `Omarchy` to `unbloarchy` (`:5`), and the summary drops "the font the Omarchy logo is drawn in" to a phrasing that does not imply the logo was redrawn. `manual/41-branding.md:49-52` follows, including its `~/.config/omarchy/branding/screensaver.txt` example.
- The icon font's *family*, *file*, and *install path* rename to `unbloarchy` (`/usr/share/fonts/unbloarchy/unbloarchy.ttf`); the `U+E900` glyph artwork stays. `default/fonts/unbloarchy/README.md` is rewritten to describe the new family, and its charset table keeps `e900-e90e` so `test/shell.d/menu-test.sh:662` still holds.
- Generated theme-name artifacts all move: `omarchy-system` (Pi, `default/themed/pi.json.tpl:3`), `Omarchy` (Claude `claude.json.tpl:2`, T3 `t3code.json.tpl:2`, VS Code `vscode-theme.json:2`), `omarchy` (Hermes skin `hermes.yaml.tpl:1` + `bin/omarchy-theme-set-hermes:16`, Helix `bin/omarchy-install-editor-helix:11,16` → `~/.config/helix/themes/omarchy.toml`, VS Code extension `local.omarchy-theme-1.0.0` under `~/.vscode/extensions/omarchy-theme/`), SDDM `Current=omarchy` in `etc/sddm.conf.d/10-theme.conf`, the Plymouth theme, and `default/snapper/root` → `/etc/snapper/config-templates/unbloarchy`.
- `default/wayland-sessions/omarchy.desktop` → `unbloarchy.desktop`, with `Name=Unbloarchy (Hyprland uwsm)` and `Comment=Unbloarchy Hyprland session managed by uwsm`. Its `Exec=` line has no brand in it.
- `etc/fastfetch/config.jsonc:72` prints `"\ue900 OS"`; the glyph stays, the adjacent OS name becomes Unbloarchy.
- `install/provisioning/setup-form.sh:84` changes the default hostname from `omarchy` to `unbloarchy`, and the prompt placeholder at `:155-161` follows.
- `etc/limine-entry-tool.d/unbloarchy-defaults.conf` changes `TARGET_OS_NAME="Omarchy"` → `"Unbloarchy"`, `interface_branding: Omarchy Bootloader` → `Unbloarchy Bootloader` (`default/limine/limine.conf:4`), `CUSTOM_UKI_NAME` → `unbloarchy` (which moves `/boot/EFI/Linux/omarchy_linux.efi` and the `bin/unbloarchy-refresh-limine:8` cleanup with it), and `BOOT_ORDER` keeps `linux-omarchy` because the kernel package is not renamed.
- `default/sddm/unbloarchy/metadata.desktop` gets `Name=Unbloarchy` and an `Author=Unbloarchy` line.

### Phase 6 — Documentation, attribution, and external links

**Prose rewrite**: all 51 manual pages that mention the brand, 11 `docs/` files, 7 `plans/` files, `AGENTS.md`'s "Privilege Escalation" pointer, and the 7 repo `agents/skills/` guides. The manual's section titles follow their filenames, so `01-welcome-to-unbloarchy.md` and `14-unbloarchy-cli.md` need their headings and cross-links updated in step.

**Remove every `omarchy.org` hyperlink** from prose. The 25 files and the specific lines:

- `.github/SECURITY.md:5,7,17,41` — the security team link, the `security@omarchy.org` address, and two security-credits links. All of these point at an upstream team that does not handle Unbloarchy reports; they get replaced with this fork's own reporting path.
- `.github/ISSUE_TEMPLATE/config.yml:7` — the Discord link in the support-URLs block.
- `manual/02-getting-started.md:5` (the ISO link) and `:39` (the `#omarchy-help` Discord channel)
- `manual/06-themes.md:9` and `manual/43-making-your-own-theme.md:45` — the extra-themes page and the `omacom-io/omarchy-site` repo
- `manual/48-security.md:31,33` — the `omarchy/omarchy-keyring` package and the `iso.omarchy.org` signature URLs
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

A `/usr/share/omarchy` symlink does **not** keep the ecosystem working on its own. The `omarchy` PKGBUILD in `omarchy-pkgs` globs `bin/omarchy-*` to build `/usr/bin/omarchy-*` and its `/usr/share/omarchy/bin/` symlink farm (`docs/file-layout.md:68-69`); rename the files and the glob matches nothing, producing an empty package. The shims exist to keep that glob matching, so they must be generated *into `bin/`*, not merely into the installed filesystem.

`install/helpers/generate-compat-shims.sh` walks `bin/unbloarchy*` and emits one stub per command, idempotently, with output gitignored:

- `bin/omarchy` → `exec unbloarchy "$@"`
- `bin/omarchy-<x>` → `exec unbloarchy-<x> "$@"`
- `bin/omarchy-security-functions` → a **source-forwarding stub** (`source "${0%/*}/unbloarchy-security-functions"`), not an `exec`, because six files source it and `exec` would run it in a subshell and discard every function it defines
- `bin/omarchy-dev-font` is special-cased rather than shimmed: it is Python invoked as `python3`, not executed, and it hardcodes the font path at `:5` (docstring), `:580` (the real default resolution), and `:605` (help text), plus brand strings at `:2,3,4,556,607,645,648` that all move with the rest

Because the shims are generated rather than committed, the PKGBUILD must call the generator in `prepare()` before it globs. That PKGBUILD edit lives in `omarchy-pkgs`, not here, so this phase ships the script, the exact `prepare()` hook, and a written list of every PKGBUILD line that must change — and the ISO build is broken until those land. What the shims buy once they do: `/usr/bin/omarchy-*` keeps existing, which preserves the `omarchy-settings`-owned ALPM hooks that call `/usr/bin/omarchy-sudo-passwordless`, the sudoers entries that match `/usr/bin/omarchy-dns` and `/usr/bin/omarchy-theme-set-browser-policy`, the PAM `pam_exec` line pointing at `/usr/bin/omarchy-hw-laptop-closed`, and the `omarchy-iso` chroot entrypoints `omarchy-apply-system`, `omarchy-provision-user`, and `omarchy-apply-hardware`.

`/usr/share/omarchy` → `/usr/share/unbloarchy` is created as a symlink by the install scripts in this repo, not by any package, so it survives `pacman -Qo` and is never a "conflicting files" error.

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
8. Phase 7 shim generator + written PKGBUILD/ISO change list
9. Phase 8 migration
10. Phase 9 test fixes and visual verification

Phases 1-4 are the risky ones and want the most careful review, because a mistake there produces a tree that passes its own tests while the desktop is subtly wrong. Phases 6-8 are the ones that can slip if attention fades.

## Open questions

1. **`logs.omarchy.org`.** `bin/unbloarchy-upload-log` sends installation logs, boot logs, and system information to an upstream service (`:95,108,121,140`, POST at `:155`, 24h expiry). After the rebrand that is the most user-visible remaining "this still points at omarchy" item. Keep it and document it plainly in the manual, or disable the uploader? Not decided.
2. **Background wallpapers.** 21 files at `themes/*/backgrounds/*omarchy*.webp` have branded filenames and the Omarchy logo in the image. The current decision is rename-only, which leaves the logo visible on every default background — consistent with keeping `logo.svg`, but worth confirming it is the intent rather than an oversight.
3. **`omarchy-iso` invocation.** The ISO builder calls `omarchy-apply-system`, `omarchy-provision-user`, and `omarchy-apply-hardware` by name in the target chroot. The generated shims make this work unchanged, so forking the ISO repo is optional rather than required — but it should be a recorded decision, not an accident.
4. **`version`.** Currently `4.0.0.alpha`, tracking upstream. Keep tracking upstream, or set an independent version such as `4.0.0-unbloarchy.1`? An independent version is the more honest signal for a fork, and `bin/unbloarchy-version-channel` and the update flow both read it.
