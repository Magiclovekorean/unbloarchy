echo "Install hey (hey-cli) via mise wrapper"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-mise-install github:basecamp/hey-cli hey
fi
