-- Frosted glass from the glassy Starship (#14726): whatever is behind a
-- see-through window or shell surface is blurred. Terminals get the see-through
-- background itself from unbloarchy-theme-set-glass, which keeps their text crisp.
require("default.hypr.glass")()

-- GTK apps fade as a whole, since GTK draws their backgrounds solid, and get
-- their blur from the backdrop-filter Glassy adds to the user's gtk.css.
o.window("org\\.gnome\\.Nautilus", { opacity = "0.75 0.75" })

hl.layer_rule({
  match = { namespace = "^(unbloarchy-bar|unbloarchy-menu|unbloarchy-notifications|unbloarchy-osd|omarchy-polkit|unbloarchy-reminders|unbloarchy-clipboard|unbloarchy-emojis|unbloarchy-image-selector|unbloarchy-keyboard-panel|unbloarchy-network-qr)$" },
  blur = true,
  ignore_alpha = 0.3,
})
