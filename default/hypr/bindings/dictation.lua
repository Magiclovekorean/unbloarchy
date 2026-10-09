if o.shell_succeeds("unbloarchy-default-dictation") then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "unbloarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "unbloarchy-dictation start", "Stop dictation (push-to-talk)", "unbloarchy-dictation stop")
  -- A modifier's mask changes between its press and release. Match the keysym
  -- independently of that mask; AltGr layouts use a different keysym.
  o.bind_hold("ALT + Alt_R", "Start dictation (push-to-talk)", "unbloarchy-dictation start", "Stop dictation (push-to-talk)", "unbloarchy-dictation stop", { ignore_mods = true })
end
