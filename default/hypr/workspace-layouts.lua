-- Restore workspace layouts saved by unbloarchy-hyprland-workspace-layout-toggle.

local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

local layouts_dir = paths.state_home .. "/unbloarchy/workspace-layouts"

require_all.files(layouts_dir, "unbloarchy.workspace-layouts", { reload = true })
