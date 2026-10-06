#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

tmp_dir=$(mktemp -d)
trap 'rm -r "$tmp_dir"' EXIT

# gum reads its scripted answers from GUM_SCRIPT, one "status:output" line per
# invocation, so a test spells out exactly what the human did at each screen:
# "0:dhh" answers, "1:" is Esc, "130:" is Ctrl+C. Only the widgets that take a
# list drain stdin, matching the real ones, so the piped layouts and timezones
# can be asserted.
cat >"$tmp_dir/gum" <<'EOF'
#!/bin/bash
count=$(($(cat "$GUM_COUNT") + 1))
printf '%s' "$count" >"$GUM_COUNT"
printf '%s\n' "$*" >>"$GUM_ARGS"

case $1 in
  choose | filter) cat >"$GUM_DIR/stdin.$count" ;;
esac

line=$(sed -n "${count}p" "$GUM_SCRIPT")
printf '%s\n' "${line#*:}"
exit "${line%%:*}"
EOF

cat >"$tmp_dir/tzupdate" <<'EOF'
#!/bin/bash
[[ -n ${TZ_GUESS:-} ]] || exit 1
printf '%s\n' "$TZ_GUESS"
EOF

cat >"$tmp_dir/timedatectl" <<'EOF'
#!/bin/bash
printf '%s\n' UTC Europe/Copenhagen America/Chicago
EOF

# Calls one prompt bare under `set -euo pipefail` — the shape that makes the
# status capture load-bearing. A cancelled prompt is a failing assignment, so a
# regression to a plain `status=$?` kills the shell before the function can
# return; both cases exit with the same status, and this marker is the only
# thing that tells them apart.
cat >"$tmp_dir/driver" <<'EOF'
#!/bin/bash

set -euo pipefail
set -T

source "$ROOT/install/provisioning/setup-form.sh"

notice() { printf '%s\n' "$1" >>"$NOTICES"; }

if [[ -n ${TAKEN_USERS:-} ]]; then
  unbloarchy_username_taken() { [[ " $TAKEN_USERS " == *" $1 "* ]]; }
fi

trap 'if [[ ${FUNCNAME[0]:-} == "$PROMPT_FN" ]]; then printf "returned\n" >>"$MARKER"; fi' RETURN

"$PROMPT_FN"

printf 'keyboard=%s\n' "${keyboard:-}"
printf 'keyboard_label=%s\n' "${keyboard_label:-}"
printf 'username=%s\n' "${username:-}"
printf 'password=%s\n' "${password:-}"
printf 'password_confirmation=%s\n' "${password_confirmation:-}"
printf 'full_name=%s\n' "${full_name:-}"
printf 'email_address=%s\n' "${email_address:-}"
printf 'hostname=%s\n' "${hostname:-}"
printf 'encrypt_installation=%s\n' "${encrypt_installation:-}"
printf 'timezone=%s\n' "${timezone:-}"
EOF

chmod +x "$tmp_dir/gum" "$tmp_dir/tzupdate" "$tmp_dir/timedatectl" "$tmp_dir/driver"
export PATH="$tmp_dir:$PATH"
export GUM_DIR="$tmp_dir" GUM_SCRIPT="$tmp_dir/script" GUM_ARGS="$tmp_dir/args" GUM_COUNT="$tmp_dir/count"
export NOTICES="$tmp_dir/notices" MARKER="$tmp_dir/marker"

status=0

# run_prompt <function> <status:output>... — each response answers one gum screen
run_prompt() {
  local prompt=$1
  shift

  printf '%s\n' "$@" >"$GUM_SCRIPT"
  printf '0' >"$GUM_COUNT"
  : >"$GUM_ARGS"
  : >"$NOTICES"
  : >"$MARKER"
  rm -f "$tmp_dir"/stdin.*

  PROMPT_FN="$prompt" "$tmp_dir/driver" >"$tmp_dir/out" 2>"$tmp_dir/err" && status=0 || status=$?
}

field() { sed -n "s/^$1=//p" "$tmp_dir/out"; }

assert_returned() {
  grep -qx returned "$MARKER" ||
    fail "$1" "$(printf 'the prompt never returned; the shell died inside it:\n%s' "$(<"$tmp_dir/err")")"
}

assert_status() {
  ((status == $1)) || fail "$2" "expected status: $1
actual status:   $status"
}

assert_notices() {
  local description=$1 expected=$2
  local actual
  actual=$(<"$NOTICES")
  [[ $actual == "$expected" ]] || fail "$description" "expected notices: $expected
actual notices:   $actual"
}

# The contract both callers read, and the ordering the shared list exists to keep
source "$ROOT/install/provisioning/setup-form.sh"

((UNBLOARCHY_FORM_BACK == 1)) || fail "Esc reports status 1"
((UNBLOARCHY_FORM_SIGNAL == 130)) || fail "Ctrl+C reports status 130"
[[ $(printf '%s\n' "$UNBLOARCHY_KEYBOARD_LAYOUTS" | head -n 1) == "English (US)|us" ]] ||
  fail "English (US) leads the keyboard layouts so gum choose opens on the default"
pass "the form publishes the 0/1/130 status contract and leads with English (US)"

# Legacy entrypoints. The ISO configurator vendors this file and calls the
# pre-rename names, so a rename that dropped them leaves the whole install
# wizard answering "command not found" on first paint.
((OMARCHY_FORM_BACK == UNBLOARCHY_FORM_BACK)) ||
  fail "the legacy Esc status mirrors the renamed one"
((OMARCHY_FORM_SIGNAL == UNBLOARCHY_FORM_SIGNAL)) ||
  fail "the legacy Ctrl+C status mirrors the renamed one"

for legacy_prompt in keyboard username password identity hostname encryption timezone; do
  declare -F "omarchy_prompt_$legacy_prompt" >/dev/null ||
    fail "the form still defines omarchy_prompt_$legacy_prompt for the ISO configurator"
done
pass "the form keeps the pre-rename prompt names the ISO configurator calls"

run_prompt omarchy_prompt_keyboard "0:German"
assert_status 0 "legacy keyboard prompt succeeds"
[[ $(field keyboard) == "de" ]] || fail "legacy keyboard prompt resolves the label to a keymap"
run_prompt omarchy_prompt_username "0:dhh"
assert_status 0 "legacy username prompt succeeds"
[[ $(field username) == "dhh" ]] || fail "legacy username prompt keeps the answer"
run_prompt omarchy_prompt_hostname "0:workshop"
assert_status 0 "legacy hostname prompt succeeds"
[[ $(field hostname) == "workshop" ]] || fail "legacy hostname prompt keeps the answer"
run_prompt omarchy_prompt_encryption "0:Install without encryption"
assert_status 0 "legacy encryption prompt succeeds"
[[ $(field encrypt_installation) == "false" ]] || fail "legacy encryption prompt keeps the answer"
run_prompt omarchy_prompt_timezone "0:America/Chicago"
assert_status 0 "legacy timezone prompt succeeds"
[[ $(field timezone) == "America/Chicago" ]] || fail "legacy timezone prompt keeps the answer"
run_prompt omarchy_prompt_password "0:s3cret" "0:s3cret"
assert_status 0 "legacy password prompt succeeds"
[[ $(field password) == "s3cret" ]] || fail "legacy password prompt keeps the answer"
run_prompt omarchy_prompt_identity "0:David" "0:d@example.com"
assert_status 0 "legacy identity prompt succeeds"
[[ $(field full_name) == "David" ]] || fail "legacy identity prompt keeps the full name"
[[ $(field email_address) == "d@example.com" ]] || fail "legacy identity prompt keeps the email address"
run_prompt omarchy_prompt_keyboard "1:"
assert_status "$OMARCHY_FORM_BACK" "legacy keyboard prompt reports Esc as back"
run_prompt omarchy_prompt_keyboard "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "legacy keyboard prompt reports Ctrl+C as the caller's signal"
pass "the legacy prompt names forward arguments, answers, and cancel statuses"

# Keyboard

run_prompt unbloarchy_prompt_keyboard "0:German"
assert_status 0 "keyboard prompt succeeds"
[[ $(field keyboard) == "de" ]] || fail "keyboard prompt resolves the label to a keymap"
[[ $(field keyboard_label) == "German" ]] || fail "keyboard prompt keeps the label for the summary"
[[ $(head -n 1 "$tmp_dir/stdin.1") == "English (US)" ]] || fail "keyboard prompt offers English (US) first"
grep -qF -- '--selected English (US)' "$GUM_ARGS" || fail "keyboard prompt preselects English (US)"
pass "keyboard prompt maps the chosen label to its keymap"

run_prompt unbloarchy_prompt_keyboard "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "keyboard prompt reports Esc as back"
assert_returned "keyboard prompt survives Esc under set -e"

run_prompt unbloarchy_prompt_keyboard "130:"
assert_status "$UNBLOARCHY_FORM_SIGNAL" "keyboard prompt reports Ctrl+C as the caller's signal"
assert_returned "keyboard prompt survives Ctrl+C under set -e"
pass "keyboard prompt propagates Esc and Ctrl+C without dying under set -e"

# Username

TAKEN_USERS=dhh run_prompt unbloarchy_prompt_username "0:Not A Username" "0:root" "0:cups-browsed" "0:dhh" "0:david"
assert_status 0 "username prompt accepts a valid name"
[[ $(field username) == "david" ]] || fail "username prompt keeps re-asking until the name is valid"
assert_notices "username prompt explains each rejection" "Username must be alphanumeric with no spaces
Username is reserved for system
Username is reserved for system
That username already exists on this machine"
pass "username prompt rejects malformed, reserved, and taken names"

run_prompt unbloarchy_prompt_username "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "username prompt reports Esc as back"
assert_returned "username prompt survives Esc under set -e"

run_prompt unbloarchy_prompt_username "130:"
assert_status "$UNBLOARCHY_FORM_SIGNAL" "username prompt reports Ctrl+C as the caller's signal"
assert_returned "username prompt survives Ctrl+C under set -e"
pass "username prompt propagates Esc and Ctrl+C without dying under set -e"

# Password

run_prompt unbloarchy_prompt_password "0:one" "0:two" "0:" "0:" "0:s3cret" "0:s3cret"
assert_status 0 "password prompt accepts a confirmed password"
[[ $(field password) == "s3cret" ]] || fail "password prompt keeps the confirmed password"
assert_notices "password prompt explains each rejection" "Passwords didn't match!
Your password can't be blank!"
pass "password prompt rejects mismatched and blank passwords"

run_prompt unbloarchy_prompt_password "0:s3cret" "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "password prompt reports Esc on the confirmation as back"
assert_returned "password confirmation survives Esc under set -e"

run_prompt unbloarchy_prompt_password "0:s3cret" "130:"
assert_status "$UNBLOARCHY_FORM_SIGNAL" "password prompt reports Ctrl+C on the confirmation as the caller's signal"
assert_returned "password confirmation survives Ctrl+C under set -e"
pass "password confirmation propagates Esc and Ctrl+C without dying under set -e"

# Identity — both fields are skippable, so empty is an answer and not a cancel

run_prompt unbloarchy_prompt_identity "0:" "0:"
assert_status 0 "identity prompt treats empty fields as answers"
[[ -z $(field full_name) && -z $(field email_address) ]] || fail "identity prompt leaves skipped fields empty"
pass "identity prompt accepts skipped fields"

run_prompt unbloarchy_prompt_identity "0:David" "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "identity prompt reports Esc on the email as back"
assert_returned "identity prompt survives Esc under set -e"
pass "identity prompt propagates Esc from its second field"

# Hostname

run_prompt unbloarchy_prompt_hostname "0:-nope-" "0:workshop"
assert_status 0 "hostname prompt accepts a valid hostname"
[[ $(field hostname) == "workshop" ]] || fail "hostname prompt keeps re-asking until the hostname is valid"
assert_notices "hostname prompt explains the rejection" "Hostname must be 1-63 letters, digits, or dashes, and cannot start or end with a dash"

run_prompt unbloarchy_prompt_hostname "0:"
assert_status 0 "hostname prompt accepts an empty hostname"
[[ $(field hostname) == "$UNBLOARCHY_HOSTNAME_DEFAULT" ]] || fail "hostname prompt falls back to the default hostname"
pass "hostname prompt rejects malformed names and defaults an empty one"

run_prompt unbloarchy_prompt_hostname "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "hostname prompt reports Esc as back"
assert_returned "hostname prompt survives Esc under set -e"
pass "hostname prompt propagates Esc without dying under set -e"

# Encryption — the default-off answer is a real choice now, not a hidden toggle

run_prompt unbloarchy_prompt_encryption "0:Encrypt disk (recommended)"
assert_status 0 "encryption prompt accepts the encrypted choice"
[[ $(field encrypt_installation) == "true" ]] ||
  fail "encryption prompt defaults to an encrypted install"
grep -qF -- '--header Disk encryption' "$GUM_ARGS" || fail "encryption prompt labels itself"
grep -qFx 'Encrypt disk (recommended)' "$tmp_dir/stdin.1" ||
  fail "encryption prompt offers the recommended encrypted option"
grep -qFx 'Install without encryption' "$tmp_dir/stdin.1" ||
  fail "encryption prompt offers an unencrypted option"
pass "encryption prompt asks for the choice instead of hiding it"

run_prompt unbloarchy_prompt_encryption "0:Install without encryption"
assert_status 0 "encryption prompt accepts the unencrypted choice"
[[ $(field encrypt_installation) == "false" ]] ||
  fail "encryption prompt honours an unencrypted install"
pass "encryption prompt records an unencrypted install"

run_prompt unbloarchy_prompt_encryption "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "encryption prompt reports Esc as back"
assert_returned "encryption prompt survives Esc under set -e"

run_prompt unbloarchy_prompt_encryption "130:"
assert_status "$UNBLOARCHY_FORM_SIGNAL" "encryption prompt reports Ctrl+C as the caller's signal"
assert_returned "encryption prompt survives Ctrl+C under set -e"
pass "encryption prompt propagates Esc and Ctrl+C without dying under set -e"

# Timezone

TZ_GUESS=Europe/Copenhagen run_prompt unbloarchy_prompt_timezone "0:Europe/Copenhagen"
assert_status 0 "timezone prompt accepts the geo guess"
[[ $(field timezone) == "Europe/Copenhagen" ]] || fail "timezone prompt keeps the chosen timezone"
grep -qF -- '--selected Europe/Copenhagen' "$GUM_ARGS" || fail "timezone prompt preselects the geo guess"
grep -qF UTC "$tmp_dir/stdin.1" || fail "timezone prompt offers the system timezone list"
pass "timezone prompt preselects the geo guess when one is available"

# An unnetworked first boot has no guess, and the fallback has to survive `set -e`
run_prompt unbloarchy_prompt_timezone "0:America/Chicago"
assert_status 0 "timezone prompt survives a failed geo guess"
[[ $(field timezone) == "America/Chicago" ]] || fail "timezone prompt keeps the filtered timezone"
[[ $(head -n 1 "$GUM_ARGS") == filter* ]] || fail "timezone prompt filters when there is no geo guess"
pass "timezone prompt falls back to filtering when the geo guess fails"

run_prompt unbloarchy_prompt_timezone "0:"
assert_status 0 "timezone prompt accepts an empty selection"
[[ $(field timezone) == "UTC" ]] || fail "timezone prompt falls back to UTC"
pass "timezone prompt falls back to UTC when nothing is selected"

run_prompt unbloarchy_prompt_timezone "1:"
assert_status "$UNBLOARCHY_FORM_BACK" "timezone prompt reports Esc as back"
assert_returned "timezone prompt survives Esc under set -e"

TZ_GUESS=Europe/Copenhagen run_prompt unbloarchy_prompt_timezone "130:"
assert_status "$UNBLOARCHY_FORM_SIGNAL" "timezone prompt reports Ctrl+C as the caller's signal"
assert_returned "timezone prompt survives Ctrl+C under set -e"
pass "timezone prompt propagates Esc and Ctrl+C without dying under set -e"
