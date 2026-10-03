# A VM usually renders on the CPU, where animations and transparency cost
# every frame, so start it without them. unbloarchy-toggle-animations brings them
# back. This runs before any Hyprland session exists, so place the flag
# directly rather than through unbloarchy-hyprland-toggle, which reloads Hyprland.
if unbloarchy-hw-vm; then
  echo "Detected a virtual machine. Turning off animations and transparency."
  mkdir -p "$HOME/.local/state/unbloarchy/toggles/hypr"
  cp "$UNBLOARCHY_PATH/default/hypr/toggles/no-animations.lua" "$HOME/.local/state/unbloarchy/toggles/hypr/"
fi
