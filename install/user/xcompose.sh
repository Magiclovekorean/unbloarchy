# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run unbloarchy-restart-xcompose to apply changes

# Include fast emoji access
include "/usr/share/unbloarchy/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$UNBLOARCHY_USER_NAME"
<Multi_key> <space> <e> : "$UNBLOARCHY_USER_EMAIL"
EOF
