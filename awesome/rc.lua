-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
-- {{{ Local variables
--
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
require("awful.autofocus")

--- {{{ Local functions
local function readAll(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end
--}}}

local modkey = "Mod4"
local hostname = readAll("/etc/hostname")

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.floating,
}
-- }}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end
-- }}}

beautiful.init(gears.filesystem.get_configuration_dir() .. "fresh/theme.lua")

-- Wibar
local widgets = require("widgets") -- load file with hotkeys configuration
widgets:init(hostname)

-- HotKeys
local hotkeys = require("keys") -- load file with hotkeys configuration
hotkeys:init({ modkey = modkey})

-- Rules
local rules = require("rules") -- load file with rules configuration
rules:init({ hotkeys = hotkeys})

-- {{{ TitleBar
-- Signal function to execute when a new client appears.

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
    buttons = buttons,
    layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
-- }}}

-- Signals
local signals = require("signals")
signals:init()

-- Autostart Applications {{{
local function run_once(cmd_arr)
  local user = os.getenv("USER")
  for _, cmd in ipairs(cmd_arr) do
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.easy_async(string.format("pgrep -u %s -x %s", user, findme), function(_, _, _, exit_code)
      if exit_code ~= 0 then
        awful.spawn(cmd,false)
      end
    end)
  end
end

local autorun = {}
autorun["all"] = {
  "xss-lock -- lockscreen " .. beautiful.wallpaper,
  "redshift -l 38.72:-9.15 -t 5700:3600",
  "numlockx",
  "nm-applet",
  "unclutter -noevents -idle 2 -jitter 1 -root"
}

autorun["atreides"] = {
  "compton --config /home/jguer/dotfiles/compton.conf"
}

autorun["fenring"] = {
  "blueman-applet"
}

run_once(autorun["all"])
run_once(autorun[hostname] or {})
-- }}}

