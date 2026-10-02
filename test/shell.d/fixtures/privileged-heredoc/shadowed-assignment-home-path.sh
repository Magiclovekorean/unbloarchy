#!/bin/bash

# The name is introduced with a packaged root-owned value and then reassigned to
# one under the user's home. Judging the first assignment would read this as the
# path it no longer holds.
target=/usr/share/unbloarchy/bin/agent
target="$HOME/.local/share/unbloarchy/bin/agent"

# unbloarchy:heredoc-expands paths=none -- target is the packaged agent path under /usr
cat <<EOF | sudo tee /etc/systemd/system/unbloarchy-agent.service >/dev/null
[Service]
ExecStart=$target
EOF
