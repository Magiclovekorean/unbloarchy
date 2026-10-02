mkdir -p ~/.config/unbloarchy

cat >~/.config/unbloarchy/agent.conf <<EOF
helper=$HOME/.local/share/unbloarchy/bin/unbloarchy-agent
EOF

cat >"$HOME/.local/bin/unbloarchy-shim" <<EOF
exec "$UNBLOARCHY_PATH/bin/unbloarchy-agent" "$@"
EOF
