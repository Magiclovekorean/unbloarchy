#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

bindings="$ROOT/default/hypr/bindings/applications.lua"
manual="$ROOT/manual/25-web-apps.md"

if grep -Eiq 'hey\.com|basecamp\.com|messages\.google\.com|photos\.google\.com|maps\.google\.com|x\.com' "$bindings"; then
  fail "selected commercial web apps have no default keyboard bindings"
fi
pass "selected commercial web apps have no default keyboard bindings"

if grep -Eq '^## (HEY|Basecamp|Google apps|X)$' "$manual"; then
  fail "the manual does not list the selected apps as shipped defaults"
fi
pass "the manual does not list the selected apps as shipped defaults"

for url in 'https://chatgpt.com' 'https://grok.com' 'https://youtube.com/' 'https://web.whatsapp.com/'; do
  grep -Fq "$url" "$bindings" || fail "unrelated default web app binding is preserved" "$url"
done
pass "unrelated default web app bindings are preserved"
