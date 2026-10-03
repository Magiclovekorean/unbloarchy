# Themes, Backgrounds, and Fonts

Read this before changing themes, backgrounds, fonts, or theme colors.

## Theme Commands

```bash
unbloarchy theme list              # Show available themes
unbloarchy theme current           # Show current theme
unbloarchy theme set <name>        # Apply theme ("Tokyo Night" and "tokyo-night" both work)
unbloarchy theme bg next           # Cycle background
unbloarchy theme install <url>     # Install from git repo
```

## Making a New Theme

1. Create a directory under `~/.config/unbloarchy/themes`.
2. See how an existing theme is done via `/usr/share/unbloarchy/themes/catppuccin`.
3. Download a matching background (or several) from the internet and put them in `~/.config/unbloarchy/themes/<name-of-new-theme>/backgrounds/`.
4. When done with the theme, run `unbloarchy theme set "Name of new theme"`.

Additional user backgrounds for any theme (stock or custom) go in
`~/.config/unbloarchy/backgrounds/<theme-slug>/`.

## What a Theme Installed From a Repo May Not Contain

A theme the user wrote by hand in `~/.config/unbloarchy/themes` is unrestricted, as
are Unbloarchy's own themes. From a theme cloned by `unbloarchy theme install`, Unbloarchy
drops only what runs code: any `*.lua` (Hyprland requires a theme's
`hyprland.lua` and `gum_env.lua` at login, Neovim loads `neovim.lua` at startup),
the terminal configs `alacritty.toml`, `foot.ini`, `ghostty.conf` and
`kitty.conf` (each names the program the terminal launches), and `vscode.json`
(names a VS Code extension to install). Those are regenerated from `colors.toml`
through `$UNBLOARCHY_PATH/default/themed/*.tpl`, and named on stderr.

Everything else a cloned theme ships is kept, including `btop.theme`,
`chromium.theme`, `helix.toml`, `icons.theme`, `keyboard.rgb` and `shell.toml`.
Unbloarchy tells a cloned theme from the user's own by the `.git` directory a clone
leaves behind.

To change how Unbloarchy themes an app for every theme, write the template rather
than the theme: `~/.config/unbloarchy/themed/<config-name>.tpl` overrides the
built-in one. See `docs/theming.md` in the Unbloarchy repo.

## Customizing a Stock Theme

Never edit stock themes under `/usr/share/unbloarchy/themes/` — changes are lost
on update. Two safe options:

Both write into `~/.config/unbloarchy/themes`, where a theme the user wrote is
unrestricted — the list above applies only to a theme cloned from a repo.

**Overlay (preferred for small tweaks):** create a user theme directory with
the SAME slug containing only the files you want to change. When the theme is
applied, the stock theme is copied first and your files win on top:

```bash
mkdir -p ~/.config/unbloarchy/themes/catppuccin
cp /usr/share/unbloarchy/themes/catppuccin/colors.toml ~/.config/unbloarchy/themes/catppuccin/
# Edit the copied colors.toml, then re-apply:
unbloarchy theme set catppuccin
```

**Fork:** copy the whole stock theme under a new name for a fully independent
variant:

```bash
cp -r /usr/share/unbloarchy/themes/catppuccin ~/.config/unbloarchy/themes/catppuccin-custom
# Edit ~/.config/unbloarchy/themes/catppuccin-custom/, then:
unbloarchy theme set catppuccin-custom
```

## Fonts

```bash
unbloarchy font list               # Available fonts
unbloarchy font current            # Current font
unbloarchy font set <name>         # Change font
```
