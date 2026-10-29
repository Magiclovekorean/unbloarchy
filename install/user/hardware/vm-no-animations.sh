# A VM usually renders on the CPU, where animations and transparency cost
# every frame, so start it without them and with opaque windows.
# unbloarchy-toggle-animations and Appearance > Windows > Window Opacity bring them
# back. This runs before any Hyprland session exists, so place the flags
# directly rather than through the commands, which reload Hyprland.
if unbloarchy-hw-vm; then
  echo "Detected a virtual machine. Turning off animations and transparency."
  mkdir -p "$HOME/.local/state/unbloarchy/toggles/hypr"
  cp "$UNBLOARCHY_PATH/default/hypr/toggles/no-animations.lua" "$HOME/.local/state/omarchy/toggles/hypr/"
  cp "$UNBLOARCHY_PATH/default/hypr/toggles/window-opaque.lua" "$HOME/.local/state/omarchy/toggles/hypr/"
fi
