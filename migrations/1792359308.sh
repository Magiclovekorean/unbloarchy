echo "Let Chromium use the cameras of Snapdragon laptops through PipeWire"

if unbloarchy-hw-aarch64-qualcomm; then
  source "$UNBLOARCHY_PATH/install/hardware/qualcomm/camera.sh"
  unbloarchy-install-camera

  echo "Log out and back in to load the PipeWire camera backend."
fi
