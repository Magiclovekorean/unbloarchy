# Command Metadata

Read this before adding or changing commands in `bin/`.

Commands in `bin/` can declare CLI metadata in comments near the top of the
file. `bin/unbloarchy` scans the first 80 lines, and tests expect command metadata
to remain valid.

Supported metadata keys:

- `# unbloarchy:group=...` - override the command group inferred from the filename
- `# unbloarchy:name=...` - override the command name inferred from the filename
- `# unbloarchy:summary=...` - short help text
- `# unbloarchy:args=...` - usage arguments
- `# unbloarchy:examples=...` - examples separated with ` | `
- `# unbloarchy:alias=...` / `# unbloarchy:aliases=...` - alternate routes
- `# unbloarchy:hidden=true` - hide from default command listings
- `# unbloarchy:requires-sudo=true` - mark commands that require sudo

Only use `unbloarchy:examples` where there are args that need explaining.

Prefer explicit metadata for user-facing commands. Keep routes consistent with
the filename unless there is a deliberate alias or compatibility route.

Example:

```bash
# unbloarchy:summary=Take a screenshot
# unbloarchy:args=[smart|region|windows|fullscreen] [slurp|copy]
# unbloarchy:examples=unbloarchy screenshot | unbloarchy capture screenshot region
```
