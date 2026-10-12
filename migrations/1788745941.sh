echo "Update Kitty configuration"

kitty_config="$HOME/.config/kitty/kitty.conf"
# config/kitty/kitty.conf as shipped after 008f3a22 (Kitty cwd lookup).
stock_sha="b671240e551259a5317a1331cf9ad299aac1f606ae9ba29054e0a573485237fd"
unrestricted='^[[:space:]]*allow_remote_control[[:space:]]+(yes|y|true)[[:space:]]*$'

if [[ -f $kitty_config ]]; then
  changed=false

  if [[ $(sha256sum "$kitty_config" | cut -d ' ' -f 1) == $stock_sha ]]; then
    unbloarchy-refresh-config kitty/kitty.conf
    changed=true
  elif grep -qE "$unrestricted" "$kitty_config"; then
    # Preserve customizations and ordering. An otherwise stock line can be an
    # intentional override of an earlier include or mapping.
    backup=$(mktemp "$kitty_config.bak.XXXXXX")
    cp -p "$kitty_config" "$backup"
    sed --follow-symlinks -i -E "s/$unrestricted/# &/" "$kitty_config"
    printf '\n%s\n' \
      "Unrestricted remote control disabled." \
      "Your other Kitty settings were preserved."
    printf '\nBackup saved to:\n  %s\n' "$backup"
    changed=true
  fi

  if [[ $changed == "true" ]]; then
    # Kitty reads allow_remote_control at startup; config reload is insufficient.
    gum style --border rounded --border-foreground 3 --padding "1 2" --margin "1 0" \
      "Restart Kitty" "" \
      "Close and reopen all Kitty windows to apply this change."
  fi
fi
