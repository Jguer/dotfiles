-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local gears      = require("gears")
local wibox      = require("wibox")
local wpulse     = require("vex.pulse")
local wtime      = require("vex.timewidget")
local wkeyboard  = require("vex.keyboard")
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

local function right_widgets(hostname, s)

  local right = { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.systray(),
    wkeyboard(),
    wpulse(6),
  }

  if (not string.match(hostname, "atreides")) then
    local wbattery = require("vex.battery")
    local wbrightness = require("vex.brightness")
    right = gears.table.join(right, {wbattery(30), wbrightness(30)})
  end


    s.layoutbox = wibox.container.margin(awful.widget.layoutbox(s), 0,2,2,4)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)))

  right = gears.table.join(right,
    { wtime(),
      s.layoutbox,
      spacing = 10,
      layout  = wibox.layout.fixed.horizontal
    })

  return right
end


function widgets:init(hostname)
  screen.connect_signal("property::geometry", beautiful.set_wallpaper)

  awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    beautiful.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "α", "β", "δ", "Θ", "Ω", "λ", "π"}, s, awful.layout.layouts[1])

    -- s.layoutbox = awful.widget.layoutbox(s)

      s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
      s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)


      s.wibox = awful.wibar({ position = "top", screen = s, height = beautiful.panel_height })

      -- Add widgets to the wibox
      s.wibox:setup {
        { -- Left widgets
          s.taglist,
          layout = wibox.layout.fixed.horizontal,
        },
        {
          s.tasklist,
          layout = wibox.layout.flex.horizontal,
        },
        right_widgets(hostname,s),
        layout = wibox.layout.align.horizontal
      }
    end)

  end

  return widgets
