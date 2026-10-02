tmp=/tmp/unbloarchy-generated
cat >"$tmp" <<EOF
command=$HOME/.local/share/unbloarchy/bin/example
EOF
sudo install -m644 "${tmp}" /etc/unbloarchy/example.conf
