echo "Install Gliff on aarch64, now that Unbloarchy's repositories build it there"

if unbloarchy-hw-aarch64; then
  unbloarchy-pkg-add gliff
fi
