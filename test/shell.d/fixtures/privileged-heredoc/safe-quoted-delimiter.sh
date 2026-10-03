cat <<'EOF' | sudo tee /etc/udev/rules.d/99-unbloarchy.rules >/dev/null
SUBSYSTEM=="power_supply", RUN+="/usr/bin/unbloarchy-powerprofiles-set $HOME"
EOF

cat <<"XML" | sudo tee /etc/unbloarchy/agent.xml >/dev/null
<config path="$HOME/.local/share/unbloarchy" />
XML
