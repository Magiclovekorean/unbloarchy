tmp=$(mktemp)

cat >"$tmp" <<EOF
#!/bin/bash
exec "$HOME/.local/share/unbloarchy/bin/unbloarchy-agent" "$@"
EOF

sudo install -m 0755 "$tmp" /usr/local/bin/unbloarchy-agent-shim
