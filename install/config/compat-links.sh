# Pre-rename software resolves the old names. Provide them as symlinks rather
# than as packages, so `pacman -Qo` never claims them, they survive an upgrade
# untouched, and they are never a conflicting-files error.
#
# Each link targets the packaged root and deliberately does not follow
# $UNBLOARCHY_PATH when that is a dev checkout: a system-wide link resolving
# into a home directory breaks for every root-owned caller the moment the
# checkout is moved or removed, so old software keeps landing on the packaged
# root, which is the safe default.
#
# Idempotent, and a no-op when something already occupies the old path, so a
# directory that is not ours is never displaced.
create_compat_link() {
  local legacy=$1 target=$2

  # -e, not -d: one of the two targets is the router executable.
  [[ -e $target ]] || return 0
  [[ $legacy != "$target" ]] || return 0
  [[ ! -e $legacy && ! -L $legacy ]] || return 0

  mkdir -p "${legacy%/*}"
  ln -sfn "$target" "$legacy"
}

# The upstream package owns the source tree at /usr/share/omarchy. Keep that
# path package-owned and add the renamed runtime path as an unowned symlink.
create_compat_link /usr/share/unbloarchy /usr/share/omarchy

# Package defaults keep their upstream destination names so the unmodified
# omarchy-pkgs recipes can install them. Expose the renamed runtime names as
# unowned links to those package-owned files.
create_compat_link /usr/share/uwsm/env.d/10-unbloarchy /usr/share/uwsm/env.d/10-omarchy
create_compat_link /usr/lib/environment.d/10-unbloarchy-fcitx.conf /usr/lib/environment.d/10-omarchy-fcitx.conf
create_compat_link /usr/share/fontconfig/conf.avail/50-unbloarchy.conf /usr/share/fontconfig/conf.avail/50-omarchy.conf
create_compat_link /usr/share/fonts/unbloarchy/unbloarchy.ttf /usr/share/fonts/omarchy/omarchy.ttf
create_compat_link /usr/share/plymouth/themes/unbloarchy /usr/share/plymouth/themes/omarchy
create_compat_link /usr/share/sddm/themes/unbloarchy /usr/share/sddm/themes/omarchy
create_compat_link /usr/local/share/wayland-sessions/unbloarchy.desktop /usr/local/share/wayland-sessions/omarchy.desktop
create_compat_link /usr/lib/systemd/zram-generator.conf.d/90-unbloarchy.conf /usr/lib/systemd/zram-generator.conf.d/90-omarchy.conf
create_compat_link /usr/lib/systemd/system/plocate-updatedb.service.d/10-unbloarchy.conf /usr/lib/systemd/system/plocate-updatedb.service.d/10-omarchy.conf
create_compat_link /etc/snapper/config-templates/unbloarchy /etc/snapper/config-templates/omarchy

# The provisioning units live inside the package-owned /usr/share/omarchy tree
# (PKGBUILD:140) rather than at a top-level path, so the unit aliases below do
# not cover them. The installer's deferred-provisioning check reads them by
# their pre-rename names and aborts the install when either is absent, so here
# the pre-rename name is the link and the renamed file is the target.
create_compat_link /usr/share/omarchy/install/provisioning/omarchy-provision-owner.service \
  /usr/share/omarchy/install/provisioning/unbloarchy-provision-owner.service
create_compat_link /usr/share/omarchy/install/provisioning/omarchy-system-factory-reset-finish.service \
  /usr/share/omarchy/install/provisioning/unbloarchy-system-factory-reset-finish.service

for unit in crash-watch fcitx5 migrate-notify recover-internal-monitor sleep-lock \
  tailscale-receive speaker-tuning; do
  create_compat_link "/usr/lib/systemd/user/unbloarchy-$unit.service" \
    "/usr/lib/systemd/user/omarchy-$unit.service"
done
create_compat_link /usr/lib/systemd/user/unbloarchy-update-user-notify.service \
  /usr/lib/systemd/user/omarchy-update-user-notify.service

# New SDDM configuration uses the renamed theme id, while the upstream
# package recipe still installs its theme directory under the old id.

# Keep the old router name available when no package-owned wrapper exists.
create_compat_link /usr/bin/omarchy /usr/bin/unbloarchy