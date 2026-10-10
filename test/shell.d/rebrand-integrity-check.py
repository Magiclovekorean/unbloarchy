#!/usr/bin/env python3
"""Gate that an upstream sync did not leave rebrand gaps.

The rebrand sweep rewrites only content lines: it never renames files and it
never touches lines the merge left unchanged. An upstream sync can therefore
quietly land two classes of damage that this checker catches:

  1. merge-new tracked files whose PATH still says `omarchy` (the sweep does
     not rename them), and
  2. content lines that reference an `omarchy` path or asset whose
     `unbloarchy`-named replacement now exists in the tree, leaving the
     reference dangling.

Rules, mirroring ../transform.py and the resolve command:

  - Paths: a tracked path may keep the `omarchy` spelling only if it is a
    generated `bin/omarchy` shim or a deliberate compat artifact (COMPAT
    below). Any other `omarchy`-named tracked file is a rebrand gap.
  - Tokens: a token containing `omarchy` is flagged iff swapping that spelling
    for `unbloarchy` would name something already present in the tree. That is
    the signature of a reference to a file the fork renamed or moved: the
    `omarchy` spelling now points at nothing, the `unbloarchy` spelling is the
    real artifact. Package and namespace names the fork keeps intact
    (`omarchy-keyring`, `/usr/share/omarchy`, the `[omarchy]` pacman repo,
    ...) have no `unbloarchy` twin in the tree and are never flagged, so no
    explicit keep list is needed.

The COMPAT list is a deliberate snapshot: a future sync that legitimately
needs a new omarchy-named artifact must extend it consciously, alongside the
git mv decision.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def git(*args):
    return subprocess.run(["git", "-C", ROOT, *args],
                          capture_output=True, text=True, check=True).stdout


TRACKED = git("ls-files").splitlines()

COMPAT_PATHS = (
    "default/sddm/omarchy/",
    "default/fonts/omarchy/",
    "default/systemd/user/omarchy-crash-watch.service",
    "default/systemd/user/omarchy-fcitx5.service",
    "default/systemd/user/omarchy-migrate-notify.service",
    "default/systemd/user/omarchy-recover-internal-monitor.service",
    "default/systemd/user/omarchy-sleep-lock.service",
    "default/systemd/user/omarchy-tailscale-receive.service",
    "default/systemd/system/plocate-updatedb.service.d/10-omarchy.conf",
    "default/systemd/zram-generator.conf.d/90-omarchy.conf",
    "default/libalpm/hooks/00-omarchy-update-guard.hook",
    "default/libalpm/hooks/10-omarchy-hyprland-reload-pause.hook",
    "default/libalpm/hooks/90-omarchy-hyprland-reload-resume.hook",
    "default/environment.d/10-omarchy-fcitx.conf",
    "default/uwsm/env.d/10-omarchy",
    "default/wayland-sessions/omarchy.desktop",
    "default/fontconfig/conf.avail/50-omarchy.conf",
    "test/shell.d/fixtures/legacy-icon-font/omarchy.ttf",
)

# Content that deliberately references the OLD omarchy names (pre-rename
# migration machinery, legacy fixtures, planning docs) and must not be
# scanned. These name the past on purpose, so a dangling-looking reference is
# correct here.
CONTENT_EXEMPT = (
    "test/shell.d/rename-migration-test.sh",
    # This checker necessarily describes the legacy tokens it detects.
    "test/shell.d/rebrand-integrity-check.py",
    # Migrates a legacy Omarchy install onto the Unbloarchy layout; its
    # manifest lists the pre-rename config paths and unit names it rewrites.
    "bin/unbloarchy-upgrade-to-quattro",
    # Documents the pre-rename omarchy_* aliases the vendored ISO copy calls.
    "install/provisioning/setup-form.sh",
)
CONTENT_EXEMPT_PREFIX = ("test/shell.d/fixtures/", "test/shell.d/legacy-icon-font/",
                         "plans/",
                         # Every migration moves an Omarchy-era install onto the
                         # Unbloarchy paths, so each one names the old identifiers.
                         "migrations/")

# Tracked paths, lowercased, as a corpus to test what a spelling names.
CORPUS = "\n".join(p.lower() for p in TRACKED)

_TOK = re.compile(r"[A-Za-z0-9_.~/$@:{}()\-]*omarchy[A-Za-z0-9_.~/$@:{}()\-]*", re.I)
_BARE = {"omarchy", "omarchy.", "omarchy-", "omarchy)"}


def compat_path(path):
    return path.startswith("bin/omarchy") or any(
        path.startswith(c) if c.endswith("/") else path == c
        for c in COMPAT_PATHS)


def exempt_content(path):
    return (path.startswith("bin/omarchy")
            or path in CONTENT_EXEMPT
            or any(path.startswith(p) for p in CONTENT_EXEMPT_PREFIX))


def is_text(path):
    try:
        with open(os.path.join(ROOT, path), "rb") as f:
            return b"\x00" not in f.read(8192)
    except OSError:
        return False


def swapped(token):
    return re.sub(r"omarchy", "unbloarchy", token, flags=re.I).lower()


def main():
    failures = []
    for path in TRACKED:
        if "omarchy" not in path.lower():
            continue
        if not compat_path(path):
            failures.append(f"file  {path}")
    for path in TRACKED:
        if not exempt_content(path) and is_text(path):
            with open(os.path.join(ROOT, path), "r",
                      encoding="utf-8", errors="replace") as f:
                for n, line in enumerate(f, 1):
                    for t in _TOK.findall(line):
                        key = t.lower()
                        if key in _BARE:
                            continue
                        # Protected when the token's own omarchy spelling still
                        # names a tracked artifact (compat pair, shim, kept
                        # namespace). Flagged only when the omarchy spelling
                        # names nothing while its unbloarchy twin does: a
                        # reference to a file the fork renamed/moved.
                        if key not in CORPUS and swapped(t) in CORPUS:
                            failures.append(
                                f"token {path}:{n}: {t.strip()[:72]}")
    if failures:
        print("not ok - rebrand-integrity-check")
        for f in failures:
            print(f"  {f}")
        print("(a merge-new omarchy path needs git mv; a token names an "
              "artifact whose unbloarchy twin exists, so it dangles)")
        sys.exit(1)
    print("ok - rebrand-integrity-check")


if __name__ == "__main__":
    main()