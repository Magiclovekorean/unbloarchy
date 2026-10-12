echo "Seed Unbloarchy screensaver and About branding off the pre-rename path"

# The upstream omarchy-settings package still seeds its branding files into
# /etc/skel/.config/omarchy/branding, while the runtime reads them from
# ~/.config/unbloarchy/branding. migrations/1791018295.sh renamed those trees,
# but an install that already carried its migration markers (every fresh
# install) never ran it, so the branding is stranded under the old path and the
# screensaver dies on a missing input file. Nothing here creates the branding
# for the first time: the packaged config seeds /etc/skel and the fallback in
# bin/unbloarchy-screensaver covers a machine that is still bare. This only
# fills in a missing file, preferring the user's own pre-rename art.

branding_dir="$HOME/.config/unbloarchy/branding"
mkdir -p "$branding_dir"

seed() {
  local dest=$1 legacy=$2 source=$3

  [[ -f $dest ]] && return 0

  if [[ -f $legacy ]]; then
    cp "$legacy" "$dest"
  elif [[ -f $source ]]; then
    cp "$source" "$dest"
  fi
}

seed "$branding_dir/screensaver.txt" \
  "$HOME/.config/omarchy/branding/screensaver.txt" \
  "$UNBLOARCHY_PATH/logo.txt"
seed "$branding_dir/about.txt" \
  "$HOME/.config/omarchy/branding/about.txt" \
  "$UNBLOARCHY_PATH/icon.txt"
