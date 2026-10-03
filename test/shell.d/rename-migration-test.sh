#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/base-test.sh"

# The migration itself needs jq; without it the bar rewrite is a hard error.
require_command jq

migration="$ROOT/migrations/1791018295.sh"
packaged_shell_json="$ROOT/config/unbloarchy/shell.json"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

export MROOT="$test_dir/root"
export MHOME="$test_dir/home"
export SYSTEMCTL_LOG="$test_dir/systemctl.log"

mkdir -p "$MROOT/etc" "$MROOT/usr" "$MROOT/var" "$MROOT/boot"

# Redirect only the filesystem roots, then run the real migration body. The
# developer's own home directory, /etc, /usr, /var, and /boot are never touched.
python3 - "$migration" "$test_dir/migration.sh" <<'PY'
import pathlib
import re
import sys

source = pathlib.Path(sys.argv[1]).read_text()
for root in ("/etc", "/usr", "/var", "/boot"):
    source = re.sub(r'(?<![\w/$])' + root + r'(?![\w-])', '"$MROOT"' + root, source)
source = source.replace('$HOME', '"$MHOME"')
pathlib.Path(sys.argv[2]).write_text(source)
PY

mkdir -p "$test_dir/stub"
cat > "$test_dir/stub/sudo" <<'SH'
#!/bin/bash
exec "$@"
SH
cat > "$test_dir/stub/systemctl" <<'SH'
#!/bin/bash
printf '%s\n' "$*" >> "$SYSTEMCTL_LOG"
exit 0
SH
cat > "$test_dir/stub/unbloarchy-cmd-present" <<'SH'
#!/bin/bash
for argument in "$@"; do
  [[ $argument == jq ]] && command -v jq >/dev/null 2>&1 && exit 0
done
exit 1
SH
chmod +x "$test_dir/stub"/*

seed_install() {
  rm -rf "$MROOT" "$MHOME"
  mkdir -p "$MROOT/etc" "$MROOT/usr" "$MROOT/var" "$MROOT/boot"

  # A dev-linked checkout, which /etc/omarchy.conf points at. Left intact
  # throughout, so any step that resolves through the root reads it.
  rm -rf "$test_dir/checkout"
  mkdir -p "$test_dir/checkout"
  printf 'export OMARCHY_PATH=%q\n' "$test_dir/checkout" >"$MROOT/etc/omarchy.conf"

  mkdir -p "$MROOT/etc/sudoers.d"
  printf '%%wheel ALL=(root) NOPASSWD: /usr/bin/omarchy-dns Google\n' \
    >"$MROOT/etc/sudoers.d/omarchy-dns"
  chmod 0440 "$MROOT/etc/sudoers.d/omarchy-dns"

  mkdir -p "$MROOT/etc/pam.d"
  printf 'auth sufficient pam_fprintd.so\n' >"$MROOT/etc/pam.d/omarchy-lock-fingerprint"

  mkdir -p "$MROOT/etc/snapper/config-templates"
  printf 'SUBVOLUME="/"\n' >"$MROOT/etc/snapper/config-templates/omarchy"

  mkdir -p "$MROOT/etc/sddm.conf.d"
  printf '[Theme]\nCurrent=omarchy\n' >"$MROOT/etc/sddm.conf.d/10-theme.conf"

  mkdir -p "$MROOT/etc/limine-entry-tool.d"
  printf 'CUSTOM_UKI_NAME="omarchy"\n' >"$MROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"

  mkdir -p "$MROOT/etc/skel/.config/omarchy/branding"
  printf 'Unbloarchy\n' >"$MROOT/etc/skel/.config/omarchy/branding/about.txt"

  mkdir -p "$MROOT/usr/share/omarchy/bin" "$MROOT/usr/share/omarchy/default/bash" \
    "$MROOT/usr/share/omarchy/themes"
  printf '#!/bin/bash\n' >"$MROOT/usr/share/omarchy/bin/unbloarchy"
  printf 'stock\n' >"$MROOT/usr/share/omarchy/default/bash/env-bootstrap"

  mkdir -p "$MROOT/usr/share/fonts/omarchy"
  cp "$ROOT/default/fonts/unbloarchy/unbloarchy.ttf" "$MROOT/usr/share/fonts/omarchy/omarchy.ttf"

  mkdir -p "$MROOT/usr/share/uwsm/env.d"
  printf 'export UNBLOARCHY_PATH=/usr/share/omarchy\n' >"$MROOT/usr/share/uwsm/env.d/10-omarchy"

  mkdir -p "$MROOT/usr/bin" "$MROOT/usr/lib/systemd/user"
  printf '#!/bin/bash\nexit 0\n' >"$MROOT/usr/bin/unbloarchy"
  chmod +x "$MROOT/usr/bin/unbloarchy"
  for unit in crash-watch fcitx5 migrate-notify recover-internal-monitor sleep-lock; do
    printf '[Unit]\n' >"$MROOT/usr/lib/systemd/user/omarchy-$unit.service"
  done

  mkdir -p "$MROOT/var/lib/omarchy/provisioning" "$MROOT/var/log"
  printf 'wheel\n' >"$MROOT/var/lib/omarchy/provisioning/groups"
  printf 'installed\n' >"$MROOT/var/log/omarchy-install.log"

  mkdir -p "$MROOT/boot/EFI/Linux"
  printf 'uki\n' >"$MROOT/boot/EFI/Linux/omarchy_linux.efi"

  mkdir -p "$MHOME/.config/omarchy" "$MHOME/.local/state/omarchy/current" \
    "$MHOME/.local/share/fonts" "$MHOME/.local/share/omarchy/quickapps"
  sed 's/"unbloarchy\./"omarchy./g' "$packaged_shell_json" >"$MHOME/.config/omarchy/shell.json"
  printf 'tokyonight\n' >"$MHOME/.local/state/omarchy/current/theme"
  printf 'launcher entry\n' >"$MHOME/.local/share/omarchy/quickapps/entry.json"
  printf 'user font\n' >"$MHOME/.local/share/fonts/omarchy.ttf"
  printf 'stock\n' >"$MHOME/.config/omarchy.ttf"

  mkdir -p "$MHOME/.config/systemd/user/graphical-session.target.wants"
  for unit in crash-watch sleep-lock; do
    ln -s "/usr/lib/systemd/user/omarchy-$unit.service" \
      "$MHOME/.config/systemd/user/graphical-session.target.wants/omarchy-$unit.service"
  done

  : >"$SYSTEMCTL_LOG"
}

run_migration() {
  PATH="$test_dir/stub:$PATH" env -u XDG_CONFIG_HOME -u XDG_STATE_HOME -u XDG_DATA_HOME \
    bash -euo pipefail "$test_dir/migration.sh" >"$test_dir/output" 2>&1 ||
    fail "the migration runs clean" "$(cat "$test_dir/output")"
}

# The bar layout is the one piece of state whose loss is silent: the shell finds
# no widget for each id and renders nothing. Compare semantically, because jq
# escapes non-ASCII differently than the packaged file does.
shell_json_matches_packaged() {
  cmp -s <(jq -S . "$1") <(jq -S . "$packaged_shell_json")
}

seed_install
run_migration

[[ -e $MHOME/.config/unbloarchy/shell.json ]] || fail "the config tree moves to its new path"
[[ ! -e $MHOME/.config/omarchy ]] || fail "the pre-rename config tree is gone"
shell_json_matches_packaged "$MHOME/.config/unbloarchy/shell.json" ||
  fail "every pre-rename widget id reaches the new namespace and nothing else changes"
[[ -e $MHOME/.local/state/unbloarchy/current/theme ]] || fail "generated state moves to its new path"
[[ -e $MHOME/.local/share/unbloarchy/quickapps/entry.json ]] || fail "the shared data tree moves to its new path"
[[ ! -e $MHOME/.local/share/omarchy ]] || fail "the pre-rename shared data tree is left behind"
pass "config, state, and shared trees move and the bar layout survives"

# A stale copy of the old family is what makes Qt keep rendering the old
# glyphs, so both historical locations have to be gone.
[[ ! -e $MHOME/.local/share/fonts/omarchy.ttf ]] || fail "the stale icon font is purged"
[[ ! -e $MHOME/.config/omarchy.ttf ]] || fail "the historically mislocated icon font is purged"
[[ -e $MHOME/.local/share/fonts ]] || fail "the font directory itself is left in place"
pass "stale icon font copies are purged before the new family loads"

wants="$MHOME/.config/systemd/user/graphical-session.target.wants"
[[ ! -e $wants/omarchy-crash-watch.service ]] || fail "a pre-rename unit enablement is left behind"
[[ ! -e $wants/omarchy-sleep-lock.service ]] || fail "every pre-rename unit enablement is left behind"
for unit in crash-watch sleep-lock migrate-notify fcitx5 recover-internal-monitor; do
  grep -qx -- "--user enable unbloarchy-$unit.service" "$SYSTEMCTL_LOG" ||
    fail "the renamed unit is enabled: $unit"
done
grep -qx -- "--user daemon-reload" "$SYSTEMCTL_LOG" || fail "the user manager reloads its units"
pass "stale unit enablements are dropped and the renamed ones are enabled"

# A dev-linked install reads its root out of this file on the next boot.
[[ ! -e $MROOT/etc/omarchy.conf ]] || fail "the pre-rename config file is retired"
grep -q 'OMARCHY_PATH' "$MROOT/etc/unbloarchy.conf" && fail "the retired variable name is left behind"
grep -q "^export UNBLOARCHY_PATH=$test_dir/checkout" "$MROOT/etc/unbloarchy.conf" ||
  fail "a dev-linked checkout is preserved under the new variable name"
pass "the dev-link config file moves and keeps its checkout"

[[ -e $MROOT/etc/sudoers.d/unbloarchy-dns ]] || fail "the sudoers drop-in is renamed"
[[ ! -e $MROOT/etc/sudoers.d/omarchy-dns ]] || fail "the pre-rename sudoers drop-in is left behind"
[[ $(stat -c '%a' "$MROOT/etc/sudoers.d/unbloarchy-dns") == 440 ]] ||
  fail "the renamed sudoers drop-in keeps the mode sudo requires"
[[ -e $MROOT/etc/pam.d/unbloarchy-lock-fingerprint ]] || fail "the PAM stack file is renamed"
[[ -e $MROOT/etc/snapper/config-templates/unbloarchy ]] || fail "the Snapper template is renamed"
[[ -e $MROOT/usr/lib/systemd/user/unbloarchy-crash-watch.service ]] ||
  fail "the packaged user units are renamed"
[[ -e $MROOT/usr/share/uwsm/env.d/10-unbloarchy ]] || fail "the uwsm environment drop-in is renamed"
grep -qx 'Current=unbloarchy' "$MROOT/etc/sddm.conf.d/10-theme.conf" || fail "the SDDM theme name moves"
grep -qx 'CUSTOM_UKI_NAME="unbloarchy"' "$MROOT/etc/limine-entry-tool.d/unbloarchy-defaults.conf" ||
  fail "the Limine UKI name moves"
[[ -e $MROOT/boot/EFI/Linux/unbloarchy_linux.efi ]] || fail "the pre-rename UKI is renamed"
[[ -e $MROOT/etc/skel/.config/unbloarchy/branding/about.txt ]] || fail "the new-user skeleton moves"
pass "system drop-ins, PAM, the units, the UKI, and the new-user skeleton all move"

[[ -d $MROOT/usr/share/unbloarchy/bin ]] || fail "the install root moves to its new path"
[[ -L $MROOT/usr/share/omarchy ]] || fail "pre-rename software keeps resolving the old root"
[[ $(readlink "$MROOT/usr/share/omarchy") == "$MROOT/usr/share/unbloarchy" ]] ||
  fail "the compatibility link points at the new root"
[[ -e $MROOT/usr/share/fonts/unbloarchy/unbloarchy.ttf ]] || fail "the packaged icon font moves to its new path"
[[ -L $MROOT/usr/bin/omarchy ]] || fail "the bare router name the package glob misses is provided"
[[ $(readlink "$MROOT/usr/bin/omarchy") == "$MROOT/usr/bin/unbloarchy" ]] ||
  fail "the bare router link points at the fork's router"
pass "the install root moves and both compatibility links resolve"

[[ -e $MROOT/var/lib/unbloarchy/provisioning/groups ]] || fail "machine state moves to its new path"
[[ ! -e $MROOT/var/lib/omarchy ]] || fail "the pre-rename machine state is left behind"
[[ -e $MROOT/var/log/unbloarchy-install.log ]] || fail "the install log is renamed"
pass "machine-wide state and the install log move"

seed_install
run_migration
run_migration
[[ -d $MROOT/usr/share/unbloarchy/themes ]] || fail "a second run keeps the install root intact"
[[ -L $MROOT/usr/share/omarchy ]] || fail "a second run keeps the compatibility link"
[[ -e $MROOT/usr/share/fonts/unbloarchy/unbloarchy.ttf ]] || fail "a second run keeps the packaged font"
[[ -e $MROOT/usr/lib/systemd/user/unbloarchy-crash-watch.service ]] ||
  fail "a second run keeps the renamed units intact"
shell_json_matches_packaged "$MHOME/.config/unbloarchy/shell.json" ||
  fail "a second run does not rewrite the bar layout again"
pass "re-running the migration is a no-op"

# A symlinked legacy directory points into a pre-rename checkout. Following it
# with mv would strip the checkout bare, and dropping the link would lose the
# user's own layout, so the contents have to be copied across and the checkout
# left whole.
seed_install
rm -rf "$MHOME/.config/omarchy" "$test_dir/checkout/config"
ln -s "$test_dir/checkout/config/omarchy" "$MHOME/.config/omarchy"
mkdir -p "$test_dir/checkout/config/omarchy"
sed 's/"unbloarchy\./"omarchy./g' "$packaged_shell_json" \
  >"$test_dir/checkout/config/omarchy/shell.json"
printf 'from a checkout\n' >"$test_dir/checkout/config/omarchy/user-file"
run_migration
[[ ! -L $MHOME/.config/omarchy ]] || fail "a symlinked pre-rename config directory survives"
[[ -e $MHOME/.config/unbloarchy/shell.json ]] ||
  fail "the layout held in the symlinked directory is lost"
[[ -e $MHOME/.config/unbloarchy/user-file ]] ||
  fail "the user's own files are lost out of a symlinked directory"
[[ -e $test_dir/checkout/config/omarchy/shell.json ]] || fail "the checkout is stripped bare"
[[ -e $test_dir/checkout/config/omarchy/user-file ]] || fail "the checkout's files are moved away"
shell_json_matches_packaged "$MHOME/.config/unbloarchy/shell.json" ||
  fail "the layout copied out of the symlink is not rewritten to the new namespace"
pass "a symlinked pre-rename tree is copied across, rewritten, and the checkout left whole"

seed_install
mkdir -p "$MROOT/etc/sudoers.d"
printf 'newer\n' >"$MROOT/etc/sudoers.d/unbloarchy-dns"
printf 'stale\n' >"$MROOT/etc/sudoers.d/omarchy-dns"
run_migration
grep -qx 'newer' "$MROOT/etc/sudoers.d/unbloarchy-dns" ||
  fail "an already-installed drop-in loses to the stale pre-rename copy"
[[ ! -e $MROOT/etc/sudoers.d/omarchy-dns ]] || fail "the stale duplicate is left in place"
pass "the already-installed drop-in wins and the stale duplicate is dropped"

# /usr/share/omarchy is an install root by virtue of holding bin/. A directory
# that happens to share the name but is not one is indistinguishable from a
# directory of the user's own, so it has to survive, and losing the compat link
# over it must not stop the rest of the migration.
seed_install
rm -rf "$MROOT/usr/share/omarchy"
mkdir -p "$MROOT/usr/share/unbloarchy/bin" "$MROOT/usr/share/omarchy/etc"
printf 'not an install root\n' >"$MROOT/usr/share/omarchy/etc/settings.conf"
run_migration
[[ -e $MROOT/usr/share/omarchy/etc/settings.conf ]] ||
  fail "a directory that is not an install root is deleted"
[[ ! -L $MROOT/usr/share/omarchy ]] || fail "an unrelated directory is replaced by a link"
grep -q 'holds no bin/' "$test_dir/output" ||
  fail "the skipped link is reported rather than done silently"
[[ -L $MROOT/usr/bin/omarchy ]] || fail "the migration stops at the skipped link"
pass "a directory that is not an install root survives, is reported, and does not stop the rest"