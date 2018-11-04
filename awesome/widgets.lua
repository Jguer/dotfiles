-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local gears      = require("gears")
local wibox      = require("wibox")
local wpulse     = require("fresh.widgets.pulse")
local wseparator = require("fresh.widgets.separator")
local wtime      = require("fresh.widgets.timewidget")
local wkeyboard  = require("fresh.widgets.keyboard")
local beautiful = require("beautiful")
local awful     = require("awful")

local widgets = {}


-- Local Functions {{{
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ }, 3, awful.tag.viewtoggle),
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
  awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
awful.button({ }, 5, function() awful.client.focus.byidx(-1) end))

-- }}}

local function right_widgets(hostname)
  local separator = wseparator.vertical()

  local right = { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.systray(),
    separator,
    wkeyboard(),
    separator,
    wpulse(6),
  }

  if (not string.match(hostname, "atreides")) then
    local wbattery = require("fresh.widgets.battery")
    local wbrightness = require("fresh.widgets.brightness")
    right = gears.table.join(right,
      { separator,
        wbattery(30),
        separator,
      wbrightness(30)})
  end

  right = gears.table.join(right,
    { separator,
      wtime()
    })

  return right
end


function widgets:init(hostname)
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
          s.tasklist,
          layout = wibox.layout.flex.horizontal,
        },
        right_widgets(hostname),
        layout = wibox.layout.align.horizontal
      }
    end)

  end

  return widgets
