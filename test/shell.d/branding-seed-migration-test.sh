#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# migrations/1791729111.sh fills in the branding files the screensaver and About
# read when a fresh install's pre-seeded migration markers kept the rename
# migration from moving them. It only ever creates a missing file.

migration="$ROOT/migrations/1791729111.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

# The packaged sources the migration falls back to.
source_root="$test_dir/root"
mkdir -p "$source_root"
cp "$ROOT/logo.txt" "$source_root/logo.txt"
cp "$ROOT/icon.txt" "$source_root/icon.txt"

run_migration() {
  HOME="$MHOME" UNBLOARCHY_PATH="$source_root" bash -euo pipefail "$migration"
}

# A user's pre-rename art is the one thing that must survive: prefer it over the
# shipped default.
MHOME="$test_dir/legacy"
mkdir -p "$MHOME/.config/omarchy/branding"
printf 'OLD SCREEN\n' >"$MHOME/.config/omarchy/branding/screensaver.txt"
printf 'OLD ABOUT\n' >"$MHOME/.config/omarchy/branding/about.txt"
run_migration
[[ $(<"$MHOME/.config/unbloarchy/branding/screensaver.txt") == "OLD SCREEN" ]] ||
  fail "the screensaver branding keeps the user's pre-rename art" "$(cat "$MHOME/.config/unbloarchy/branding/screensaver.txt")"
[[ $(<"$MHOME/.config/unbloarchy/branding/about.txt") == "OLD ABOUT" ]] ||
  fail "the About branding keeps the user's pre-rename art" "$(cat "$MHOME/.config/unbloarchy/branding/about.txt")"
pass "the migration preserves pre-rename branding"

# Nothing pre-rename, nothing user-made: seed from the packaged defaults.
MHOME="$test_dir/fresh"
run_migration
cmp -s "$source_root/logo.txt" "$MHOME/.config/unbloarchy/branding/screensaver.txt" ||
  fail "the screensaver branding seeds from the shipped wordmark"
cmp -s "$source_root/icon.txt" "$MHOME/.config/unbloarchy/branding/about.txt" ||
  fail "the About branding seeds from the shipped icon"
pass "the migration seeds missing branding from the packaged defaults"

# An existing file is never clobbered, even when a stale legacy tree is present.
printf 'MINE\n' >"$MHOME/.config/unbloarchy/branding/screensaver.txt"
run_migration
[[ $(<"$MHOME/.config/unbloarchy/branding/screensaver.txt") == "MINE" ]] ||
  fail "the migration leaves an existing screensaver branding file alone" "$(cat "$MHOME/.config/unbloarchy/branding/screensaver.txt")"
pass "the migration leaves existing branding alone"
