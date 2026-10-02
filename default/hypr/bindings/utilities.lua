o.bind("SUPER + SPACE", "Unbloarchy menu", { menu = "root" })
o.bind("SUPER + ALT + SPACE", "Apps menu", { menu = "apps" })
o.bind("SUPER + E", "Emojis", { panel = "unbloarchy.emojis" })
o.bind("SUPER + S", "Capture menu", { menu = "capture" })
o.bind("SUPER + SHIFT + O", "Toggle menu", { menu = "toggle" })
o.bind("SUPER + SHIFT + H", "Hardware menu", { menu = "hardware" })
o.bind("SUPER + SHIFT + code:201", "Unbloarchy menu", { menu = "root" })
o.bind("SUPER + ESCAPE", "System menu", { menu = "system" })
o.bind("XF86PowerOff", "Power menu", { menu = "system" }, { locked = true })
o.bind("SUPER + K", "Keybindings", "unbloarchy-menu-keybindings")
o.bind("SUPER + ALT + K", "Tmux keybindings", "unbloarchy-menu-tmux-keybindings")
o.bind("SUPER + SHIFT + K", "Herdr keybindings", "unbloarchy-menu-herdr-keybindings")
o.bind("SUPER + C", "Calculator", "omacalc")
o.bind("XF86Calculator", "Calculator", "omacalc")

o.bind_toggle("SUPER + SHIFT + SPACE", "Toggle top bar", "bar")
o.bind("SUPER + CTRL + SPACE", "Background switcher", { menu = "background" })
o.bind("SUPER + SHIFT + T", "Theme menu", { menu = "theme" })
o.bind("SUPER + BACKSPACE", "Toggle window transparency", "unbloarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", "unbloarchy-hyprland-window-gaps-toggle")
o.bind("SUPER + CTRL + BACKSPACE", "Toggle single-window square aspect", "unbloarchy-hyprland-window-single-square-aspect-toggle")

-- xkbcommon names the comma keysym "comma"; the upper-case "COMMA" does not match.
o.bind("SUPER + comma", "Dismiss last notification", { ipc = "notifications.dismissOne" })
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", { ipc = "notifications.dismissAll" })
o.bind_toggle("SUPER + CTRL + comma", "Toggle silencing notifications", "notification-silencing")
o.bind("SUPER + ALT + comma", "Invoke last notification", { ipc = "notifications.invokeLast" })
o.bind("SUPER + SHIFT + ALT + comma", "Open notification history", { ipc = "notifications.showHistory" })

o.bind_toggle("SUPER + SHIFT + I", "Toggle locking on idle", "idle")
o.bind_toggle("SUPER + SHIFT + N", "Toggle nightlight", "nightlight")
o.bind("SUPER + CTRL + Delete", "Toggle laptop display", "unbloarchy-hyprland-monitor-internal toggle")
o.bind("SUPER + CTRL + ALT + Delete", "Toggle laptop display mirroring", "unbloarchy-hyprland-monitor-internal-mirror toggle")
o.bind("switch:on:Lid Switch", nil, "unbloarchy-system-lid-close", { locked = true })
o.bind("switch:off:Lid Switch", nil, "unbloarchy-hyprland-monitor-clamshell", { locked = true })

o.bind("PRINT", "Screenshot", "unbloarchy-capture-screenshot")
o.bind("ALT + PRINT", "Screenrecording", "unbloarchy-capture-screenrecording --stop-recording || unbloarchy-menu toggle trigger.capture.screenrecord")
o.bind("SUPER + ALT + code:34", "Make webcam overlay smaller", "unbloarchy-capture-webcam-resize smaller")
o.bind("SUPER + ALT + code:35", "Make webcam overlay larger", "unbloarchy-capture-webcam-resize larger")
o.bind("SUPER + SHIFT + C", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + O", "Extract text (OCR) from screenshot", "unbloarchy-capture-text")

-- Keyboard control for the slurp region picker (see unbloarchy-capture-region).
-- The binds live exactly as long as a selection layer is on screen (slurp
-- opens one per monitor), so they cannot leak or get stuck.
-- Unbinding by key would take a same-key binding out of the user's own config
-- with it, so each handle is kept and removed individually.
local selection_layers = 0
local selection_binds = {}

hl.on("layer.opened", function(layer)
  if layer.namespace == "selection" then
    selection_layers = selection_layers + 1
    if selection_layers == 1 then
      selection_binds = {
        hl.bind("RETURN", hl.dsp.exec_cmd("unbloarchy-capture-region --take-window"), { description = "Capture highlighted window" }),
        hl.bind("CTRL + RETURN", hl.dsp.exec_cmd("unbloarchy-capture-region --take-fullscreen"), { description = "Capture entire screen" }),
        hl.bind("TAB", hl.dsp.exec_cmd("unbloarchy-capture-region --select-window next"), { description = "Select next window to capture" }),
        hl.bind("CTRL + TAB", hl.dsp.exec_cmd("unbloarchy-capture-region --select-window prev"), { description = "Select previous window to capture" }),
      }
      for _, direction in ipairs({ "left", "right", "up", "down" }) do
        table.insert(
          selection_binds,
          hl.bind(direction:upper(), hl.dsp.exec_cmd("unbloarchy-capture-region --select-window " .. direction), { description = "Select window to capture" })
        )
      end
    end
  end
end)

hl.on("layer.closed", function(layer)
  if layer.namespace == "selection" and selection_layers > 0 then
    selection_layers = selection_layers - 1
    if selection_layers == 0 then
      for _, keybind in ipairs(selection_binds) do
        keybind:unbind()
      end
      selection_binds = {}
    end
  end
end)

o.bind("SUPER + CTRL + S", "Share", { menu = "share" })

o.bind("SUPER + CTRL + PERIOD", "Transcode", "unbloarchy-transcode")

o.bind("SUPER + CTRL + R", "Set reminder", { menu = "reminder-set" })
o.bind("SUPER + CTRL + ALT + R", "Show reminders", "unbloarchy-reminder show")
o.bind("SUPER + SHIFT + CTRL + R", "Clear reminders", "unbloarchy-reminder clear")

o.bind("SUPER + CTRL + ALT + T", "Show time", "unbloarchy-notification-time")
o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", "unbloarchy-notification-battery")
o.bind("SUPER + CTRL + ALT + W", "Toggle weather", "unbloarchy-notification-weather")

o.bind("SUPER + SHIFT + CTRL + A", "Agent", "unbloarchy-agent --pick")
o.bind("SUPER + CTRL + A", "Audio", { panel = "unbloarchy.audio" })
o.bind("SUPER + CTRL + B", "Bluetooth", { panel = "unbloarchy.bluetooth" })
o.bind("SUPER + CTRL + D", "Display", { panel = "unbloarchy.monitor" })
o.bind("SUPER + CTRL + ALT + D", "Calendar", { panel = "unbloarchy.clock" })
o.bind("SUPER + CTRL + ALT + E", "World clock", { panel = "unbloarchy.elsewhen" })
o.bind("SUPER + CTRL + W", "Network", { panel = "unbloarchy.network" })
o.bind("SUPER + CTRL + P", "Power", { panel = "unbloarchy.power" })
o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })

-- The letters above name a panel; the numbers count them. 1 is the leftmost
-- panel in the bar's right section, and a widget with no panel of its own (the
-- tray) is not counted, so the number matches the icon a user would point at.
-- A bar with fewer panels than this leaves the tail of the range doing nothing.
for panel = 1, 9 do
  o.bind(
    "SUPER + CTRL + code:" .. tostring(panel + 9),
    "Bar panel " .. panel,
    "unbloarchy-shell -q shell togglePanelAt right " .. panel
  )
end

o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)

o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

o.bind("SUPER + CTRL + L", "Lock system", "unbloarchy-system-lock")
