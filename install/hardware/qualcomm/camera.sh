# Snapdragon cameras run through libcamera, which apps reach through
# PipeWire's libcamera backend.

if unbloarchy-hw-aarch64-qualcomm; then
  unbloarchy-pkg-add pipewire-libcamera
fi
