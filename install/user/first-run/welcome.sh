# Real newlines, not a literal \n: the card renders the body as it arrives, and
# elides past three lines.
unbloarchy-notification-send -u critical -g  "Learn Keybindings" \
  $'Super + K for cheatsheet.\nSuper + Space for Unbloarchy Menu.' \
  --exec unbloarchy-menu-keybindings
