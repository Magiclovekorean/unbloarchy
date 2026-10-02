echo "Install Hype, the Markdown presentation app"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-pkg-add hype
fi
