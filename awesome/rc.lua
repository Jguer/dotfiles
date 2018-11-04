-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
-- {{{ Local variables
--
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local quake     = require("quake")
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

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      -- c:emit_signal(
      --   "request::activate",
      --   "tasklist",
      --   {raise = true}
      --   )
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))


-- Widgets
local widgets = require("fresh.widgets") -- load file with hotkeys configuration
widgets:init(hostname)

screen.connect_signal("property::geometry", beautiful.set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  beautiful.set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "◢", "◤", "◢", "◤", "◢", "◤"}, s, awful.layout.layouts[1])

  s.layoutbox = awful.widget.layoutbox(s)
  s.layoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
  s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  s.wibox = awful.wibar({ position = "top", screen = s, height = beautiful.panel_height })

  -- Add widgets to the wibox
  s.wibox:setup {
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.layoutbox,
      s.taglist,
    },
    {
      layout = wibox.layout.flex.horizontal,
      s.tasklist,
    },
    widgets.right,
    layout = wibox.layout.align.horizontal
  }
end)
-- }}}

-- HotKeys
local hotkeys = require("fresh.keys") -- load file with hotkeys configuration
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

