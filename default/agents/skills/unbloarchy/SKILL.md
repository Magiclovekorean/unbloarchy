---
name: unbloarchy
description: >
  REQUIRED for end-user customization of Linux desktop, window manager, or system config.
  Use when editing ~/.config/hypr/, ~/.config/unbloarchy/,
  ~/.config/alacritty/, ~/.config/foot/, ~/.config/kitty/, or ~/.config/ghostty/.
  Triggers: Hyprland, window rules, animations, keybindings, monitors, gaps, borders,
  blur, opacity, unbloarchy-shell, bar, terminal config, themes, background,
  night light, idle, lock screen, screenshots, reminders, layer rules, workspace
  settings, display config, and user-facing unbloarchy commands. Excludes Unbloarchy
  source development through `unbloarchy dev link` workflows.
---

# Unbloarchy Skill

Manage [Unbloarchy](https://omarchy.org/) Linux systems - a beautiful, fun, agentic Arch Linux distribution with Hyprland.

This skill is for end-user customization on installed systems.
It is not for contributing to Unbloarchy source code.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Editing ANY file in `~/.config/hypr/` (window rules, animations, keybindings, monitors, etc.)
- Editing `~/.config/unbloarchy/shell.json` (status bar layout, widgets)
- Editing terminal configs (alacritty, foot, kitty, ghostty)
- Editing ANY file in `~/.config/unbloarchy/`
- Window behavior, animations, opacity, blur, gaps, borders
- Layer rules, workspace settings, display/monitor configuration
- Themes, backgrounds, fonts, appearance changes
- User-facing `unbloarchy` commands (`unbloarchy theme ...`, `unbloarchy refresh ...`, `unbloarchy restart ...`, etc.)
- Screenshots, screen recording, reminders, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for Unbloarchy development tasks** (editing the Unbloarchy source tree, creating migrations, or running `unbloarchy dev ...` workflows).

## Topic Guides

Deeper instructions for common areas live next to this file. Read the
matching guide before starting:

- [`hyprland.md`](hyprland.md) - keybindings, monitors, window rules, and other Hyprland config
- [`plugins.md`](plugins.md) - the Unbloarchy shell: bar layout, widgets, plugins, idle behavior
- [`theming.md`](theming.md) - themes, backgrounds, and fonts
- [`hooks.md`](hooks.md) - automation hooks that run on system events
- [`capture.md`](capture.md) - screenshots, screen recordings, OCR text capture, and file sharing
- [`contributing.md`](contributing.md) - reporting Unbloarchy bugs and submitting fixes upstream

## Critical Safety Rules

For privileged commands, follow the Privilege Escalation rules below: `sudo` when a terminal is available for the password prompt, `pkexec` when it is not. Do not wrap commands that already manage privilege elevation themselves.

**For end-user customization tasks, NEVER modify anything in `/usr/share/unbloarchy/`** - but READING is safe and encouraged.

This directory is owned by the unbloarchy package. Any local changes will be
overwritten on the next `unbloarchy update`.

```
/usr/share/unbloarchy/     # READ-ONLY - NEVER EDIT (reading is OK)
├── bin/                    # Command source (packaged binaries are on PATH)
├── config/                 # Default config templates
├── themes/                 # Stock themes
├── default/                # System defaults
├── shell/                  # Unbloarchy shell source and defaults
├── migrations/             # Update migrations
└── install/                # Installation scripts
```

**Reading `/usr/share/unbloarchy/` is SAFE and useful** - do it freely to:
- Understand how unbloarchy commands work: `unbloarchy theme set --help` or `cat $(which unbloarchy-theme-set)`
- See default configs before customizing: `cat "$UNBLOARCHY_PATH/config/unbloarchy/shell.json"`
- Check stock theme files to copy for customization
- Reference default hyprland settings: `cat /usr/share/unbloarchy/default/hypr/*`

**Always use these safe locations instead:**
- `~/.config/` - User configuration (safe to edit)
- `~/.config/unbloarchy/themes/<custom-name>/` - Custom themes
- `~/.config/unbloarchy/hooks/` - Custom automation hooks

If the request is to develop Unbloarchy itself, this skill is out of scope. Follow repository development instructions instead of this skill.

## Privilege Escalation

For an interactive script or command run in a visible terminal, use `sudo` for
privileged work. Unbloarchy may grant passwordless `sudo` access to particular
commands, and the terminal is the appropriate place to request a password
when one is needed.

Use `pkexec` only when the caller cannot interact with a terminal or cannot
enter a password there, such as a command launched by an agent or a graphical
background process. Do not replace `sudo` with `pkexec` merely because a
command changes system state.

## System Architecture

Unbloarchy is built on:

| Component | Purpose | Config Location |
|-----------|---------|-----------------|
| **Arch Linux** | Base OS | `/etc/`, `~/.config/` |
| **Hyprland** | Wayland compositor/WM | `~/.config/hypr/` |
| **Unbloarchy shell** | Status bar + notifications (Quickshell) | `~/.config/unbloarchy/shell.json` |
| **Launcher/menus** | Quickshell menu | `~/.config/unbloarchy/extensions/unbloarchy-menu.jsonc` |
| **Alacritty/Foot/Kitty/Ghostty** | Terminals | `~/.config/<terminal>/` |
| **Unbloarchy OSD** | On-screen display | Quickshell plugin |

## Command Discovery

Unbloarchy ships a single `unbloarchy` CLI that dispatches to all `unbloarchy-*` binaries via `unbloarchy <group> <action>`. Always prefer this form — it is self-documenting and stable. The underlying `unbloarchy-*` binaries still exist on `PATH` and remain safe to read for source.

```bash
# List every documented command and its summary (--all includes hidden commands)
unbloarchy commands

# Show the commands inside a group
unbloarchy theme --help
unbloarchy refresh --help
unbloarchy restart --help

# Show help for a specific command (does not execute it)
unbloarchy theme set --help

# Machine-readable listing (binary, route, summary, args, aliases)
unbloarchy commands --json

# Read a command's source to understand it
cat $(which unbloarchy-theme-set)
```

### Command Groups

Run `unbloarchy --help` for the full list. The most common groups:

| Group | Purpose | Example |
|-------|---------|---------|
| `unbloarchy refresh` | Reset config to defaults (backs up first) | `unbloarchy refresh shell` |
| `unbloarchy restart` | Restart a service/app | `unbloarchy restart shell` |
| `unbloarchy toggle` | Toggle feature on/off | `unbloarchy toggle nightlight` |
| `unbloarchy theme` | Theme management | `unbloarchy theme set <name>` |
| `unbloarchy bar` | Bar layout and widgets | `unbloarchy bar move unbloarchy.clock --section right` |
| `unbloarchy plugin` | Manage/clone shell plugins | `unbloarchy plugin clone unbloarchy.clock` |
| `unbloarchy hook` | Install automation hooks | `unbloarchy hook install theme-set <script>` |
| `unbloarchy install` | Install optional software / packages | `unbloarchy install docker dbs` |
| `unbloarchy launch` | Launch apps | `unbloarchy launch browser` |
| `unbloarchy capture` | Screenshots and recordings | `unbloarchy capture screenshot` |
| `unbloarchy reminder` | Desktop notification reminders | `unbloarchy reminder 15 "Pickup Jack"` |
| `unbloarchy pkg` | Package management | `unbloarchy pkg add <pkg>` |
| `unbloarchy setup` | Interactive setup wizards | `unbloarchy setup security fingerprint` |
| `unbloarchy update` | System updates | `unbloarchy update` |

## Configuration Locations

Hyprland config lives in `~/.config/hypr/` — see [`hyprland.md`](hyprland.md).
The Unbloarchy shell (bar, notifications, plugins, idle) is configured in
`~/.config/unbloarchy/shell.json` — see [`plugins.md`](plugins.md).

### Terminals

```
~/.config/alacritty/alacritty.toml
~/.config/foot/foot.ini
~/.config/kitty/kitty.conf
~/.config/ghostty/config
```

**Command:** `unbloarchy restart terminal`

### Other Configs

| App | Location |
|-----|----------|
| btop | `~/.config/btop/btop.conf` |
| fastfetch | `/etc/fastfetch/config.jsonc` default; `~/.config/fastfetch/config.jsonc` user override |
| lazygit | `~/.config/lazygit/config.yml` |
| starship | `~/.config/starship.toml` |
| git | `~/.config/git/config` |

## Safe Customization Patterns

### Edit User Config Directly

For simple changes, edit files in `~/.config/`:

```bash
# 1. Read current config
cat ~/.config/hypr/bindings.lua

# 2. Backup before changes
cp ~/.config/hypr/bindings.lua ~/.config/hypr/bindings.lua.bak.$(date +%s)

# 3. Make changes with Edit tool

# 4. Apply changes
# - Hyprland: auto-reloads on save, but MUST validate with `hyprctl reload` and `hyprctl configerrors`
# - Unbloarchy shell: shell.json and user plugin code under ~/.config/unbloarchy/plugins/ hot-reload on save
# - Menus/launcher: ~/.config/unbloarchy/extensions/unbloarchy-menu.jsonc hot-reloads on save
# - Terminals: apply with `unbloarchy restart terminal` (reloads running terminals; foot picks changes up in new windows)
```

### Reset to Defaults -- ALWAYS SEEK USER CONFIRMATION BEFORE RUNNING

When customizations go wrong:

```bash
# Reset specific config (creates backup automatically)
unbloarchy refresh shell
unbloarchy refresh hyprland

# The refresh command:
# 1. Backs up current config with timestamp
# 2. Copies default from $UNBLOARCHY_PATH/config/
# 3. Restarts the component where the refresh needs it (e.g. `refresh shell`)
```

## System Commands

```bash
unbloarchy update                  # Full system update
unbloarchy version                 # Show Unbloarchy version
unbloarchy debug --no-sudo --print # Debug info (ALWAYS use these flags)
unbloarchy system lock             # Lock screen
unbloarchy system shutdown         # Shutdown
unbloarchy system reboot           # Reboot
```

**IMPORTANT:** Always run `unbloarchy debug` with `--no-sudo --print` flags to avoid interactive sudo prompts that will hang the terminal.

## Troubleshooting

```bash
# Get debug information (ALWAYS use these flags to avoid interactive prompts)
unbloarchy debug --no-sudo --print

# Reset specific config to defaults
unbloarchy refresh <app>

# Refresh specific config file
# config-file path is relative to ~/.config/
# eg. `unbloarchy refresh config hypr/hyprland.lua` will refresh ~/.config/hypr/hyprland.lua
unbloarchy refresh config <config-file>

# Full reinstall of configs (nuclear option)
unbloarchy reinstall
```

## Decision Framework

When user requests system changes:

1. **Is it a stock unbloarchy command?** Use it directly
2. **Is it a config edit?** Edit in `~/.config/`, never `/usr/share/unbloarchy/`
3. **Is it a theme customization?** Follow [`theming.md`](theming.md); create a NEW custom theme directory
4. **Is it automation?** Follow [`hooks.md`](hooks.md); use `unbloarchy hook install` and the hook `.d` directories
5. **Is it a package install?** Use `unbloarchy pkg add <pkgs...>` (or `unbloarchy pkg aur add <pkgs...>` for AUR-only packages)
6. **Is it built-in shell/plugin code?** Follow [`plugins.md`](plugins.md); clone it with `unbloarchy plugin clone`, never edit the packaged copy
7. **Unsure if command exists?** Run `unbloarchy commands` (or `unbloarchy <group> --help` for one group)

### Reminder Requests

When the user asks to set a reminder, use `unbloarchy reminder <minutes> [message]` directly. Convert natural language durations to minutes and title-case short reminder labels when appropriate.

```bash
unbloarchy reminder 15 "Pickup Jack"
unbloarchy reminder 60 "Check laundry"
unbloarchy reminder show
unbloarchy reminder clear
```

## Out of Scope

This skill intentionally does not cover Unbloarchy source development. Do not use this skill for:
- Editing files in `/usr/share/unbloarchy/` (`bin/`, `config/`, `default/`, `shell/`, `themes/`, `migrations/`, etc.)
- Creating or editing migrations
- Running `unbloarchy dev ...` commands

## Example Requests

- "Change my theme to catppuccin" -> `unbloarchy theme set catppuccin`
- "Add a keybinding for Super+E to open file manager" -> Check existing bindings first, then use `o.rebind` to replace one or `o.bind` to add one in `~/.config/hypr/bindings.lua`
- "Configure my external monitor" -> Edit `~/.config/hypr/monitors.lua`
- "Make the window gaps smaller" -> Edit `~/.config/hypr/looknfeel.lua`
- "Turn on night light" -> `unbloarchy toggle nightlight` (for time-based schedules, edit `~/.config/hypr/hyprsunset.conf` profiles, then `unbloarchy restart hyprsunset`)
- "Set a reminder to pickup jack in 15 minutes" -> `unbloarchy reminder 15 "Pickup Jack"`
- "Show my reminders" -> `unbloarchy reminder show`
- "Clear all reminders" -> `unbloarchy reminder clear`
- "Customize the catppuccin theme colors" -> Overlay: put an edited `colors.toml` in `~/.config/unbloarchy/themes/catppuccin/`, then re-apply the theme (see `theming.md`)
- "Run a script every time I change themes" -> Install it with `unbloarchy hook install theme-set <script>`
- "Change how workspace labels are rendered" -> Clone `unbloarchy.workspaces`, which switches the bar to `<username>.workspaces`, then edit the clone
- "Lock after ten minutes" -> Set `idle.lock` to `600` in `~/.config/unbloarchy/shell.json`
- "Reset shell/bar to defaults" -> `unbloarchy refresh shell`
- "Record my screen" -> `unbloarchy screenrecord --fullscreen`, then `unbloarchy screenrecord --stop-recording` (see `capture.md`)
- "Report this bug to Unbloarchy" -> Gather diagnostics and a capture of the problem, then file it (see `contributing.md`)
