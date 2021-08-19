local setmetatable = setmetatable
local awful = require("awful")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local button = require("awful.button")

local systraypopup = { mt = {} }

local style = {
	width = 48,
	icon = beautiful.lookup_icon_and_load("pan-start-symbolic", 24),
	close_icon = beautiful.lookup_icon_and_load("pan-end-symbolic", 24),
}

-- @return A systraypopup widget.
function systraypopup.new()
	local icon = wibox.widget({
		image = style.icon,
		resize = true,
		forced_width = 24,
		forced_height = 24,
		widget = wibox.widget.imagebox,
	})

	local systray = wibox.widget.systray()
	systray.base_size = 28

	local container = wibox.container.place(systray)
	local fixed_layout = wibox.layout.fixed.horizontal()
	local layout = wibox.layout.fixed.horizontal(fixed_layout, wibox.container.place(icon))

	local self = widget_base.make_widget(layout)
	self.icon = icon
	self.systray = systray
	self.visible = false

	self:buttons(gears.table.join(button({}, 1, function()
		if self.visible == false then
			fixed_layout:add(container)
			self.icon.image = style.close_icon
			self.visible = true
		else
			fixed_layout:remove_widgets(container)
			self.icon.image = style.icon
			self.visible = false
		end
		self.systray.screen = awful.screen.focused()
	end)))

	return self
end

local _instance = nil

function systraypopup.mt:__call(...)
	if _instance == nil then
		_instance = self.new(...)
	end
	return _instance
end

return setmetatable(systraypopup, systraypopup.mt)
