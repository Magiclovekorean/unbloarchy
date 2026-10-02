# A plain redirect into /etc, no sudo: the command re-execs itself as root.
cat >/etc/unbloarchy/agent.conf <<EOF
helper=$HOME/.local/share/unbloarchy/bin/unbloarchy-agent
EOF
