local setmetatable = setmetatable
local awful         = require("awful")
local beautiful     = require("beautiful")
local widget_base   = require("wibox.widget.base")
local wibox         = require("wibox")
local gears_color   = require("gears.color")
local recolor_image = gears_color.recolor_image

local timewidget = { mt = {} }

local style = {
  width   = 72,
  icon    = beautiful.themes_path .. "widgets/clock.svg",
}

-- @return A pulse widget.
function timewidget.new()
  local icon = wibox.widget {
    image  = recolor_image(style.icon, beautiful.widget.fg),
    resize = true,
    forced_width = 24,
    forced_height = 24,
    widget = wibox.widget.imagebox
  }

  local text = wibox.widget.textclock("%H:%M", 60)

  local layout = wibox.layout.fixed.horizontal()
  layout:add(wibox.container.margin(icon, 0, 2, 3, 2))
  layout:add(text)

  local widget = wibox.container.constraint(layout, "exact", style.width)
  local self = widget_base.make_widget(widget)
  self.icon = icon
  self.text = text

  local month_calendar = awful.widget.calendar_popup.month()
  month_calendar:attach(self, 'tr')

  -- Mouse bindings, for when you want to add GMT change
  -- self:buttons(gears.table.join(button({ }, 1, function() self.toggle_mute() end)))

  return self
end

local _instance = nil;

function timewidget.mt:__call(...)
  if _instance == nil then
    _instance = self.new(...)
  end
  return _instance
end

return setmetatable(timewidget, timewidget.mt)
