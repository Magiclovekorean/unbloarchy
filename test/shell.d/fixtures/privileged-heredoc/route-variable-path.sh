DROP_IN=/etc/systemd/system/unbloarchy-agent.service.d/override.conf

cat <<EOF | sudo tee "$DROP_IN" >/dev/null
[Service]
ExecStart=$UNBLOARCHY_PATH/bin/unbloarchy-agent
EOF
