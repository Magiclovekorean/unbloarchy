#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT
repo="$test_tmp/repo"
bin="$repo/bin"
mkdir -p "$bin"

cat >"$bin/unbloarchy" <<'ROUTER'
#!/bin/bash
printf 'router:%s\n' "$*"
ROUTER
cat >"$bin/unbloarchy-test-tool" <<'COMMAND'
#!/bin/bash
printf 'command:%s\n' "$*"
COMMAND
cat >"$bin/unbloarchy-security-functions" <<'LIBRARY'
#!/bin/bash
compat_test_function() { printf 'sourced:%s\n' "$1"; }
LIBRARY
cat >"$bin/unbloarchy-dev-font" <<'PYTHON'
#!/usr/bin/python3
import sys
print('python:' + '|'.join(sys.argv[1:]))
PYTHON
chmod +x "$bin"/unbloarchy "$bin"/unbloarchy-test-tool "$bin"/unbloarchy-security-functions "$bin"/unbloarchy-dev-font

generator="$ROOT/install/helpers/generate-compat-shims.sh"
bash "$generator" "$repo"

[[ -x $bin/omarchy ]] || fail "generator creates an executable router compatibility command"
[[ $($bin/omarchy theme set example) == "router:theme set example" ]] || fail "router shim forwards arguments"
[[ $($bin/omarchy-test-tool 'two words' --flag) == "command:two words --flag" ]] || fail "command shim preserves argument boundaries"

source "$bin/omarchy-security-functions"
[[ $(compat_test_function ok) == "sourced:ok" ]] || fail "security compatibility shim sources the renamed library"
[[ $(python3 "$bin/omarchy-dev-font" list) == "python:list" ]] || fail "Python compatibility shim invokes the renamed tool"
pass "generated shims dispatch shell, library, and Python entrypoints"

cp "$bin/omarchy-test-tool" "$test_tmp/first-generation"
bash "$generator" "$repo"
cmp -s "$test_tmp/first-generation" "$bin/omarchy-test-tool" || fail "regeneration is idempotent"
pass "regeneration leaves identical compatibility shims"

cat >"$bin/unbloarchy-new-tool" <<'COMMAND'
#!/bin/bash
exit 0
COMMAND
chmod +x "$bin/unbloarchy-new-tool"
bash "$generator" "$repo"
[[ -x $bin/omarchy-new-tool ]] || fail "generator creates shims for newly added commands"
rm "$bin/unbloarchy-new-tool"
bash "$generator" "$repo"
[[ ! -e $bin/omarchy-new-tool ]] || fail "generator removes stale shims it owns"
pass "new commands are shimmed and stale generated shims are removed"

cat >"$bin/unbloarchy-manual-tool" <<'COMMAND'
#!/bin/bash
exit 0
COMMAND
chmod +x "$bin/unbloarchy-manual-tool"
printf '#!/bin/bash\necho user file\n' >"$bin/omarchy-manual-tool"
chmod +x "$bin/omarchy-manual-tool"
if bash "$generator" "$repo" >"$test_tmp/conflict.out" 2>&1; then
  fail "generator refuses to overwrite an unmanaged compatibility path"
fi
[[ $(<"$bin/omarchy-manual-tool") == $'#!/bin/bash\necho user file' ]] || fail "unmanaged compatibility file remains unchanged"
pass "unmanaged compatibility paths are never overwritten"
