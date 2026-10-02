# `>|` is a plain redirect with noclobber overridden, not a redirect into a pipe.
cat >|/etc/unbloarchy/agent.conf <<EOF
helper=$HOME/.local/share/unbloarchy/bin/unbloarchy-agent
EOF
