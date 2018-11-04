-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
-- {{{ Standard awesome library
--
local gears             = require("gears")
local awful             = require("awful")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local quake             = require("quake")
require("awful.autofocus")
-- }}}

-- Error handling
require("fresh.ercheck-config") -- load file with error handling

beautiful.init(gears.filesystem.get_configuration_dir() .. "fresh/theme.lua")

local modkey = "Mod4"

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.floating,
}

-- {{{ Menu
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
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
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
widgets:init()

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
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.layoutbox,
      s.taglist,
    },
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",
      nil,
      s.tasklist,
    },
    widgets.right
  }
end)
-- }}}

-- HotKeys
local hotkeys = require("fresh.keys") -- load file with hotkeys configuration
hotkeys:init({ modkey = modkey})

-- Rules
local rules = require("fresh.rules") -- load file with rules configuration
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
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
    },
    buttons = buttons,
    layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
-- }}}

-- Signals
local signals = require("fresh.signals")
signals:init()

-- Autostart Applications
require("autostart")
