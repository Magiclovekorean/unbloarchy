#!/bin/bash

# unbloarchy:heredoc-expands paths=none -- review regression fixture
sudo tee /etc/unbloarchy/review.conf >/dev/null <<EOF
ExecStart=${target:-$HOME/.local/bin/payload}
EOF
