# Visual Verification

Read this before finishing any change with a visual effect: Unbloarchy shell
styling and layout, panels, menus, notifications, desktop appearance,
animations, transitions, screenshots, and screen recording flows.

Visual changes must be verified in the running UI in addition to automated
tests. Creating an artifact is not sufficient: inspect it for clipping,
overlap, incorrect spacing, stale state, focus problems, and visual
regressions before finishing.

Take a full-screen screenshot without opening the editor:

```bash
unbloarchy capture screenshot fullscreen save
```

The command writes to Omasnap's configured screenshot directory. Use `unbloarchy screenshot` for the interactive capture flow, which saves and copies the capture and shows its notification. Use `unbloarchy screenshot --editor=overlay` to test annotation before output. Capture reference and candidate states as separate images when changing a layer-shell surface or layout, then compare both.

Record a short full-screen video for animation, transition, timing, capture, or
screen-recording changes:

```bash
unbloarchy screenrecord --fullscreen
# Exercise the changed behavior.
unbloarchy screenrecord --stop-recording
```

The stop command prints the saved video path in the configured Videos
directory. Review the recording before finishing, and keep it short and focused
on the changed behavior.

## Checking motion frame by frame

Motion goes wrong in a frame or two, too fast to see at full speed: two texts showing at once in a crossfade, a blank frame between two panels, a card that jumps instead of morphing, a panel growing from the wrong point. Record the change and read it a frame at a time. Follow [`motion.md`](motion.md) for what the motion should be.

Run the branch's shell, not the installed one. The running shell loads plugins from `$OMARCHY_PATH`, and its launcher relaunches it if killed, so stop it and start the worktree's through Hyprland. This takes over the desktop, so tell whoever is at it first with `unbloarchy-notification-send`, wait a few seconds, and always put their shell back afterwards (a `trap` on `EXIT` does it even when a step fails):

```bash
WT=/path/to/worktree
while timeout 30 quickshell kill -p "$UNBLOARCHY_PATH/shell" --any-display >/dev/null 2>&1; do :; done
hyprctl dispatch "hl.dsp.exec_cmd(\"env UNBLOARCHY_PATH=$WT unbloarchy-launch-shell\")"
# A starting shell answers one ping and then drops calls while plugins load:
# wait for several answers in a row, a second apart.
UNBLOARCHY_PATH=$WT unbloarchy-shell shell ping
# ... record ...
while timeout 30 quickshell kill -p "$WT/shell" --any-display >/dev/null 2>&1; do :; done
unbloarchy-restart-shell
```

Drive it without touching the mouse:

- A panel's own IPC target (`unbloarchy-shell unbloarchy.network open`) takes the same path as a click on its icon. `unbloarchy-shell shell toggle unbloarchy.network` takes the keybinding's path.
- `unbloarchy-notification-send` raises notifications, and `unbloarchy-shell notifications dismiss <summary>` closes one the way a click does. Requested timeouts are raised to at least 8 seconds, so don't wait on a short `-t` to see an expiry.
- `hyprctl eval "hl.dispatch(hl.dsp.cursor.move({ x = 2810, y = 70 }))"` moves the pointer for hover.
- A panel builds its content and maps its window on its first open, which can swallow the first frames of its motion. Open and close each panel once before recording unless the first open is what's being checked.

Then lay the frames out side by side. Crop to where the change happens and tile every frame of the moment, at the recording's full 60fps:

```bash
ffmpeg -ss 4.35 -t 0.4 -i recording.mp4 -vf "crop=2440:700:1400:0,scale=488:-1,tile=4x6" -frames:v 1 frames.png
```

Find the moment with a coarse sheet first (`fps=6` before the crop), then tile it at full rate and read every frame: where the motion starts from, whether anything doubles up or blanks, and where it settles.

From outside the session (an agent's shell, SSH), export `HYPRLAND_INSTANCE_SIGNATURE` and `WAYLAND_DISPLAY`. Without them `hyprctl` refuses and the recorder exits silently with nothing saved; `UNBLOARCHY_SCREENRECORD_DEBUG=true` logs why to `$XDG_RUNTIME_DIR/unbloarchy-screenrecord.log`.

For interactive UI work, use `wtype` to simulate keyboard input when available.
Example: start the UI in the background, wait briefly for focus, then run
`wtype -k Right -k Return` to exercise keyboard selection and confirm the
resulting command output or state change. Prefer this over manual-only
verification when a UI returns a selected value or changes a symlink/config.

If a launched UI would otherwise remain open, keep track of its PID and stop it
after the screenshot or recording; avoid broad process kills unless checking
with `ps` first.
