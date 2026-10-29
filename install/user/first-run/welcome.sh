# The catalog entry holds a real newline, not a literal \n: the card renders the
# body as it arrives, and elides past three lines.
unbloarchy-notification-send -u critical -g  "$(unbloarchy-i18n firstRun.keybindingsTitle)" \
  "$(unbloarchy-i18n firstRun.keybindingsBody)" \
  --exec unbloarchy-menu-keybindings
