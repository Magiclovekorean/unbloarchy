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
    ...) have no `unbloarchy` twin in the tree, so the forward rule needs no
    keep list.
  - Kept names: the upstream identifiers in KEEP_VERBATIM must never appear in
    their `unbloarchy` form. The token rule above cannot see this mistake: it
    is a `unbloarchy` token with no dangling `omarchy` twin, because a
    repository name is not a tracked path. The package mirror publishes
    `omarchy.db`, so a `[unbloarchy]` repository in a pacman.conf points at a
    database that does not exist; a sweep renamed exactly that and shipped it,
    which is why this reverse scan exists.

COMPAT_PATHS and KEEP_VERBATIM are deliberate snapshots: a future sync that
legitimately needs a new omarchy-named artifact must extend COMPAT_PATHS
consciously, alongside the git mv decision, and anything the fork newly keeps
in upstream spelling belongs in KEEP_VERBATIM.
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

COMPAT_PATHS = ("default/sddm/omarchy/",
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
    "default/libalpm/hooks/05-omarchy-passwordless-revoke.hook",
    "default/libalpm/hooks/10-omarchy-hyprland-reload-pause.hook",
    "default/libalpm/hooks/90-omarchy-hyprland-reload-resume.hook",
    "default/environment.d/10-omarchy-fcitx.conf",
    "default/uwsm/env.d/10-omarchy",
    "default/wayland-sessions/omarchy.desktop",
    "default/fontconfig/conf.avail/50-omarchy.conf",
    "test/shell.d/fixtures/legacy-icon-font/omarchy.ttf",
    "default/chromium/policies/omarchy.json",
    "default/regions/cn/pacman/omarchy-edge.prepend",
    "default/regions/cn/pacman/omarchy-rc.prepend",
    "default/regions/cn/pacman/omarchy-stable.prepend",
    "default/systemd/system/systemd-pcrlogin@.service.d/10-omarchy-nvpcr.conf",
    "default/systemd/system/systemd-pcrproduct.service.d/10-omarchy-nvpcr.conf",
    "default/systemd/system/systemd-tpm2-setup-early.service.d/10-omarchy-nvpcr.conf",
    "default/systemd/timesyncd.conf.d/10-omarchy.conf",
    "etc/NetworkManager/conf.d/omarchy-connectivity.conf",
    "etc/mkinitcpio.conf.d/omarchy_vconsole.conf",
    "etc/pipewire/client.conf.d/50-omarchy-rtkit.conf",
    "etc/pipewire/jack.conf.d/50-omarchy-rtkit.conf",
    "etc/sudoers.d/omarchy-locale-generate",
    "etc/sysctl.d/90-omarchy-arp.conf",
    "etc/systemd/system/proc-sys-fs-binfmt_misc.mount.d/10-omarchy-conditions.conf",
    "etc/xkb/symbols/omarchy",
    "test/shell.d/omarchy-kernel-test.sh",)

# Third-party Apple Silicon runtime package from omacom/omarchy-mac-pkgs.
# The fork uses unbloarchy-mac-boot for its own boot package, but does not
# publish or rename this external runtime package.
COMPAT_TOKENS = (
    "omarchy-mac",
)

# Upstream identifiers the fork keeps in the original spelling. The sweep must
# never emit their unbloarchy forms: the mirror publishes `omarchy.db` and only
# pkgs.omarchy.org / logs.omarchy.org resolve, so a renamed repository or host
# names something that does not exist. The token rule is blind to this, because
# the mistake is a `unbloarchy` token, so scan for the forbidden forms directly.
KEEP_VERBATIM = (
    "pkgs.omarchy.org",
    "logs.omarchy.org",
    "[omarchy]",
    "omarchy.db",
)
FORBIDDEN_FORMS = tuple(
    re.sub(r"omarchy", "unbloarchy", kept, flags=re.I) for kept in KEEP_VERBATIM)

# The bare repo name at the head of a repository list, as in a test's expected
# `"omarchy core extra multilib"`; the bracketed KEEP_VERBATIM entry above only
# catches the section header. A run of Arch repository names after the name is
# what marks a list, so a lone "Unbloarchy core packages" in prose is ignored.
_ARCH_REPOS = r"(?:asahi-alarm|core|extra|multilib|alarm|aur)"
FORBIDDEN_PATTERNS = (
    re.compile(rf"unbloarchy(?:\s+{_ARCH_REPOS}){{3,}}", re.I),
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
                        if key in COMPAT_TOKENS:
                            continue
                        # Protected when the token's own omarchy spelling still
                        # names a tracked artifact (compat pair, shim, kept
                        # namespace). Flagged only when the omarchy spelling
                        # names nothing while its unbloarchy twin does: a
                        # reference to a file the fork renamed/moved.
                        if key not in CORPUS and swapped(t) in CORPUS:
                            failures.append(
                                f"token {path}:{n}: {t.strip()[:72]}")
    # Kept names, in every text file including the exempt ones: a migration or
    # legacy bridge that quotes `[omarchy]` is exactly where a bad sweep does
    # the most damage, so exemptions must not hide the forbidden forms.
    for path in TRACKED:
        if not is_text(path):
            continue
        if path == os.path.relpath(__file__, ROOT):
            continue  # this checker necessarily names the forbidden forms
        with open(os.path.join(ROOT, path), "r",
                  encoding="utf-8", errors="replace") as f:
            for n, line in enumerate(f, 1):
                low = line.lower()
                for kept, forbidden in zip(KEEP_VERBATIM, FORBIDDEN_FORMS):
                    if forbidden.lower() in low:
                        failures.append(
                            f"token {path}:{n}: {forbidden} (kept as {kept})")
                for rx in FORBIDDEN_PATTERNS:
                    m = rx.search(line)
                    if m:
                        failures.append(
                            f"token {path}:{n}: {m.group(0)} "
                            "(kept as a repository name)")
    if failures:
        print("not ok - rebrand-integrity-check")
        for f in failures:
            print(f"  {f}")
        print("(a merge-new omarchy path needs git mv; a token names an "
              "artifact whose unbloarchy twin exists, so it dangles; a kept "
              "name was rewritten to its unbloarchy form, which does not "
              "resolve)")
        sys.exit(1)
    print("ok - rebrand-integrity-check")


if __name__ == "__main__":
    main()