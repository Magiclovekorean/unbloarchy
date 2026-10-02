-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Unbloarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("UNBLOARCHY_PATH") or "/usr/share/unbloarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Unbloarchy default bindings. Add your own in hypr/bindings.lua.
-- unbloarchy_default_bindings = false
--
-- Or disable only bindings for Unbloarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- unbloarchy_preinstalled_bindings = false

-- Load Unbloarchy defaults.
require("default.hypr.unbloarchy")

-- Put your personal overrides in these files. They're loaded after Unbloarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
