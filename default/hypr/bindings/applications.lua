-- Essential application bindings.
o.bind("SUPER + RETURN", "Terminal", o.launch_terminal())
o.bind("SUPER + B", "Browser", { unbloarchy = "browser" })
o.bind("SUPER F", "File manager", { unbloarchy = "nautilus" })
o.bind("SUPER + ALT + F", "File manager (cwd)", { unbloarchy = "nautilus-cwd" })

if o.preinstalled_bindings_enabled() then
  -- Bindings for preinstalled Unbloarchy applications, TUIs, and web apps.
  o.bind("SUPER + ALT + RETURN", "Tmux", { unbloarchy = "terminal-tmux" })
  o.bind("SUPER + CTRL + RETURN", "Herdr", { unbloarchy = "terminal-herdr" })
  o.bind("SUPER + SHIFT + M", "Music", { unbloarchy = "spotify" })
  o.bind("SUPER + SHIFT + ALT + M", "Music TUI", { tui = "cliamp", focus = true })
  o.bind("SUPER + SHIFT + D", "Docker", { tui = "unbloarchy-launch-docker-tui" })
  o.bind("SUPER + SHIFT + G", "Signal", { unbloarchy = "signal" })
  o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
  o.bind("SUPER + SHIFT + W", "Omawrite", { launch = "omawrite" })
  o.bind("SUPER + SHIFT + SLASH", "Passwords", { unbloarchy = "1password" })

  o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
  o.bind("SUPER + SHIFT + ALT + A", "Grok", { webapp = "https://grok.com" })
  o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
  o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
end
