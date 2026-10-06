#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/fixtures/sudo-boundary-test.sh"
source "$SUDO_TEST_ROOT/bin/unbloarchy-security-functions"

rm -f "$SUDO_TEST_ROOT/bin/unbloarchy-update"
copy_boundary_file bin/unbloarchy-update
unbloarchy_security_require_source_root "$SUDO_TEST_ROOT/bin/unbloarchy-update" || fail "matching checkout root was rejected"
pass "a canonical checkout matches its own entrypoint"

mkdir "$boundary_tmp/other-root"
ln -s "$SUDO_TEST_ROOT" "$boundary_tmp/root-link"
for root in "$boundary_tmp/other-root" "$boundary_tmp/root-link" .; do
  if UNBLOARCHY_PATH="$root" unbloarchy_security_require_source_root "$SUDO_TEST_ROOT/bin/unbloarchy-update" >"$boundary_tmp/output" 2>&1; then
    fail "a different or noncanonical source root was accepted"
  fi
done
pass "different, symlink and relative roots are rejected"

# Redirect the two package-layout literals into the fixture. Resolution still
# uses real readlink/realpath; no host /usr/bin file is changed or run. The
# fixture mirrors the real layout: the upstream package owns the tree at
# /usr/share/omarchy, and compat-links.sh exposes the renamed runtime root as
# a symlink /usr/share/unbloarchy -> /usr/share/omarchy.
package_tree="$boundary_tmp/usr/share/omarchy"
package_root="$boundary_tmp/usr/share/unbloarchy"
package_bin="$boundary_tmp/usr/bin"
mkdir -p "$boundary_tmp/usr/share" "$package_tree/bin" "$package_bin"
cp "$SUDO_TEST_ROOT/bin/unbloarchy-update" "$package_bin/unbloarchy-update"
cp "$SUDO_TEST_ROOT/bin/unbloarchy-update" "$package_bin/different-command"
ln -s "$package_bin/unbloarchy-update" "$package_tree/bin/unbloarchy-update"
ln -s "$package_tree" "$package_root"
python3 - "$SUDO_TEST_ROOT/bin/unbloarchy-security-functions" "$boundary_tmp/package-library" "$package_root" "$package_tree" "$package_bin" <<'PY'
import sys
from pathlib import Path
source, output, root, tree, binaries = sys.argv[1:]
text = Path(source).read_text()
text = text.replace('"/usr/share/unbloarchy"', f'"{root}"')
text = text.replace('"/usr/share/omarchy"', f'"{tree}"')
text = text.replace('"/usr/bin/$command_name"', f'"{binaries}/$command_name"')
Path(output).write_text(text)
PY
source "$boundary_tmp/package-library"
UNBLOARCHY_PATH="$package_root" unbloarchy_security_require_source_root "$package_bin/unbloarchy-update" || fail "package binary was rejected"
UNBLOARCHY_PATH="$package_root" unbloarchy_security_require_source_root "$package_root/bin/unbloarchy-update" || fail "package link was rejected"
UNBLOARCHY_PATH="$package_tree" unbloarchy_security_require_source_root "$package_bin/unbloarchy-update" || fail "package-owned tree root was rejected"
pass "the package binary and its matching source-tree link are accepted under either runtime root"

ln -sfn "$package_bin/different-command" "$package_tree/bin/unbloarchy-update"
if UNBLOARCHY_PATH="$package_root" unbloarchy_security_require_source_root "$package_root/bin/unbloarchy-update" >"$boundary_tmp/output" 2>&1; then
  fail "a package link to a different command was accepted"
fi
pass "a package link must resolve to its named command"

# A renamed runtime root pointed somewhere other than the package-owned tree
# must be rejected even though the literal is a packaged root.
ln -sfn "$boundary_tmp/other-root" "$package_root"
if UNBLOARCHY_PATH="$package_root" unbloarchy_security_require_source_root "$package_bin/unbloarchy-update" >"$boundary_tmp/output" 2>&1; then
  fail "a redirected package root was accepted"
fi
pass "a package root redirected off the packaged tree is rejected"
ln -sfn "$package_tree" "$package_root"

# Run the protected entrypoints themselves with a mismatched root. These must
# stop before any sudo or operational fixture command, not merely validate in
# an isolated library test.
for command in unbloarchy-update unbloarchy-refresh-pacman unbloarchy-update-stay-awake unbloarchy-channel-set; do
  rm -f "$SUDO_TEST_ROOT/bin/$command"
  copy_boundary_file "bin/$command"
  for root in "$boundary_tmp/other-root" .; do
    reset_boundary
    if UNBLOARCHY_PATH="$root" "$SUDO_TEST_ROOT/bin/$command" >"$boundary_tmp/output" 2>&1; then
      fail "$command accepted a mismatched root"
    fi
    [[ ! -s $SUDO_TEST_LOG ]] || fail "$command ran work before rejecting its root"
  done
  pass "$command rejects mismatched and relative roots before work"
done
