#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

source "$SHELL_TEST_DIR/fixtures/sudo-boundary-test.sh"
test_tmp="$boundary_tmp"
package_root="$SUDO_TEST_ROOT"
copy_boundary_file bin/unbloarchy-channel-set
python3 - "$SUDO_TEST_ROOT/bin/unbloarchy-channel-set" "$package_root" <<'PYTHON'
import sys
from pathlib import Path
p = Path(sys.argv[1])
p.write_text(p.read_text().replace("/usr/share/unbloarchy", sys.argv[2]))
PYTHON

stub_bin="$SUDO_TEST_ROOT/bin"
log_file="$test_tmp/channel.log"
mkdir -p "$stub_bin" "$test_tmp/home"

write_stub() {
  local name="$1"
  local body="$2"

  rm -f "$stub_bin/$name"
  cat >"$stub_bin/$name" <<<"$body"
  chmod +x "$stub_bin/$name"
}

write_stub unbloarchy-refresh-pacman '#!/bin/bash
printf "refresh" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub sudo '#!/bin/bash
case "${1:-}" in
  -h) echo "usage: sudo [-ABbEHkNnPS] command"; exit 0 ;;
  -k|-K) exit 0 ;;
esac
printf "sudo" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

cp "$stub_bin/sudo" "$SUDO_TEST_ROOT/mock/sudo"

write_stub unbloarchy-update-pacman '#!/bin/bash
printf "update-pacman" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub unbloarchy-dev-unlink '#!/bin/bash
printf "unlink" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub unbloarchy-state '#!/bin/bash
printf "state" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub unbloarchy-update '#!/bin/bash
printf "update" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\tUNBLOARCHY_PATH=%s" "$UNBLOARCHY_PATH" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub gum '#!/bin/bash
printf "gum" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
exit 0
'

write_stub git '#!/bin/bash
printf "git" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
if [[ $1 == "clone" ]]; then
  dest="${@: -1}"
  /usr/bin/cp -a "$SUDO_TEST_ROOT" "$dest"
  mkdir -p "$dest/.git" "$dest/shell"
fi
'

write_stub unbloarchy-dev-link '#!/bin/bash
printf "link" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
for arg in "$@"; do printf "\t%s" "$arg" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"; done
printf "\n" >>"$UNBLOARCHY_CHANNEL_TEST_LOG"
'

write_stub unbloarchy-version-channel '#!/bin/bash
printf "%s\n" "${UNBLOARCHY_TEST_VERSION_CHANNEL:-unknown}"
'

write_stub pacman '#!/bin/bash
[[ $1 == "-Q" ]] || exit 1
shift
case "${UNBLOARCHY_TEST_PACKAGES:-}" in
  stable) [[ $* == "omarchy omarchy-settings" ]] ;;
  dev) [[ $* == "omarchy-dev omarchy-settings-dev" ]] ;;
  *) exit 1 ;;
esac
'

run_channel() {
  : >"$log_file"
  UNBLOARCHY_CHANNEL_TEST_LOG="$log_file" \
    UNBLOARCHY_PATH="${UNBLOARCHY_TEST_PATH:-$package_root}" \
    HOME="$test_tmp/home" \
    PATH="$stub_bin:$ROOT/bin:$PATH" \
    "${UNBLOARCHY_TEST_PATH:-$package_root}/bin/unbloarchy-channel-set" "$@"
}

assert_log_line() {
  local expected="$1"
  local description="$2"

  grep -Fx -- "$expected" "$log_file" >/dev/null || fail "$description" "$(cat "$log_file")"
  pass "$description"
}

run_channel stable
assert_log_line $'refresh\tstable' "stable refreshes the stable pacman channel"
assert_log_line $'update-pacman\t-S\t--needed\t--noconfirm\t--ask\t4\tomarchy\tomarchy-settings' "stable installs stable Unbloarchy packages"
assert_log_line $'unlink\t--no-reboot' "stable restores the package-backed Unbloarchy path without an early reboot prompt"
assert_log_line $'update\t-y\tUNBLOARCHY_PATH='"$package_root" "stable runs the normal update pipeline from the package-backed path"
if grep -q $'^state\tset\treboot-required$' "$log_file"; then
  fail "stable does not require reboot when already package-backed" "$(cat "$log_file")"
fi
pass "stable does not require reboot when already package-backed"

run_channel rc
assert_log_line $'refresh\trc' "rc refreshes the rc pacman channel"
assert_log_line $'update-pacman\t-S\t--needed\t--noconfirm\t--ask\t4\tomarchy\tomarchy-settings' "rc installs rc Unbloarchy packages"
assert_log_line $'unlink\t--no-reboot' "rc restores the package-backed Unbloarchy path without an early reboot prompt"
assert_log_line $'update\t-y\tUNBLOARCHY_PATH='"$package_root" "rc runs the normal update pipeline from the package-backed path"

active_checkout="$test_tmp/active-checkout"
cp -a "$package_root" "$active_checkout"
UNBLOARCHY_TEST_PATH="$active_checkout" run_channel edge
assert_log_line $'refresh\tedge' "edge refreshes the edge pacman channel"
assert_log_line $'update-pacman\t-S\t--needed\t--noconfirm\t--ask\t4\tomarchy-dev\tomarchy-settings-dev' "edge installs development Unbloarchy packages"
assert_log_line $'unlink\t--no-reboot' "edge unlinks dev without an early reboot prompt"
assert_log_line $'state\tset\treboot-required' "edge marks reboot required when leaving dev"
assert_log_line $'update\t-y\tUNBLOARCHY_PATH='"$package_root" "edge runs the normal update pipeline from the package-backed path"
[[ $(grep -E $'^(unlink|state|update)\t' "$log_file") == $'unlink\t--no-reboot\nstate\tset\treboot-required\nupdate\t-y\tUNBLOARCHY_PATH='"$package_root" ]] ||
  fail "edge defers the reboot prompt until the update restart stage" "$(cat "$log_file")"
pass "edge defers the reboot prompt until the update restart stage"

checkout="$test_tmp/home/unbloarchy"
mkdir -p "$checkout"
if run_channel dev >"$test_tmp/occupied.out" 2>"$test_tmp/occupied.err"; then
  fail "dev refuses to use an occupied non-checkout path"
fi

grep -q "already exists and is not a git checkout" "$test_tmp/occupied.err" || fail "dev explains occupied checkout paths" "$(cat "$test_tmp/occupied.err")"
if grep -Fx $'refresh\tedge' "$log_file" >/dev/null; then
  fail "dev validates checkout path before changing packages" "$(cat "$log_file")"
fi
pass "dev refuses occupied non-checkout paths before package changes"

rmdir "$checkout"
run_channel dev
assert_log_line $'gum\tconfirm\t--default=false\tSwitch to dev channel?' "dev asks for confirmation"
assert_log_line $'refresh\tedge' "dev refreshes the edge pacman channel"
assert_log_line $'update-pacman\t-S\t--needed\t--noconfirm\t--ask\t4\tomarchy-dev\tomarchy-settings-dev' "dev installs development Unbloarchy packages"
assert_log_line $'git\tclone\thttps://github.com/omacom/omarchy.git\t'"$checkout" "dev clones the source checkout to ~/unbloarchy"
assert_log_line $'link\t'"$checkout"$'\t--no-reboot' "dev links ~/unbloarchy without an early reboot prompt"
assert_log_line $'state\tset\treboot-required' "dev defers the reboot prompt to the update pipeline"
assert_log_line $'update\t-y\tUNBLOARCHY_PATH='"$checkout" "dev runs the normal update pipeline from the source checkout"
[[ $(grep -E '^(git|link|state|refresh|sudo|update)' "$log_file") == $'git\tclone\thttps://github.com/omacom/omarchy.git\t'"$checkout"$'\nlink\t'"$checkout"$'\t--no-reboot\nstate\tset\treboot-required\nrefresh\tedge\nupdate-pacman\t-S\t--needed\t--noconfirm\t--ask\t4\tomarchy-dev\tomarchy-settings-dev\nupdate\t-y\tUNBLOARCHY_PATH='"$checkout" ]] ||
  fail "dev activates the checkout before changing or updating packages" "$(cat "$log_file")"
pass "dev activates the checkout before changing or updating packages"

UNBLOARCHY_TEST_PATH="$checkout" run_channel stable
assert_log_line $'unlink\t--no-reboot' "switching from dev to stable unlinks without an early reboot prompt"
assert_log_line $'state\tset\treboot-required' "switching from dev to stable marks reboot required"

run_channel dev
if grep -q $'^git\tclone\t' "$log_file"; then
  fail "dev reuses an existing checkout" "$(cat "$log_file")"
fi
assert_log_line $'link\t'"$checkout"$'\t--no-reboot' "switching back to dev links ~/unbloarchy"
pass "switching back to dev reuses the existing ~/unbloarchy checkout"

current_channel() {
  UNBLOARCHY_TEST_VERSION_CHANNEL="$1" \
    UNBLOARCHY_TEST_PACKAGES="$2" \
    UNBLOARCHY_PATH="$3" \
    PATH="$stub_bin:$ROOT/bin:$PATH" \
    "$ROOT/bin/unbloarchy-channel-current"
}

[[ $(current_channel stable stable /usr/share/unbloarchy) == "stable" ]] || fail "current channel detects stable"
pass "current channel detects stable"

[[ $(current_channel rc stable /usr/share/unbloarchy) == "rc" ]] || fail "current channel detects rc"
pass "current channel detects rc"

[[ $(current_channel edge dev /usr/share/unbloarchy) == "edge" ]] || fail "current channel detects package-backed edge"
pass "current channel detects package-backed edge"

[[ $(current_channel edge dev "$test_tmp/dev-checkout") == "dev" ]] || fail "current channel detects dev from UNBLOARCHY_PATH"
pass "current channel honors a dev link outside ~/unbloarchy"
