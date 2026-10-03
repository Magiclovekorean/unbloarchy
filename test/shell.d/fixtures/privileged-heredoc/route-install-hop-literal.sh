#!/bin/bash

cat <<EOF >/tmp/unbloarchy-review-unit
[Service]
ExecStart=$HOME/.local/bin/payload
EOF
sudo install -m 644 /tmp/unbloarchy-review-unit /etc/systemd/system/review.service
