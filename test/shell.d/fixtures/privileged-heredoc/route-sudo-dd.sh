sudo dd status=none of=/etc/unbloarchy/boot.conf <<EOF
cmdline=$boot_params
EOF
