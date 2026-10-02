#!/bin/bash

# Two hops. The scan resolves unbloarchy_bin into helper, so the value it ends up
# judging still carries an unresolved $HOME rather than a literal path.
unbloarchy_bin="$HOME/.local/share/unbloarchy/bin"
helper="$unbloarchy_bin/unbloarchy-agent"

# unbloarchy:heredoc-expands paths=none -- helper names the agent, no path is baked in
cat <<EOF | sudo tee /etc/udev/rules.d/99-unbloarchy-agent.rules >/dev/null
SUBSYSTEM=="power_supply", RUN+="$helper"
EOF
