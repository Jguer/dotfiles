-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local audio     = require("fresh.widgets.audio")

local widgets = { right = {}}

local function readAll(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

function widgets:init(args)
  local args = args or {}

  local hostname = readAll("/etc/hostname")
  local keyboardlayout = awful.widget.keyboardlayout()

  local textclock = wibox.widget.textclock("GMT: %H:%M")

  local volume_widget = audio()
  volume_widget:connect_signal("button::press", function(_,_,_,button)
    if (button == 4)     then audio:change_volume("5%+")
    elseif (button == 5) then audio:change_volume("5%-")
    elseif (button == 1) then audio:mute()
    end
  end)
  audio:set_watch(6)


  local separator = wibox.widget {
    {
      left   = 4,
      right  = 4,
      top    = 0,
      bottom = 0,
      widget = wibox.container.margin
    },
    widget             = wibox.container.background
  }

  self.right = { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.systray(),
    separator,
    keyboardlayout,
    separator,
    volume_widget,
  }

  if (hostname == "harkonnen" ) then
    local battery_widget    = require("fresh.widgets.batteryarc")
    local brightness_widget = require("fresh.widgets.brightness")
    self.right = gears.table.join(self.right,
      { separator,
        battery_widget,
        separator,
        brightness_widget })
  end

  self.right = gears.table.join(self.right,
    { separator,
      textclock,
      separator
    })
end

return widgets
