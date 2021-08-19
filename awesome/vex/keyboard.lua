local setmetatable = setmetatable
local awful = require("awful")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears_color = require("gears.color")
local recolor_image = gears_color.recolor_image

local keyboard = { mt = {} }

local style = { width = 48, icon = beautiful.lookup_icon_and_load("capslock-enabled-symbolic", 16) }

-- @return A pulse widget.
function keyboard.new()
	local icon = wibox.widget({
		image = style.icon,
		forced_width = 16,
		forced_height = 16,
		widget = wibox.widget.imagebox,
	})

	local text = awful.widget.keyboardlayout()

	local self = wibox.layout.align.horizontal(wibox.container.place(icon), text)

	self.icon = icon
	self.text = text

	-- Mouse bindings, for when you want to add GMT change
	self:buttons(self.text:buttons())

	return self
end

local _instance = nil

function keyboard.mt:__call(...)
	if _instance == nil then
		_instance = self.new(...)
	end
	return _instance
end

return setmetatable(keyboard, keyboard.mt)
