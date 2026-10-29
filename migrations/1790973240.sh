echo "Give the ASUS ProArt P14 (NVIDIA N1x) speakers ASUS's amplifier tuning and voicing"

# See install/hardware/asus/fix-asus-proart-p14-speakers.sh and the
# asus-proart-p14-n1x speaker tuning. The amplifiers load the new tuning at the
# next boot, under a linux-unbloarchy-n1x that passes them the laptop's subsystem ID.
if ! unbloarchy-hw-match "H7407BA"; then
  exit 0
fi

unbloarchy-pkg-add asus-proart-p14-speaker-firmware

if unbloarchy-audio-tuning match >/dev/null 2>&1; then
  unbloarchy-pkg-add lsp-plugins-lv2
  unbloarchy-audio-tuning on
fi
