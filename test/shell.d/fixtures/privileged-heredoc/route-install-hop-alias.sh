tmp=/tmp/unbloarchy-generated
copy=$tmp
cat >"$tmp" <<EOF
command=$HOME/.local/share/unbloarchy/bin/example
EOF
sudo install -m644 "$copy" /etc/unbloarchy/example.conf
