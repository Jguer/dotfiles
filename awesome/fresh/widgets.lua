-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local gears      = require("gears")
local wibox      = require("wibox")
local wpulse     = require("fresh.widgets.pulse")
local wseparator = require("fresh.widgets.separator")
local wtime      = require("fresh.widgets.timewidget")
local wkeyboard  = require("fresh.widgets.keyboard")

local widgets = { right = {}}


function widgets:init(hostname)
  local separator = wseparator.vertical()

  self.right = { -- Right widgets
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
    self.right = gears.table.join(self.right,
      { separator,
        wbattery(30),
        separator,
        wbrightness(30)})
  end

  self.right = gears.table.join(self.right,
    { separator,
      wtime()
    })
end

return widgets
