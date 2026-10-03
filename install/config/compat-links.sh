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

  ln -sfn "$target" "$legacy"
}

# The install root, for dotfiles and scripts that reference it directly.
create_compat_link /usr/share/omarchy "$UNBLOARCHY_PATH"

# The bare router name is not matched by the package's bin/omarchy-* glob, so
# the packaged build only ships it if its PKGBUILD installs it explicitly.
# `omarchy update`, `omarchy doctor`, and the ISO chroot entrypoints all use
# the bare name.
create_compat_link /usr/bin/omarchy /usr/bin/unbloarchy