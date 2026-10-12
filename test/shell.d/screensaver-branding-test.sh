#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# unbloarchy-screensaver runs a terminal-sized ttfx in a loop, so it needs a tty
# and a Hyprland that answers. Stand in for both, and for ttfx itself, so what
# is tested here is only the input the screensaver chose and whether it stopped
# instead of restarting into a failure.

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/bin" "$tmp_dir/home/.config/unbloarchy/branding" "$tmp_dir/root"
cp "$ROOT/logo.txt" "$tmp_dir/root/logo.txt"

cat >"$tmp_dir/bin/tty" <<'SH'
#!/bin/bash
echo /dev/pts/99
SH
# Anything but the terminal's initial 80x24, so wait_for_terminal_resize returns
# instead of spinning out its two-second deadline.
cat >"$tmp_dir/bin/stty" <<'SH'
#!/bin/bash
echo "40 100"
SH
cat >"$tmp_dir/bin/hyprctl" <<'SH'
#!/bin/bash
exit 0
SH
cat >"$tmp_dir/bin/pkill" <<'SH'
#!/bin/bash
exit 0
SH
# Report no ttfx running: the inner wait loop is skipped and the relaunch guard
# is what decides whether the screensaver loops.
cat >"$tmp_dir/bin/pgrep" <<'SH'
#!/bin/bash
exit 1
SH
cat >"$tmp_dir/bin/ttfx" <<'SH'
#!/bin/bash
printf '%s\n' "$2" >>"$TEST_DIR/ttfx_args"
exit 0
SH
chmod +x "$tmp_dir/bin/"*

run_screensaver() {
  : >"$tmp_dir/ttfx_args"
  set +e
  PATH="$tmp_dir/bin:$PATH" HOME="$tmp_dir/home" UNBLOARCHY_PATH="$tmp_dir/root" \
    TEST_DIR="$tmp_dir" timeout 5 "$ROOT/bin/unbloarchy-screensaver" >/dev/null 2>&1
  status=$?
  set -e
}

user_branding="$tmp_dir/home/.config/unbloarchy/branding/screensaver.txt"

# No user art yet: the shipped wordmark is what gets drawn.
rm -f "$user_branding"
run_screensaver
(( status != 124 )) || fail "the screensaver exits instead of looping when ttfx never stays up" "$status"
[[ $(wc -l <"$tmp_dir/ttfx_args") -eq 1 ]] ||
  fail "ttfx is launched once, not restarted into the same failure" "$(cat "$tmp_dir/ttfx_args")"
[[ $(<"$tmp_dir/ttfx_args") == "$tmp_dir/root/logo.txt" ]] ||
  fail "the screensaver falls back to the shipped wordmark" "$(cat "$tmp_dir/ttfx_args")"
pass "the screensaver falls back to the shipped wordmark"

# Once the user has branded it, their own file wins over the shipped default.
printf 'CUSTOM\n' >"$user_branding"
run_screensaver
(( status != 124 )) || fail "the screensaver exits with a user branding file" "$status"
[[ $(<"$tmp_dir/ttfx_args") == "$user_branding" ]] ||
  fail "the screensaver draws the user's own branding" "$(cat "$tmp_dir/ttfx_args")"
pass "the screensaver draws the user's own branding"

# Neither file: leave rather than open a black window that never animates.
rm -f "$user_branding" "$tmp_dir/root/logo.txt"
run_screensaver
(( status != 124 )) || fail "the screensaver exits when nothing can be drawn" "$status"
[[ ! -s $tmp_dir/ttfx_args ]] ||
  fail "the screensaver does not run ttfx without an input file" "$(cat "$tmp_dir/ttfx_args")"
pass "the screensaver exits cleanly when no branding exists"
