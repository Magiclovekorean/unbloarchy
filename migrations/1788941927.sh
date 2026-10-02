echo "Install basecamp (basecamp-cli) via mise wrapper"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-mise-install github:basecamp/basecamp-cli basecamp
fi
