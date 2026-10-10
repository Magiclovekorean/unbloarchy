-- Bound only once the chosen backend's own program is installed (Unbloarchy ships
-- every adapter): an aarch64 machine has no Superwhisper build, and
-- push-to-talk would hold Right Alt (AltGr) for nothing.
local pipe = io.popen("unbloarchy-default-dictation 2>/dev/null", "r")
local backend = pipe and pipe:read("*l")
if pipe then
  pipe:close()
end
if backend and backend:match("^[%w%-]+$") and not o.cmd_missing(backend) then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "unbloarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "unbloarchy-dictation start", "Stop dictation (push-to-talk)", "unbloarchy-dictation stop")
  -- A modifier's mask changes between its press and release. Match the keysym
  -- independently of that mask; AltGr layouts use a different keysym.
  o.bind_hold("ALT + Alt_R", "Start dictation (push-to-talk)", "unbloarchy-dictation start", "Stop dictation (push-to-talk)", "unbloarchy-dictation stop", { ignore_mods = true })
end
