echo "Install oh-my-pi (omp) via mise wrapper"

if [[ ! -f $HOME/.local/state/unbloarchy/preinstalls-removed ]]; then
  unbloarchy-mise-install github:can1357/oh-my-pi omp
fi
