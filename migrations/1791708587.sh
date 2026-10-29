echo "Install Signed, the PDF signing app"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-pkg-add signed
fi
