echo "Move an Omarchy-era install onto the Unbloarchy paths"

# The rename moved every in-repo identifier: command names, environment
# variables, the install root, the config and state directories, the unit and
# drop-in filenames, and the shell's widget ids. An install that predates it
# still has all of them under the old names, so this moves that install
# forward.
#
# Order matters. Per-user trees move first because they are unprivileged and
# everything below them reads from the new paths. Machine-wide repairs follow,
# and the install root moves last because the per-user state under it is what
# the later steps depend on.
#
# Every step checks before it changes. Completion is per-user, so the
# machine-wide repairs below run again for each account on the box and must
# no-op for everyone after the first.

config_home=${XDG_CONFIG_HOME:-$HOME/.config}
state_home=${XDG_STATE_HOME:-$HOME/.local/state}
data_home=${XDG_DATA_HOME:-$HOME/.local/share}

# The pre-rename tree wins over the packaged copy already sitting at the new
# path: it holds the user's actual state, and the packaged file is the default
# that state was derived from. Directories are merged rather than replaced so
# a partially-populated new tree does not lose what the old one carries.
move_tree() {
  local from=$1 to=$2 entry base
  [[ -d $from && ! -L $from ]] || return 0

  if [[ -L $to ]]; then
    echo "Error: $to is a symlink; refusing to merge the old tree into it." >&2
    exit 1
  fi

  mkdir -p "$to"
  while IFS= read -r -d '' entry; do
    base=${entry##*/}
    if [[ -d $entry && ! -L $entry && -d $to/$base && ! -L $to/$base ]]; then
      move_tree "$entry" "$to/$base"
    else
      rm -rf "${to:?}/$base"
      mv "$entry" "$to/$base"
    fi
  done < <(find "$from" -mindepth 1 -maxdepth 1 -print0)
  rmdir "$from" 2>/dev/null || true
}

# A symlinked config or state directory points into a pre-rename checkout.
# Copy what it holds across and then drop the link: `mv` would strip the files
# out of the checkout, and dropping the link outright would lose the user's own
# layout, which is the one thing this migration exists to preserve. The copy is
# still pre-rename content, and the rewrite below brings it forward.
move_legacy_tree() {
  local legacy=$1 target=$2 entry base

  if [[ -L $legacy ]]; then
    if [[ -d $legacy ]]; then
      echo "Copying the pre-rename symlink $legacy -> $(readlink "$legacy")"
      mkdir -p "$target"
      cp -a "$legacy/." "$target/"
    fi
    rm -f "$legacy"
  fi

  move_tree "$legacy" "$target"
}

for legacy in "$config_home/omarchy" "$state_home/omarchy" "$data_home/omarchy"; do
  move_legacy_tree "$legacy" "${legacy%/omarchy}/unbloarchy"
done

# The bar layout is the one piece of user state whose ids the rename
# invalidated, and losing them empties the bar without any error: the shell
# finds no widget for each id and renders nothing. Rewrite them in place,
# following the shape migrations/1790528634.sh established for the same job.
shell_json="$config_home/unbloarchy/shell.json"
if [[ -s $shell_json ]] && grep -q 'omarchy\.' "$shell_json"; then
  if ! unbloarchy-cmd-present jq; then
    echo "Error: jq is required to rewrite the bar widget ids in $shell_json." >&2
    exit 1
  fi

  shell_json_tmp=$(mktemp)
  if jq '
      def rename:
        if type == "string" and startswith("omarchy.") then
          "unbloarchy." + ltrimstr("omarchy.")
        elif type == "object" and (.id | type) == "string" and (.id | startswith("omarchy.")) then
          .id = "unbloarchy." + (.id | ltrimstr("omarchy."))
        else . end;

      if (.bar.layout | type) == "object" then .bar.layout |= map_values(if type == "array" then map(rename) end) end
      | if (.bar.centerAnchor | type) == "string" then .bar.centerAnchor |= rename end
      | if (.plugins | type) == "array" then .plugins |= map(rename) end
      | if (.disabledPlugins | type) == "array" then .disabledPlugins |= map(rename) end
    ' "$shell_json" >"$shell_json_tmp"; then
    mv "$shell_json_tmp" "$shell_json"
  else
    rm -f "$shell_json_tmp"
    echo "Error: could not rewrite the bar widget ids in $shell_json." >&2
    exit 1
  fi
fi

# Qt keeps matching a stale copy of the old family and silently renders the
# old glyphs, so the legacy files have to be gone before the new family is
# used. Symlinks are left alone: migrations/1788848726.sh preserves those as
# deliberate user choices.
for legacy_font in "$data_home/fonts/omarchy.ttf" "$config_home/omarchy.ttf"; do
  [[ -f $legacy_font && ! -L $legacy_font ]] && rm -f "$legacy_font"
done

# The packaged units now carry unbloarchy-* names, so the old enablements
# point at files nothing ships. Drop them by hand rather than through
# `systemctl disable`, which fails outright when the unit is already gone and
# would otherwise take the migration queue down with it.
wants_dir="$config_home/systemd/user/graphical-session.target.wants"
default_wants_dir="$config_home/systemd/user/default.target.wants"

for old_unit in omarchy-crash-watch omarchy-fcitx5 omarchy-migrate-notify \
  omarchy-recover-internal-monitor omarchy-sleep-lock omarchy-speaker-tuning \
  omarchy-tailscale-receive; do
  rm -f "$wants_dir/$old_unit.service" "$default_wants_dir/$old_unit.service"
done

# Enable the replacements with the same set install/user/first-run/enable-user-units.sh
# uses. speaker-tuning and tailscale-receive are left off: their own commands
# enable them when they are actually set up.
for unit in unbloarchy-recover-internal-monitor unbloarchy-sleep-lock \
  unbloarchy-migrate-notify unbloarchy-fcitx5 unbloarchy-crash-watch; do
  systemctl --user enable "$unit.service" >/dev/null 2>&1 ||
    ln -sfn "/usr/lib/systemd/user/$unit.service" "$wants_dir/$unit.service"
done

systemctl --user daemon-reload >/dev/null 2>&1 || true

# /etc/omarchy.conf carries a `unbloarchy dev link` checkout in OMARCHY_PATH.
# Rewrite the variable name rather than dropping the file, or an upgraded dev
# install silently falls back to the packaged root on the next boot.
if [[ -f /etc/omarchy.conf && ! -e /etc/unbloarchy.conf ]]; then
  sed 's/\bOMARCHY_PATH\b/UNBLOARCHY_PATH/g' /etc/omarchy.conf |
    sudo tee /etc/unbloarchy.conf >/dev/null
  sudo rm -f /etc/omarchy.conf
fi

# Every drop-in the fork owns had `omarchy` in its filename, and in every case
# the new name is the old name with the brand substituted -- `omarchy_hooks.conf`
# keeps its underscore, `90-omarchy.conf` keeps its prefix. Walk the
# directories those files live in and move each match. Where the new name is
# already present the package has installed it and the old file is a stale
# duplicate with no remaining referent, so the old one goes instead.
# `mv` preserves mode and ownership, which sudoers depends on.
# /usr/lib/systemd/user is in the list because a unit left under its old name
# alongside the new one has no referent but would still be loaded, putting two
# instances of the same unit in one session. The already-installed-wins rule
# below drops the old copy instead of producing that pair.
# Absolute paths, not $UNBLOARCHY_PATH: these repair what the *packaged*
# install put on disk, and a session that is dev-linked to a checkout still
# needs the packaged root and its compat links repaired underneath it.
for dir in /etc/NetworkManager/conf.d /etc/fastfetch /etc/fontconfig/conf.avail \
  /etc/fonts/conf.d /etc/limine-entry-tool.d /etc/mise/conf.d \
  /etc/mkinitcpio.conf.d /etc/modprobe.d /etc/oomd.conf.d /etc/pam.d \
  /etc/profile.d /etc/snapper/config-templates /etc/sudoers.d /etc/sysctl.d \
  /etc/sysusers.d /etc/systemd/logind.conf.d /etc/systemd/oomd.conf.d \
  /etc/systemd/resolved.conf.d /etc/systemd/system.conf.d \
  /etc/systemd/system/cups-browsed.service.d /etc/systemd/user.conf.d \
  /etc/tmpfiles.d /etc/udev/rules.d /etc/xdg \
  /usr/lib/environment.d /usr/lib/systemd/user \
  /usr/lib/systemd/zram-generator.conf.d \
  /usr/local/share/wayland-sessions /usr/share/environment.d /usr/share/icons \
  /usr/share/pixmaps /usr/share/plymouth/themes /usr/share/sddm/themes \
  /usr/share/uwsm/env.d; do
  [[ -d $dir ]] || continue

  for old in "$dir"/*omarchy*; do
    [[ -e $old || -L $old ]] || continue
    base=${old##*/}
    new="$dir/${base/omarchy/unbloarchy}"

    if [[ -e $new || -L $new ]]; then
      sudo rm -f "$old"
    else
      sudo mv "$old" "$new"
    fi
  done
done

# /usr/share/fonts/omarchy/unbloarchy.ttf renames in two steps: the directory
# first, then the file inside it, so neither half is left pointing at nothing.
if [[ -d /usr/share/fonts/omarchy && ! -e /usr/share/fonts/unbloarchy ]]; then
  sudo mv /usr/share/fonts/omarchy /usr/share/fonts/unbloarchy
fi
if [[ -e /usr/share/fonts/unbloarchy/omarchy.ttf ]]; then
  if [[ -e /usr/share/fonts/unbloarchy/unbloarchy.ttf ]]; then
    sudo rm -f /usr/share/fonts/unbloarchy/omarchy.ttf
  else
    sudo mv /usr/share/fonts/unbloarchy/omarchy.ttf /usr/share/fonts/unbloarchy/unbloarchy.ttf
  fi
fi

# New-user skeletons, so a user created after this migration does not start
# with an old-brand home directory.
for legacy in /etc/skel/.config/omarchy /etc/skel/.local/state/omarchy \
  /etc/skel/.local/share/omarchy; do
  [[ -e $legacy ]] || continue
  if [[ -e ${legacy%/omarchy}/unbloarchy ]]; then
    sudo rm -rf "$legacy"
  else
    sudo mv "$legacy" "${legacy%/omarchy}/unbloarchy"
  fi
done

# Provisioning state, the passwordless-sudo quarantine, and the install log all
# moved with the rest. These are machine-wide, so the second account to run
# this finds them already in place.
if [[ -d /var/lib/omarchy ]]; then
  if [[ -e /var/lib/unbloarchy ]]; then
    sudo cp -a /var/lib/omarchy/. /var/lib/unbloarchy/
    sudo rm -rf /var/lib/omarchy
  else
    sudo mv /var/lib/omarchy /var/lib/unbloarchy
  fi
fi

if [[ -f /var/log/omarchy-install.log && ! -e /var/log/unbloarchy-install.log ]]; then
  sudo mv /var/log/omarchy-install.log /var/log/unbloarchy-install.log
fi

# The SDDM theme and the Limine UKI name are values inside files the rename
# did not move, because their filenames carry no brand.
if [[ -f /etc/sddm.conf.d/10-theme.conf ]] && grep -q 'Current=omarchy' /etc/sddm.conf.d/10-theme.conf; then
  sudo sed -i 's/^Current=omarchy$/Current=unbloarchy/' /etc/sddm.conf.d/10-theme.conf
fi

if [[ -f /etc/limine-entry-tool.d/unbloarchy-defaults.conf ]]; then
  sudo sed -i 's/CUSTOM_UKI_NAME="omarchy"/CUSTOM_UKI_NAME="unbloarchy"/' \
    /etc/limine-entry-tool.d/unbloarchy-defaults.conf
fi

# The pre-rename UKI is still on disk and still bootable, so rename it rather
# than leaving an entry no installed tool refers to.
if [[ -e /boot/EFI/Linux/omarchy_linux.efi && ! -e /boot/EFI/Linux/unbloarchy_linux.efi ]]; then
  sudo mv /boot/EFI/Linux/omarchy_linux.efi /boot/EFI/Linux/unbloarchy_linux.efi
fi

# The install root moves last: everything above resolves through
# $UNBLOARCHY_PATH, and the running session still has the old one open. An older
# install still has /usr/share/omarchy on disk and no package owns it any more.
if [[ -d /usr/share/omarchy && ! -L /usr/share/omarchy ]]; then
  if [[ -d /usr/share/omarchy/bin ]]; then
    if [[ -e /usr/share/unbloarchy ]]; then
      sudo rm -rf /usr/share/omarchy
    else
      sudo mv /usr/share/omarchy /usr/share/unbloarchy
    fi
  else
    # A directory sharing the name but holding no bin/ is not an install root.
    # It is either a leftover from an interrupted run or a directory of the
    # user's own. The two cannot be told apart, and guessing wrong deletes
    # someone's data, so leave it and skip the link below. Everything else in
    # this migration has already completed by now, so continuing loses nothing
    # and this never wedges the queue.
    echo "Warning: /usr/share/omarchy holds no bin/, so it is not an install root." >&2
    echo "Warning: leaving it in place and skipping its compatibility link." >&2
  fi
fi

# Pre-rename software and user dotfiles still resolve the old root. A symlink
# rather than a package, so it survives `pacman -Qo` and is never a conflicting
# files error.
if [[ ! -e /usr/share/omarchy && ! -L /usr/share/omarchy ]]; then
  sudo ln -sfn /usr/share/unbloarchy /usr/share/omarchy
fi

# The bare router name is not matched by the package's bin/omarchy-* glob, so
# the packaged build only provides it if its PKGBUILD installs it explicitly.
# Create it here when it is missing: `omarchy update`, `omarchy doctor`, and
# the ISO chroot entrypoints all use the bare name, and this is the only place
# the gap can be closed from this repository.
if [[ -x /usr/bin/unbloarchy && ! -e /usr/bin/omarchy ]]; then
  sudo ln -s /usr/bin/unbloarchy /usr/bin/omarchy
fi

# Runtime-written units that carry the brand in their name.
if [[ -f /etc/systemd/system/omarchy-nvme-suspend-fix.service ]]; then
  sudo systemctl disable omarchy-nvme-suspend-fix.service >/dev/null 2>&1 || true
  sudo mv /etc/systemd/system/omarchy-nvme-suspend-fix.service \
    /etc/systemd/system/unbloarchy-nvme-suspend-fix.service
  sudo systemctl enable unbloarchy-nvme-suspend-fix.service >/dev/null 2>&1 || true
  sudo systemctl daemon-reload >/dev/null 2>&1 || true
fi

sudo rm -f /etc/systemd/system/omarchy-provision-autologin-once.service

if [[ -f /etc/systemd/system/omarchy-seamless-login.service ]]; then
  sudo systemctl disable omarchy-seamless-login.service >/dev/null 2>&1 || true
  sudo rm -f /etc/systemd/system/omarchy-seamless-login.service
  sudo systemctl daemon-reload >/dev/null 2>&1 || true
fi