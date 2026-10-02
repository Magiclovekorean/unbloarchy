echo "Install ori (OpenRouter's agent harness) via mise wrapper"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-mise-install github:OpenRouterLabs/ori-releases ori
fi
