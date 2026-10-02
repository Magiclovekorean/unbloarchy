storage="$HOME/storage"
shared="$HOME/shared"

# unbloarchy:heredoc-expands paths=shared,storage -- both sources are validated before use
cat >/etc/unbloarchy/mounts.conf <<EOF
storage=$storage:/storage
shared=$shared:/shared
EOF
