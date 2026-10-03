#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/base-test.sh"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

home="$tmpdir/home"
unbloarchy_path="$tmpdir/unbloarchy"

mkdir -p "$home/.config/hypr" "$unbloarchy_path/config/hypr"

cat >"$unbloarchy_path/config/hypr/bindings.lua" <<'EOF'
-- refreshed from UNBLOARCHY_PATH
EOF

cat >"$home/.config/hypr/bindings.lua" <<'EOF'
-- existing user config
EOF

HOME="$home" UNBLOARCHY_PATH="$unbloarchy_path" "$ROOT/bin/unbloarchy-refresh-config" hypr/bindings.lua >/dev/null

cmp -s "$unbloarchy_path/config/hypr/bindings.lua" "$home/.config/hypr/bindings.lua" ||
  fail "refresh-config copies from UNBLOARCHY_PATH/config"

backup=$(find "$home/.config/hypr" -name 'bindings.lua.bak.*' -print -quit)
[[ -n $backup ]] || fail "refresh-config backs up replaced user config"
grep -Fq -- '-- existing user config' "$backup" ||
  fail "refresh-config backup contains previous user config"

pass "refresh-config copies from UNBLOARCHY_PATH/config and backs up existing files"

if HOME="$home" UNBLOARCHY_PATH="$unbloarchy_path" "$ROOT/bin/unbloarchy-refresh-config" hypr/missing.lua >"$tmpdir/out" 2>"$tmpdir/err"; then
  fail "refresh-config rejects configs missing from UNBLOARCHY_PATH/config"
fi

grep -Fq 'Not a shipped user config: hypr/missing.lua' "$tmpdir/err" ||
  fail "refresh-config reports missing shipped config"

pass "refresh-config validates against UNBLOARCHY_PATH/config"
