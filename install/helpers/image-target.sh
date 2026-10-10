# Image builds and the hardware setup they defer to the machine's first boot.
# Sourced by unbloarchy-apply-hardware and unbloarchy-provision-hardware; no shebang.
#
# An image is built away from the machine it will run on, so hardware setup
# during the build would describe the builder, not the target. The builder
# declares the build in a root-owned manifest before it runs
# unbloarchy-apply-system in the image root:
#
#   /var/lib/omarchy/image/target
#     format=1
#     platform=x86|aarch64|aarch64-apple
#
# While it exists, unbloarchy-apply-hardware queues each hardware leaf in
# /var/lib/omarchy/image/deferred-steps instead of running it, and arms
# unbloarchy-provision-hardware.service. On the machine's first boot that service,
# or the platform's own first boot, retires the manifest (to target.booted) and
# runs the queue on the real hardware. Unknown manifest keys are ignored so the
# format can grow.
#
# An image carries no pacman master key of its own, or every machine flashed
# from it would share one: where install finalization would make the keyring
# (install/post-install/pacman.sh), a build requests it in
# /var/lib/omarchy/image/pacman-keyring instead, and the first boot makes it
# before any deferred step runs.
#
# The manifest is also the only source of the image's platform: until that boot,
# unbloarchy-hw-platform reports its platform instead of the build host's, so the
# initramfs, services and packages the build sets up are the target's. It reads
# the manifest by the same rules as unbloarchy_image_read_manifest below.
#
# Root always uses the fixed paths. Only a non-root test may move them under
# UNBLOARCHY_IMAGE_ROOT, so no environment variable can make a live system defer,
# skip or replay its hardware setup.

unbloarchy_image_init() {
  if (( EUID == 0 )); then
    unbloarchy_image_root=""
  elif [[ -n ${UNBLOARCHY_IMAGE_ROOT:-} ]]; then
    unbloarchy_image_root=$UNBLOARCHY_IMAGE_ROOT
  else
    echo "Error: image setup state is root-owned; run as root" >&2
    return 1
  fi

  unbloarchy_image_dir=$omarchy_image_root/var/lib/omarchy/image
  unbloarchy_image_manifest=$unbloarchy_image_dir/target
  unbloarchy_image_queue=$unbloarchy_image_dir/deferred-steps
  unbloarchy_image_initramfs_baseline=$unbloarchy_image_dir/initramfs-inputs
  unbloarchy_image_boot_rebuild=$unbloarchy_image_dir/boot-rebuild
  unbloarchy_image_keyring_request=$unbloarchy_image_dir/pacman-keyring
  unbloarchy_image_unit=unbloarchy-provision-hardware.service
  unbloarchy_image_systemd_dir=$unbloarchy_image_root/etc/systemd/system
}

# Owned by whoever runs this (root on a live system), not a symlink, and not
# writable by anyone else.
unbloarchy_image_trusted() {
  local path=$1 owner mode

  [[ -e $path && ! -L $path ]] || return 1
  read -r owner mode < <(stat -c '%u %a' -- "$path") || return 1
  (( owner == EUID && (8#$mode & 8#022) == 0 ))
}

unbloarchy_image_manifest_present() {
  [[ -e $unbloarchy_image_manifest || -L $unbloarchy_image_manifest ]]
}

# Sets unbloarchy_image_platform, or fails without guessing whether this is a build.
unbloarchy_image_read_manifest() {
  local line key value format="" platform=""

  if [[ ! -d $unbloarchy_image_dir || ! -f $unbloarchy_image_manifest ]] || ! unbloarchy_image_trusted "$unbloarchy_image_dir" ||
    ! unbloarchy_image_trusted "$unbloarchy_image_manifest"; then
    echo "Error: $unbloarchy_image_manifest is not a root-owned regular file" >&2
    return 1
  fi

  while IFS= read -r line || [[ -n $line ]]; do
    [[ -n $line && $line != \#* ]] || continue
    if [[ $line != *=* ]]; then
      echo "Error: $unbloarchy_image_manifest is malformed: $line" >&2
      return 1
    fi
    key=${line%%=*}
    value=${line#*=}
    case $key in
      format) format=$value ;;
      platform) platform=$value ;;
    esac
  done <"$unbloarchy_image_manifest"

  if [[ $format != "1" ]]; then
    echo "Error: $unbloarchy_image_manifest is not format=1" >&2
    return 1
  fi
  # Builders written before the platform names settled say apple-silicon,
  # generic-aarch64 or generic (as unbloarchy-hw-platform reads them too).
  case $platform in
    apple-silicon) platform=aarch64-apple ;;
    generic-aarch64) platform=aarch64 ;;
    generic) platform=x86 ;;
  esac
  case $platform in
    x86 | aarch64 | aarch64-apple) ;;
    *)
      echo "Error: $unbloarchy_image_manifest names no known platform: ${platform:-none}" >&2
      return 1
      ;;
  esac

  unbloarchy_image_platform=$platform
}

# Holds the image state still for the rest of the caller, so hardware setup and
# a first-boot run never overlap or decide from a manifest the other retires.
# A machine that was never an image has no state and nothing to lock.
unbloarchy_image_lock() {
  [[ -e $unbloarchy_image_dir || -L $unbloarchy_image_dir ]] || return 0
  if [[ ! -d $unbloarchy_image_dir ]] || ! unbloarchy_image_trusted "$unbloarchy_image_dir"; then
    echo "Error: $unbloarchy_image_dir is not a root-owned directory" >&2
    return 1
  fi
  exec {unbloarchy_image_lock_fd}>>"$unbloarchy_image_dir/lock" || return 1
  flock "$unbloarchy_image_lock_fd"
}

unbloarchy_image_write_queue() {
  local tmp

  tmp=$(mktemp "$unbloarchy_image_dir/.deferred-steps.XXXXXX") || return 1
  if (( $# )); then
    printf '%s\n' "$@" >"$tmp" || { rm -f "$tmp"; return 1; }
  fi
  chmod 0644 "$tmp" && mv -f "$tmp" "$unbloarchy_image_queue"
}

# Queue every leaf install/hardware/all.sh would run, in its order, running
# none of them, then arm the first-boot service. Rerunning rewrites the same queue.
unbloarchy_image_defer_hardware() {
  local listing
  local -a steps=()

  listing=$(
    run_logged() {
      [[ $1 == "$UNBLOARCHY_INSTALL"/hardware/*.sh && $1 != *..* ]] || {
        echo "Error: cannot defer a step outside the hardware setup: $1" >&2
        exit 1
      }
      printf 'install/%s\n' "${1#"$UNBLOARCHY_INSTALL"/}"
    }
    source "$UNBLOARCHY_INSTALL/hardware/all.sh"
  ) || return 1

  [[ -z $listing ]] || mapfile -t steps <<<"$listing"
  unbloarchy_image_write_queue "${steps[@]}" || return 1

  install -d -m 0755 "$unbloarchy_image_systemd_dir/multi-user.target.wants" &&
    install -m 0644 "$UNBLOARCHY_INSTALL/provisioning/$unbloarchy_image_unit" "$unbloarchy_image_systemd_dir/$unbloarchy_image_unit" &&
    ln -sfn "/etc/systemd/system/$unbloarchy_image_unit" "$unbloarchy_image_systemd_dir/multi-user.target.wants/$unbloarchy_image_unit" ||
    return 1

  echo "Image build for $unbloarchy_image_platform: deferred ${#steps[@]} hardware steps to first boot"
}
