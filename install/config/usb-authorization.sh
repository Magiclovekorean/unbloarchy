echo "Configure USB device authorization"

install -Dm644 "$UNBLOARCHY_PATH/default/polkit/org.unbloarchy.usb.policy" /usr/share/polkit-1/actions/org.unbloarchy.usb.policy

# A deferred install has only the builder's peripherals attached. The owner
# needs working input before there is an account or a session for approvals.
if [[ -z ${UNBLOARCHY_INSTALL_USER:-} ]]; then
  systemctl disable usbguard.service
  return 0
fi

rules_file="${UNBLOARCHY_USB_AUTHORIZATION_RULES_FILE:-/etc/usbguard/rules.conf}"
daemon_config="${UNBLOARCHY_USB_AUTHORIZATION_DAEMON_CONFIG:-/etc/usbguard/usbguard-daemon.conf}"

source "$UNBLOARCHY_INSTALL/helpers/usb-authorization.sh"
usb_authorization_require_secure_settings "$daemon_config"

if [[ ! -s $rules_file ]]; then
  usb_authorization_install_policy "$rules_file"
fi

usb_authorization_add_user "$UNBLOARCHY_INSTALL_USER"

# Installs are followed by a reboot, so enable the daemon without starting it
# in the live ISO's chroot.
systemctl enable usbguard.service
