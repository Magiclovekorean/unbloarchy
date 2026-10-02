mask=$((1 << bits))

cat >/etc/unbloarchy/agent.conf <<EOF
helper=$HOME/.local/share/unbloarchy/bin/unbloarchy-agent
EOF
