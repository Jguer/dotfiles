local awful = require("awful")
local beautiful = require("beautiful")
local button = require("awful.button")
local wibox = require("wibox")

local setmetatable = setmetatable

local dnd = { mt = {} }

local function toggle(self)
	self.notifications = not self.notifications
	if self.notifications then
		self.icon.image = self.available_icons.on
	else
		self.icon.image = self.available_icons.off
	end

	self.tooltip:set_text(string.format("Do Not Disturb: %s", self.notifications and "off" or "on"))
end

function dnd.new(args)
	args = args or {}

	local icon_size = 18
	local icons = {
		on = beautiful.lookup_icon_and_load("notification-symbolic", icon_size),
		off = beautiful.lookup_icon_and_load("notification-disabled-symbolic", icon_size),
	}

	local icon = wibox.widget({
		image = icons.on,
		forced_width = icon_size,
		forced_height = icon_size,
		widget = wibox.widget.imagebox,
	})

	local self = wibox.layout.fixed.horizontal(wibox.container.place(icon))

	self.icon = icon
	self.available_icons = icons

	self:buttons({
		button({}, 1, function()
			toggle(self)
		end),
	})

	self.notifications = true
	self.tooltip = awful.tooltip({ objects = { self } })
	self.tooltip:set_text(string.format("Do Not Disturb: %s", self.notifications and "off" or "on"))

	return self
end

local _instance = nil

function dnd.mt:__call(...)
	if _instance == nil then
		_instance = self.new(...)
	end

	return _instance
end

return setmetatable(dnd, dnd.mt)
