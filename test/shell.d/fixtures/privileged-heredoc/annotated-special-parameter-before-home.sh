# unbloarchy:heredoc-expands paths=none -- the positional argument is a scalar
sudo tee /etc/unbloarchy/example.conf <<EOF
argument=$1
command=$HOME/.local/share/unbloarchy/bin/example
EOF
