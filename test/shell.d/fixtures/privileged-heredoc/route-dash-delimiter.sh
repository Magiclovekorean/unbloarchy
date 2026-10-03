if true; then
  cat <<-EOF | sudo tee /etc/unbloarchy/indented.conf >/dev/null
	helper=$HOME/.local/share/unbloarchy/bin/unbloarchy-agent
	EOF
fi
