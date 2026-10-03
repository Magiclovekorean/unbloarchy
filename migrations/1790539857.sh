echo "Install Monologue, the webcam recorder"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-pkg-add monologue
fi
