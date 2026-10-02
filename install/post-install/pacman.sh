# Configure pacman after package installation completes. Offline target package
# installs use the live ISO's offline pacman.conf until this final restore.
cp -f "$UNBLOARCHY_PATH/default/pacman/pacman-${UNBLOARCHY_MIRROR:-stable}.conf" /etc/pacman.conf
cp -f "$UNBLOARCHY_PATH/default/pacman/mirrorlist-${UNBLOARCHY_MIRROR:-stable}" /etc/pacman.d/mirrorlist

# Wait for CUPS to own the file, the way omarchy-settings does, so pacman does
# not turn the override into a .pacnew during ISO package installation.
if [[ -f $UNBLOARCHY_PATH/etc-overrides/cups-cups-files.conf && -f /etc/cups/cups-files.conf ]]; then
  install -m 0640 -o root -g cups "$UNBLOARCHY_PATH/etc-overrides/cups-cups-files.conf" /etc/cups/cups-files.conf
  rm -f /etc/cups/cups-files.conf.pacnew
fi

source "$UNBLOARCHY_INSTALL/hardware/pacman.sh"
