-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local pulse     = require("fresh.widgets.pulse")
local wseparator = require("fresh.widgets.separator")

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

  local textclock = wibox.widget.textclock("%H:%M %d/%b ")
  local month_calendar = awful.widget.calendar_popup.month()
  month_calendar:attach(textclock, 'tr')

  local pulse_bar = pulse(6)

  local separator = wseparator.vertical()

  self.right = { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.systray(),
    separator,
    keyboardlayout,
    separator,
    pulse_bar,
  }

  if (string.match(hostname, "harkonnen")) then
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
      textclock
    })
end

return widgets
