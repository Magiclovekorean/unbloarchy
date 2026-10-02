servers="1.1.1.1 9.9.9.9"

# unbloarchy:heredoc-expands paths=none -- $servers is a validated IP list, not a path
cat <<EOF | sudo tee /etc/unbloarchy/dns.conf >/dev/null
servers=$servers
EOF

# unbloarchy:heredoc-expands paths=storage -- validated by valid_path and symlink-checked before use
cat <<EOF | sudo tee /var/lib/unbloarchy/mounts.conf >/dev/null
source=$storage:/storage
EOF
