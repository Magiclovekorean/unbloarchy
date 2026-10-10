echo "Install Gliff, the Hyprland remote desktop over SSH"

# Gliff has no aarch64 build (install/unbloarchy-x86_64-only.packages).
if unbloarchy-hw-x86; then
  unbloarchy-pkg-add gliff
fi
