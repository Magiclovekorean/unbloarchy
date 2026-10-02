cat <<EOF | sudo tee /etc/udev/rules.d/99-unbloarchy.rules >/dev/null
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="/usr/bin/unbloarchy-powerprofiles-set"
EOF
