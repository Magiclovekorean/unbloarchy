echo "Relink Neovim theme to Unbloarchy current state"

theme_link="$HOME/.config/nvim/lua/plugins/theme.lua"
legacy_absolute_target="$HOME/.config/unbloarchy/current/theme/neovim.lua"
legacy_relative_target="../../../unbloarchy/current/theme/neovim.lua"
legacy_home_target="~/.config/unbloarchy/current/theme/neovim.lua"
current_relative_target="../../../../.local/state/unbloarchy/current/theme/neovim.lua"

[[ -L $theme_link ]] || exit 0

target=$(readlink "$theme_link") || exit 0

case "$target" in
  "$legacy_absolute_target"|"$legacy_relative_target"|"$legacy_home_target")
    ln -sfn "$current_relative_target" "$theme_link"
    ;;
esac
