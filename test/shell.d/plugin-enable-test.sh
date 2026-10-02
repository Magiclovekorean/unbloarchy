#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
mkdir -p "$TMPDIR/home" "$TMPDIR/bin"
calls="$TMPDIR/calls"

cat >"$TMPDIR/bin/unbloarchy-shell" <<'SH'
#!/bin/bash
printf '%s\n' "$*" >>"$UNBLOARCHY_TEST_CALLS"
printf 'ok\n'
SH
chmod +x "$TMPDIR/bin/unbloarchy-shell"

run_enable() {
  HOME="$TMPDIR/home" \
    UNBLOARCHY_PATH="$ROOT" \
    UNBLOARCHY_TEST_CALLS="$calls" \
    PATH="$TMPDIR/bin:$ROOT/bin:$PATH" \
    unbloarchy-plugin-enable "$@"
}

run_enable unbloarchy.active-window --section right >/dev/null
grep -Fqx 'shell enablePlugin unbloarchy.active-window {"section":"right"}' "$calls" ||
  fail "plugin enable did not combine activation and placement"
pass "plugin enable combines activation and placement in one shell mutation"

run_enable unbloarchy.clock --before unbloarchy.weather >/dev/null
grep -Fqx 'shell enablePlugin unbloarchy.clock {"before":"unbloarchy.weather"}' "$calls" ||
  fail "plugin enable did not preserve relative placement"
pass "plugin enable forwards relative placement"

run_enable unbloarchy.dropbox >/dev/null
grep -Fqx 'shell enablePlugin unbloarchy.dropbox {}' "$calls" ||
  fail "plugin enable did not use manifest-default placement"
pass "plugin enable leaves default placement to the registry"

if run_enable unbloarchy.bar --section right >/dev/null 2>&1; then
  fail "plugin enable accepted placement for a full bar"
fi
pass "plugin enable rejects placement for full bars"
