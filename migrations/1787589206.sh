echo "Require signed packages from the Unbloarchy repository"

# The [omarchy] repo predates the Unbloarchy packaging key, so existing installs
# carry a SigLevel override that also accepts unsigned packages. Packages are
# signed now, so drop the override and let the repo inherit the global
# SigLevel = Required DatabaseOptional like every other repo. Machine-wide and
# self-detecting, so another user's rerun no-ops.
unbloarchy_sig_override='SigLevel = Optional TrustAll'

if [[ -f /etc/pacman.conf ]] &&
  sed -n '/^\[unbloarchy\]/,/^\[/p' /etc/pacman.conf | grep -qxF "$unbloarchy_sig_override"; then
  # Requiring signatures with an untrusted packaging key would fail every
  # unbloarchy transaction, including the one that could repair it.
  if unbloarchy-pkg-missing omarchy-keyring ||
    ! sudo pacman-key --list-keys 40DFB630FF42BCFFB047046CF0134EE680CAC571 &>/dev/null; then
    unbloarchy-update-keyring
  fi

  sudo sed -i "/^\[unbloarchy\]/,/^\[/{/^$unbloarchy_sig_override$/d}" /etc/pacman.conf
fi
