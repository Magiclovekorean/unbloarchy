# Task Guides

Deeper instructions for specific kinds of work live in `agents/skills/`. Read the
matching guide before starting:

- `agents/skills/command-metadata.md` - adding or changing commands in `bin/`
- `agents/skills/install-scripts.md` - working under `install/` or on system/user setup commands
- `agents/skills/shell-dev.md` - editing the Quickshell desktop under `shell/`
- `agents/skills/icon-font.md` - adding branded glyphs to `default/fonts/unbloarchy/unbloarchy.ttf`
- `agents/skills/acceptance-tests.md` - writing or running graphical acceptance tests under `test/acceptance.d/`
- `agents/skills/visual-verification.md` - verifying any change with a visual effect in the running UI
- `agents/skills/migrations.md` - creating or changing migrations under `migrations/`

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
- `aarch64` - every ARM machine without a family of its own
- `aarch64-apple` - Apple Silicon Macs

Never introduce `generic`, `arm64`, `apple-silicon` or other spellings; `unbloarchy-hw-platform` prints the
most specific name. Ask a helper; don't read `uname -m` or the device tree in feature code.

- `unbloarchy-hw-x86` / `unbloarchy-hw-aarch64` - the CPU architecture. Use for binary and ABI availability.
- `unbloarchy-hw-aarch64-apple` - built on `unbloarchy-hw-platform`, image-build aware. Use for hardware behaviour.

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
- `unbloarchy-pkg-missing` / `unbloarchy-pkg-present` - check for packages (don't use these if you can just
  use `unbloarchy-pkg-add`/`unbloarchy-pkg-drop`)
- `unbloarchy-pkg-add` - install packages (handles both pacman and AUR)
- `unbloarchy-pkg-drop` - remove packages; use this instead of raw `pacman -R*`
- `unbloarchy-notification-send` - send desktop notifications; do not call `notify-send` directly
- `unbloarchy-hw-asus-rog` - detect ASUS ROG hardware (and similar `hw-*` commands)

Use command-presence helpers only for genuinely optional dependencies or code that can run before the default
package set is installed.

Exceptions are allowed for migration and package-helper scripts where the helper may not be available yet.

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

New Unbloarchy shell tests should live in `test/shell.d/*-test.sh` so `./test/shell` picks them up automatically.
Source `test/shell.d/base-test.sh` for shared root-path discovery, assertions, and Node test helpers.

The graphical acceptance suite runs in a disposable VM, not in the active development session.
Visual changes must be verified in the running UI in addition to automated tests.

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
unbloarchy-refresh-config hypr/hyprland.lua
```

This copies `$UNBLOARCHY_PATH/config/hypr/hyprland.lua` to `~/.config/hypr/hyprland.lua`. The argument is
interpolated into both paths and only checked with `[[ -e ]]`, so pass a plain relative path.