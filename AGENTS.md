# Task Guides

Deeper instructions for specific kinds of work live in `agents/skills/`. Read the
matching guide before starting:

- [`agents/skills/command-metadata.md`](agents/skills/command-metadata.md) - adding or changing commands in `bin/`
- [`agents/skills/install-scripts.md`](agents/skills/install-scripts.md) - working under `install/` or on system/user setup commands
- [`agents/skills/mise-tools.md`](agents/skills/mise-tools.md) - adding or changing mise-managed tools
- [`agents/skills/shell-dev.md`](agents/skills/shell-dev.md) - editing the Quickshell desktop under `shell/`
- [`agents/skills/icon-font.md`](agents/skills/icon-font.md) - adding branded glyphs to `default/fonts/omarchy/omarchy.ttf`
- [`agents/skills/acceptance-tests.md`](agents/skills/acceptance-tests.md) - writing or running graphical acceptance tests under `test/acceptance.d/`
- [`agents/skills/oligarchy-tests.md`](agents/skills/oligarchy-tests.md) - full unbloarchy tests that run in qemu to validate behavior
- [`agents/skills/motion.md`](agents/skills/motion.md) - adding or changing any animation or transition in `shell/`
- [`agents/skills/visual-verification.md`](agents/skills/visual-verification.md) - verifying any change with a visual effect in the running UI
- [`agents/skills/migrations.md`](agents/skills/migrations.md) - creating or changing migrations under `migrations/`

# Documentation Layout

Three documentation trees, split by genre and audience:

- `agents/skills/` - task procedure ("do this when doing X"), for anyone working on the codebase
- `docs/` - reference on how the system is shaped (file layout, update pipeline, theming, shell architecture)
- `manual/` - end-user documentation for using Unbloarchy, published; never codebase internals

# Command Naming

All commands start with `unbloarchy-`. The authoritative list of user-facing command groups lives in
`bin/unbloarchy` in `GROUP_DESCRIPTIONS`. Keep `GROUP_DESCRIPTIONS` updated when adding a new command prefix.

A group whose commands are all `# unbloarchy:hidden=true` gets no entry in the top-level group listing;
`apply-` and `provision-` groups still route internally but are hidden from browse view.

The `omarchy-*` names are compatibility entrypoints for upstream package recipes. Keep their generated wrappers
in `bin/` so the unmodified `omarchy-pkgs` package build copies them alongside the `unbloarchy-*` commands.
After adding or removing a `bin/unbloarchy-*` command, run `bash install/helpers/generate-compat-shims.sh` and include
the resulting `bin/omarchy*` wrappers in the change.

# Runtime Environment

- `$UNBLOARCHY_PATH` is set at the top level by the uwsm session environment and is always available to
  Unbloarchy runtime code.
- Commands in `bin/` and Quickshell QML should rely on `$UNBLOARCHY_PATH` / `Quickshell.env("UNBLOARCHY_PATH")`;
  do not derive fallback paths from `HOME`, `Quickshell.shellDir`, or re-export/default `UNBLOARCHY_PATH` manually.

# Platforms

Unbloarchy runs on x86 and aarch64 (ARM). Use these exact platform names wherever a platform is named:
package lists, pacman template directories, image manifests, dispatch registration, tests and docs:

- `x86` - every x86_64 machine
- `aarch64` - every ARM machine without a family of its own (Raspberry Pis and ARM VMs today)
- `aarch64-apple` - Apple Silicon Macs
- `aarch64-qualcomm` - Snapdragon laptops
- `aarch64-n1x` - NVIDIA N1x laptops
- `aarch64-gb10` - NVIDIA GB10 desktops (DGX Spark, ASUS Ascent GX10)

Never introduce `generic`, `arm64`, `apple-silicon` or other spellings; `unbloarchy-hw-platform` prints the
most specific name. Ask a helper; don't read `uname -m` or the device tree in feature code.

Ask a helper; don't read `uname -m` or the device tree in feature code:

- `unbloarchy-hw-x86` / `unbloarchy-hw-aarch64` - the CPU architecture. Use them for binary and ABI availability: a package with no aarch64 build, an x86 guest VM, multilib.
- `unbloarchy-hw-aarch64-apple`, `unbloarchy-hw-aarch64-qualcomm`, `unbloarchy-hw-aarch64-n1x`, `unbloarchy-hw-aarch64-gb10` (one per family) - built on `unbloarchy-hw-platform`, image-build aware. Use them for hardware behaviour that the whole family shares; a single model's quirks stay behind `unbloarchy-hw-match` on its DMI name, or behind `unbloarchy-hw-match-device-tree` on its device-tree compatible string where models share a DMI name. `unbloarchy-hw-apple-silicon` and `unbloarchy-hw-n1x` are hidden aliases kept for the omarchy-mac packages and older N1x images; don't use them in new code.

Where platform code lives:

- Packages: `install/unbloarchy-base.packages` for everyone, `install/unbloarchy-aarch64.packages` for every
  ARM machine, `install/unbloarchy-<platform>.packages` for one family, and base packages with no aarch64 build in
  `install/unbloarchy-x86_64-only.packages`. `unbloarchy-pkg-defaults` composes them.
- Pacman templates: `default/pacman/` for x86, `default/pacman/<platform>/` for each ARM platform.
- Hardware setup: `install/hardware/<vendor-or-family>/`, gated by a predicate.
- Boot chains Unbloarchy can't drive generically: a platform package behind
  `unbloarchy-lifecycle-dispatch`. Platforms that boot Limine with UKIs like x86 keep the generic path.

When a package or feature is missing or broken on one platform, the default is to get it fixed upstream rather
than paper over it. Alternative packages and platform-only replacements are a last resort.

# Privileged Commands

Follow the "Privilege Escalation" section of `default/agents/skills/unbloarchy/SKILL.md`. It draws the
`sudo`/`pkexec` line by whether the caller has a terminal to enter a password in, and the repo's own scripts
follow it.

# Helper Commands

Use these instead of raw shell commands. These are runtime invariants installed by Unbloarchy's default
package set; invoke them directly without defensive presence checks:

- `unbloarchy-cmd-missing` / `unbloarchy-cmd-present` - check for commands
- `unbloarchy-pkg-missing` / `unbloarchy-pkg-present` - check for packages (don't use these if you can just use `unbloarchy-pkg-add`/`unbloarchy-pkg-drop`)
- `unbloarchy-pkg-add` - install packages from the configured pacman repos, Unbloarchy's included; use `unbloarchy-pkg-aur-add` for AUR packages
- `unbloarchy-pkg-drop` - remove packages; use this instead of raw `pacman -R*`
- `unbloarchy-notification-send` - send desktop notifications; do not call `notify-send` directly
- `unbloarchy-hw-asus-rog` - detect ASUS ROG hardware (and similar `hw-*` commands)

Use command-presence helpers only for genuinely optional dependencies or code that can run before the default
package set is installed.

Exceptions are allowed for migration and package-helper scripts where the helper may not be available yet.

# Background Work

- Long-running code (the shell, daemons, watchers) reacts to events instead of polling with a timer. Polling is the last resort, for state with no change signal; [`agents/skills/shell-dev.md`](agents/skills/shell-dev.md) lists the event sources and the push-refresh pattern.
- `test/shell.d/shell-idle-spawn-test.sh` fails when an idle shell starts any process, and other tests hold the router, menu guards and theme switch to budgets; see "Performance guards" in [`docs/testing.md`](docs/testing.md).

# Menu

The menu definition lives in `default/unbloarchy/unbloarchy-menu.jsonc`; `docs/menu.md` covers the schema, guards,
and providers. Do not add `aliases` to new menu entries. Aliases are reserved for established alternate names
users already type, kept for compatibility.

# Config Structure

- `config/` - default configs copied to `~/.config/`
- `default/themed/*.tpl` - templates with `{{ variable }}` placeholders for theme colors
- `themes/*/colors.toml` - theme color definitions (accent, background, foreground, red/green/yellow/blue/magenta/cyan
  and bright_* variants)

# Tests

Run focused automated tests for the area you changed; `docs/testing.md` covers how the suites are shaped.

Current test entry points:

- `./test/all` - aggregate runner for CLI and shell tests; does not run graphical acceptance tests
- `./test/cli` - CLI routing, command metadata, theme helpers, and safe dispatch coverage
- `./test/shell` - all Unbloarchy shell tests under `test/shell.d/`

How to run them without wasting runs:

- Run the files for what you changed directly: `bash test/shell.d/<area>-test.sh`. A change inside one plugin or command runs that area's files (and `i18n-test.sh` when catalog strings changed), not `./test/shell`.
- Run `./test/shell` or `./test/all` only when the change reaches shared code (`shell/Commons/`, `base-test.sh`, the runners, a widely used `bin/` helper), and then once, at the end.
- Always write the whole output to a log file and read it from there: `bash test/shell.d/<area>-test.sh >/tmp/<area>.log 2>&1`. Never pipe a test run straight through `grep`, `head` or `tail`: what they drop is gone, and getting it back costs a whole run. `./test/shell` keeps every file's log and prints the directory at the end; read a failure from its log.
- Run a test again only after changing something it covers. Never rerun to see output, to confirm a pass, or in the hope that a failure goes away.
- For a failure in a file you did not touch, run that one file once on the base branch (in a worktree, or with `git stash`). If it fails there too, it was already broken: report it and leave it out of this change.
- Tests that use the live session (`require_compositor`, `shell-idle-spawn-test.sh`) read the real desktop, so the user working at it can fail them. One that fails in a full run and passes alone is session noise: say so; do not loop on it.

When to add a test. A test earns its place only by catching a regression nothing else would; every one costs a maintainer to read and everyone a slower suite. Before writing one, name the breakage it would catch. If the answer is "someone edits the line I just added", don't write it.

- No test for a small declarative change: a menu row, a config value, a package-list entry, a string, a rename. Those need no test of their own, and certainly not a new file.
- Don't restate the implementation: grepping the source or config for the string you just added, asserting a value equals itself, or re-reading the file you edited to confirm the edit is there.
- A test must fail without your change. Revert the fix, or reason it through, and check that the test goes red for the reason the change exists. One that stays green guards nothing.
- Don't test your own stub. If a fake binary or fixture the test writes provides the behaviour under test, nothing real is tested.
- No change-detectors: snapshots of large output, file lists, or exact counts that break whenever someone adds an unrelated entry.
- Extend the area's existing test file (`git grep` the command or function under `test/`) rather than adding a new `*-test.sh`, and follow its style.
- Keep tests in proportion to the change. A few lines of change rarely justify more than a few lines of test, and usually none.
- No test for a migration. It runs once and is frozen once it ships; test logic it needs by moving that logic into a `bin/` command.
- Do test real logic: parsing, routing, a guard on hardware without the feature, the edge case a fix handles. A bug fix with logic in it gets the one test that fails on the base branch and passes with the fix.

New Unbloarchy shell tests should live in `test/shell.d/*-test.sh` so `./test/shell` picks them up automatically. Source `test/shell.d/base-test.sh` for shared root-path discovery, assertions, and Node test helpers.

The graphical acceptance suite runs in a disposable VM, not in the active development session.
Visual changes must be verified in the running UI in addition to automated tests.

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
unbloarchy-refresh-config hypr/hyprland.lua
```

This copies `$UNBLOARCHY_PATH/config/hypr/hyprland.lua` to `~/.config/hypr/hyprland.lua`. The argument is
interpolated into both paths and only checked with `[[ -e ]]`, so pass a plain relative path.