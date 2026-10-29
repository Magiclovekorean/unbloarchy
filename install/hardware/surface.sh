# The Marvell Wi-Fi firmware is for x86 Surfaces only; Snapdragon Surfaces use Qualcomm Wi-Fi.
if unbloarchy-hw-surface && unbloarchy-hw-x86; then
  unbloarchy-pkg-add linux-firmware-marvell
fi
