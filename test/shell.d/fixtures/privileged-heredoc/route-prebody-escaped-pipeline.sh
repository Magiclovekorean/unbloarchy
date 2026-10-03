#!/bin/bash

cat <<EOF | \
  sudo tee /etc/unbloarchy/review.conf
ExecStart=$HOME/.local/bin/payload
EOF
