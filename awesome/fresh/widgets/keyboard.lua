local setmetatable = setmetatable
local awful         = require("awful")
local beautiful     = require("beautiful")
local widget_base   = require("wibox.widget.base")
local wibox         = require("wibox")
local gears_color   = require("gears.color")
local recolor_image = gears_color.recolor_image

local keyboard = { mt = {} }

local style = {
  width   = 55,
  icon    = beautiful.themes_path .. "widgets/keyboard.svg",
}

-- @return A pulse widget.
function keyboard.new()
  local icon = wibox.widget {
    image  = recolor_image(style.icon, beautiful.widget.fg),
    resize = true,
    forced_width = 16,
    forced_height = 16,
    widget = wibox.widget.imagebox
  }

  local text = awful.widget.keyboardlayout()

  local layout = wibox.layout.fixed.horizontal()
  layout:add(wibox.container.margin(icon, 0, 2, 4, 4))
  layout:add(text)

  local widget = wibox.container.constraint(layout, "exact", style.width)
  local self = widget_base.make_widget(widget)
  self.icon = icon
  self.text = text

  -- Mouse bindings, for when you want to add GMT change
  self:buttons(self.text:buttons())

  return self
end

local _instance = nil;

function keyboard.mt:__call(...)
  if _instance == nil then
    _instance = self.new(...)
  end
  return _instance
end

return setmetatable(keyboard, keyboard.mt)
