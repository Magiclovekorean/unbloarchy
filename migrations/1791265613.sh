echo "Install the Dell XPS 13 Panther Lake speaker firmware"

if unbloarchy-hw-dell-xps13-dx13260-ptl; then
  source "$UNBLOARCHY_PATH/install/hardware/dell-xps13-ptl-speaker-firmware.sh"
  unbloarchy-state set reboot-required
fi
