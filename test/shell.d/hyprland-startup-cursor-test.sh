#!/bin/bash

set -euo pipefail
source "$(dirname "$0")/base-test.sh"
require_command lua

lua - <<'LUA'
package.path = os.getenv("ROOT") .. "/?.lua;" .. package.path
local events, recovery, command, imported = {}, nil, nil, false
local config = { invisible = false, enable_hyprcursor = true, sync_gsettings_theme = true }
local env = { XCURSOR_THEME = "my-xcursor", HYPRCURSOR_THEME = "my-hyprcursor", XCURSOR_PATH = "/my/icons", HYPRLAND_INSTANCE_SIGNATURE = "test-session", UNBLOARCHY_PATH = os.getenv("ROOT") }
local getenv = os.getenv
-- The fake environment owns every cursor variable, unset ones included, so
-- the session running the test cannot leak its own cursor into it.
os.getenv = function(name)
  if name:match("CURSOR") or name == "HYPRLAND_INSTANCE_SIGNATURE" then return env[name] end
  return env[name] or getenv(name)
end
local monitors = {}
hl = {
  on = function(event, callback) events[event] = callback end,
  get_monitors = function() return monitors end,
  get_config = function(key) return config[key:match("%.(.+)")] end,
  env = function(name, value) env[name] = value end,
  config = function(values)
    for name, value in pairs(values.cursor) do config[name] = value end
  end,
  timer = function(callback, options)
    assert(options.timeout == 15000 and options.type == "oneshot")
    recovery = callback
  end,
  exec_cmd = function(value)
    if value == "dbus-update-activation-environment --systemd XCURSOR_PATH XCURSOR_THEME" then
      assert(env.XCURSOR_THEME ~= "unbloarchy-startup" and not env.XCURSOR_PATH:match("/default/hypr/cursors"))
      imported = true
    end
    if value == "unbloarchy-launch-shell" then
      assert(config.invisible and env.XCURSOR_THEME == "my-xcursor", "hide the compositor cursor while restoring application settings before launch")
    end
    command = value
  end,
}
o = { shell_quote = function(value) return "'" .. value .. "'" end, launch = function(value) return value end }

require("default.hypr.autostart")
assert(not config.invisible, "loading the module must wait for user configuration")
events["config.reloaded"]()
assert(config.invisible and not config.enable_hyprcursor and not config.sync_gsettings_theme)
assert(env.XCURSOR_THEME == "unbloarchy-startup" and env.XCURSOR_PATH:match("/default/hypr/cursors:/my/icons$"))
assert(unbloarchy_startup_cursor_pending, "the first compositor frame must use the blank cursor")
events["hyprland.start"]()
assert(env.XCURSOR_THEME == "my-xcursor" and env.XCURSOR_PATH == "/my/icons", "applications must inherit the user's cursor")
assert(config.invisible, "starting applications must not reveal the cursor")

local previous_recovery = recovery
-- Hyprland reloads the configuration in a fresh Lua state and discards timers.
unbloarchy_startup_cursor_pending = nil
unbloarchy_startup_cursor = nil
for name in pairs(config) do config[name] = true end
config.invisible = false
monitors = { {} }
dofile(os.getenv("ROOT") .. "/default/hypr/startup-cursor.lua")
events["config.reloaded"]()
assert(unbloarchy_startup_cursor_pending and unbloarchy_startup_cursor.xcursor == "my-xcursor", "a fresh Lua state must retain the pending reveal and the user's cursor")
assert(recovery ~= previous_recovery and config.invisible, "a config reload must retain startup hiding and rearm recovery")
recovery()
assert(command:match("setcursor 'my%-xcursor'"), "restore the Xcursor fallback before revealing the pointer")
assert(config.invisible, "wait for the normal theme before restoring visibility")
unbloarchy_startup_cursor_restore(true)
assert(not config.invisible and config.enable_hyprcursor and config.sync_gsettings_theme)
assert(command:match("setcursor 'my%-hyprcursor'"), "restore the user's Hyprcursor theme")
local previous_command = command
previous_recovery()
assert(command == previous_command, "recovery must not change a revealed cursor")
events["config.reloaded"]()
assert(not config.invisible and env.XCURSOR_THEME == "my-xcursor", "ordinary config reloads must not hide the cursor")

unbloarchy_startup_cursor_pending = nil
monitors = { {} }
events["config.reloaded"]()
assert(not unbloarchy_startup_cursor_pending and not config.invisible, "installing the fix in a running compositor must leave its cursor alone")

local popen = io.popen
local gsettings = "'custom-cursor'\n"
io.popen = function(value)
  assert(value:match("gsettings get org.gnome.desktop.interface cursor%-theme"))
  return { read = function() return gsettings end, close = function() return true end }
end
local function orphan(theme)
  imported = false
  unbloarchy_startup_cursor_pending, unbloarchy_startup_cursor = nil, nil
  env.XCURSOR_THEME = "unbloarchy-startup"
  env.UNBLOARCHY_STARTUP_CURSOR_THEME = theme
  env.UNBLOARCHY_STARTUP_CURSOR_SESSION = "old-session"
  env.XCURSOR_PATH = "/old/worktree/default/hypr/cursors:/my/icons"
  env.UNBLOARCHY_STARTUP_CURSOR_PATH = nil
  config.invisible, config.enable_hyprcursor, config.sync_gsettings_theme = false, false, true
  dofile(os.getenv("ROOT") .. "/default/hypr/startup-cursor.lua")
  events["config.reloaded"]()
  assert(unbloarchy_startup_cursor_pending, "an orphan blank theme must be recovered with live monitors")
  assert(env.XCURSOR_THEME ~= "unbloarchy-startup" and env.XCURSOR_PATH == "/my/icons", "recovery must remove the blank theme and old worktree search path")
  return unbloarchy_startup_cursor.xcursor
end
assert(orphan("saved-custom") == "saved-custom", "saved settings take precedence over GSettings")
unbloarchy_startup_cursor_restore()
assert(command:match("setcursor 'saved%-custom'") and imported, "orphan recovery must also repair activation environments")
local stalled = command
command = nil
recovery()
assert(command == stalled, "the timeout must retry an unfinished restore")
local completion = assert(command:match("hyprctl eval '(.*)'$"))
unbloarchy_startup_cursor.xcursor = "changed-during-restore"
assert(load(completion))()
assert(unbloarchy_startup_cursor_pending, "a stale completion must not reveal a different cursor after reload")
unbloarchy_startup_cursor.xcursor = "saved-custom"
local old_size = unbloarchy_startup_cursor.size
unbloarchy_startup_cursor.size = old_size + 8
assert(load(completion))()
assert(unbloarchy_startup_cursor_pending, "a stale completion must not acknowledge a different cursor size")
unbloarchy_startup_cursor.size = old_size
unbloarchy_startup_cursor_restore(true)
assert(not config.invisible and config.sync_gsettings_theme)
assert(orphan(nil) == "custom-cursor", "recover a nonblank user GSettings theme when no snapshot survives")
unbloarchy_startup_cursor_restore(true)
gsettings = "'unbloarchy-startup'\n"
assert(orphan(nil) == "default", "a destroyed user preference must fall back to the default alias, never the blank theme")
unbloarchy_startup_cursor_restore(true)
unbloarchy_startup_cursor_pending, unbloarchy_startup_cursor = nil, nil
monitors = {}
env.XCURSOR_THEME, env.XCURSOR_PATH = "next-theme", "/next/icons"
env.UNBLOARCHY_STARTUP_CURSOR_PATH = "/stale/icons"
env.UNBLOARCHY_STARTUP_CURSOR_SESSION = "old-session"
events["config.reloaded"]()
assert(unbloarchy_startup_cursor.xcursor == "next-theme" and unbloarchy_startup_cursor.path == "/next/icons", "a new session must honor changed cursor settings instead of inherited snapshots")
unbloarchy_startup_cursor_pending, unbloarchy_startup_cursor = nil, nil
env.XCURSOR_THEME, env.UNBLOARCHY_STARTUP_CURSOR_SESSION, gsettings = "", "old-session", "'custom-cursor'\n"
events["config.reloaded"]()
assert(unbloarchy_startup_cursor.xcursor == "default", "an ordinary boot without a cursor theme keeps the default alias instead of adopting GSettings")
io.popen = popen
LUA
pass "the first compositor frame starts blank and the reveal restores user cursor settings"
