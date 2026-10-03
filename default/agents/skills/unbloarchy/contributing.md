# Reporting Issues and Submitting PRs

Read this when the user wants to report an Unbloarchy bug, suggest a feature, or
contribute a fix to Unbloarchy.

Unbloarchy lives at https://github.com/Magiclovekorean/unbloarchy. Route requests to the
right place:

- **Verified bugs** -> GitHub issues. Issues are for validated bugs only, not
  support requests.
- **Feature ideas and suggestions** ->
  https://github.com/Magiclovekorean/unbloarchy/discussions/categories/suggestions
- **Support and "is this a bug?" questions** -> Unbloarchy's GitHub Discussions at
  https://github.com/Magiclovekorean/unbloarchy/discussions. Start here when the problem isn't clearly a bug
  in Unbloarchy itself.

## Filing a Good Bug Report

The bug template asks for system details (CPU, GPU, Unbloarchy version), a
description with steps to reproduce, and diagnostics. Gather them:

```bash
unbloarchy version

# Generate the diagnostic log (also written to /tmp/unbloarchy-debug.log)
unbloarchy debug --no-sudo --print

# Interactive variant: `unbloarchy debug` can upload the log to the
# upstream logs.omarchy.org service and print a shareable URL. Review the
# log before uploading; it can contain system details and installed packages,
# and the upstream service says uploads expire after 24 hours.
```

**Capture the problem on screen.** A screenshot or short recording of the bug
is often worth more than the description — see [`capture.md`](capture.md) for
`unbloarchy capture screenshot` and `unbloarchy screenrecord`. Keep recordings short
and focused on the misbehavior. GitHub issue attachments are added by
drag-and-drop in the web form, so save the capture and hand the user the file
path to attach (`gh` cannot upload media).

For screen-recording failures specifically, rerun with
`UNBLOARCHY_SCREENRECORD_DEBUG=true` and attach `$XDG_RUNTIME_DIR/unbloarchy-screenrecord.log` (or `${XDG_STATE_HOME:-$HOME/.local/state}/unbloarchy/unbloarchy-screenrecord.log` without a session runtime directory).

File the issue with `gh` when available:

```bash
gh issue create --repo Magiclovekorean/unbloarchy --title "..." --body "..."
```

Include: what happened, what was expected, steps to reproduce, system details,
the debug log URL (or attached log), and the capture.

## Submitting a PR

Never develop against `/usr/share/unbloarchy`. Clone a working copy instead:

```bash
gh repo clone Magiclovekorean/unbloarchy
cd unbloarchy
```

Follow the repository's own `AGENTS.md` for style, testing, and commit
conventions — it is the authority on contributions. Keep commits atomic, run
`./test/all` before pushing, and open the PR with `gh pr create`. A PR that
fixes a visual problem should include before/after captures (again, see
[`capture.md`](capture.md)).
