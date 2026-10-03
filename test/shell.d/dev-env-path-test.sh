#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/base-test.sh"

run_bootstrap() {
  local shell_bin="$1"
  local bootstrap="$2"
  local home="$3"
  local path_value="$4"

  shell_bin=$(command -v "$shell_bin")
  env -u UNBLOARCHY_PATH -u OMARCHY_PATH HOME="$home" PATH="$path_value" "$shell_bin" -c '
    . "$1"
    printf "%s\n%s\n" "$UNBLOARCHY_PATH" "$PATH"
  ' sh "$bootstrap"
}

assert_path_first() {
  local path_value="$1"
  local entry="$2"
  local description="$3"

  [[ ${path_value%%:*} == "$entry" ]] || fail "$description" "expected first PATH entry: $entry\nactual PATH: $path_value"
  pass "$description"
}

assert_path_present() {
  local path_value="$1"
  local entry="$2"
  local description="$3"

  case ":$path_value:" in
    *":$entry:"*) pass "$description" ;;
    *) fail "$description" "PATH does not contain $entry in $path_value" ;;
  esac
}

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

home="$tmpdir/home"
mkdir -p "$tmpdir/active/bin" "$tmpdir/unrelated/bin"

# Test against a copy so the test controls /etc/unbloarchy.conf without mutating the host.
bootstrap="$tmpdir/env-bootstrap"
sed \
  -e "s#/etc/unbloarchy.conf#$tmpdir/unbloarchy.conf#g" \
  -e "s#/etc/omarchy.conf#$tmpdir/omarchy.conf#g" \
  "$ROOT/default/bash/env-bootstrap" >"$bootstrap"

printf 'export UNBLOARCHY_PATH="/usr/share/unbloarchy"\n' >"$tmpdir/unbloarchy.conf"
mapfile -t default_result < <(run_bootstrap bash "$bootstrap" "$home" "$tmpdir/unrelated/bin:/usr/bin")
default_path=${default_result[1]}

[[ ${default_result[0]} == /usr/share/unbloarchy ]] || fail "env-bootstrap resolves default UNBLOARCHY_PATH" "actual: ${default_result[0]}"
pass "env-bootstrap resolves default UNBLOARCHY_PATH"
assert_path_present "$default_path" "$tmpdir/unrelated/bin" "env-bootstrap preserves PATH entries in default mode"
assert_path_present "$default_path" "$home/.local/share/mise/shims" "env-bootstrap appends mise shims"
assert_path_present "$default_path" "$home/.local/bin" "env-bootstrap appends ~/.local/bin"
assert_path_first "$default_path" "$tmpdir/unrelated/bin" "env-bootstrap appends user-level paths after existing entries"

printf 'export UNBLOARCHY_PATH="%s"\n' "$tmpdir/active" >"$tmpdir/unbloarchy.conf"
mapfile -t linked_result < <(run_bootstrap bash "$bootstrap" "$home" "$tmpdir/unrelated/bin:/usr/bin")
linked_path=${linked_result[1]}

[[ ${linked_result[0]} == "$tmpdir/active" ]] || fail "env-bootstrap resolves linked UNBLOARCHY_PATH" "actual: ${linked_result[0]}"
pass "env-bootstrap resolves linked UNBLOARCHY_PATH"
assert_path_first "$linked_path" "$tmpdir/active/bin" "env-bootstrap prepends active checkout bin in linked mode"
assert_path_present "$linked_path" "$tmpdir/unrelated/bin" "env-bootstrap preserves unrelated PATH entries in linked mode"

mapfile -t linked_duplicate_result < <(run_bootstrap bash "$bootstrap" "$home" "$tmpdir/active/bin:/usr/bin:$home/.local/share/mise/shims:$home/.local/bin")
linked_duplicate_path=${linked_duplicate_result[1]}
[[ $linked_duplicate_path == "$tmpdir/active/bin:/usr/bin:$home/.local/share/mise/shims:$home/.local/bin" ]] || fail "env-bootstrap does not duplicate PATH entries" "actual PATH: $linked_duplicate_path"
pass "env-bootstrap does not duplicate PATH entries"

# An empty PATH must not produce empty entries (a bare ":" means the cwd)
mapfile -t empty_path_result < <(run_bootstrap bash "$bootstrap" "$home" "")
empty_path=${empty_path_result[1]}
[[ $empty_path == "$tmpdir/active/bin:$home/.local/share/mise/shims:$home/.local/bin" ]] || fail "env-bootstrap builds a clean PATH from an empty one" "actual PATH: $empty_path"
pass "env-bootstrap builds a clean PATH from an empty one"

if command -v zsh >/dev/null 2>&1; then
  mapfile -t zsh_result < <(run_bootstrap zsh "$bootstrap" "$home" "$tmpdir/unrelated/bin:/usr/bin")
  zsh_path=${zsh_result[1]}
  assert_path_first "$zsh_path" "$tmpdir/active/bin" "env-bootstrap works when sourced by zsh"
  assert_path_present "$zsh_path" "$tmpdir/unrelated/bin" "env-bootstrap zsh mode preserves unrelated PATH entries"
fi

legacy_bootstrap="$tmpdir/legacy-env-bootstrap"
legacy_root="$tmpdir/legacy-packaged"
mkdir -p "$legacy_root/default"
sed \
  -e "s#/etc/unbloarchy.conf#$tmpdir/legacy-unbloarchy.conf#g" \
  -e "s#/etc/omarchy.conf#$tmpdir/omarchy.conf#g" \
  -e "s#/usr/share/unbloarchy#$tmpdir/new-packaged#g" \
  -e "s#/usr/share/omarchy#$legacy_root#g" \
  "$ROOT/default/bash/env-bootstrap" >"$legacy_bootstrap"
printf 'export OMARCHY_PATH="%s"\n' "$legacy_root" >"$tmpdir/omarchy.conf"
mapfile -t legacy_result < <(run_bootstrap bash "$legacy_bootstrap" "$home" "/usr/bin")
[[ ${legacy_result[0]} == "$legacy_root" ]] ||
  fail "env-bootstrap resolves the upstream package root from the legacy dev-link config" \
    "actual: ${legacy_result[0]}"
pass "env-bootstrap preserves the upstream package root during a no-fork transition"
