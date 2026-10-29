echo "Install Kimi coding agent mise wrapper"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]] && unbloarchy-cmd-missing kimi; then
  unbloarchy-mise-install npm:@moonshot-ai/kimi-code kimi
fi
