echo "Configure Thunderbolt device authorization"

install -Dm644 "$UNBLOARCHY_PATH/default/polkit/org.unbloarchy.thunderbolt.policy" /usr/share/polkit-1/actions/org.unbloarchy.thunderbolt.policy

# The builder's accessories must not become the new owner's trust policy.
# Keep ordinary Bolt behavior until interactive owner setup has finished.
if [[ -n ${UNBLOARCHY_INSTALL_USER:-} ]]; then
  /usr/bin/unbloarchy-thunderbolt-authorization-admin prepare
  systemctl enable unbloarchy-thunderbolt-authorization.service
fi
