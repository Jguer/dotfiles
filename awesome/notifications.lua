-- Heavily inspired by javacafe's dotfiles (https://github.com/JavaCafe01/dotfiles/blob/master/.config/awesome/ui/notifs/init.lua)
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local gears_debug = require("gears.debug")
local ruled = require("ruled")
local awful = require("awful")

local icon_size = dpi(48)

naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"

ruled.notification.connect_signal("request::rules", function()
	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.focused,
			implicit_timeout = 5,
			icon_size = icon_size,
		},
	})

	ruled.notification.append_rule({
		rule = { urgency = "critical" },
		properties = { border_color = beautiful.fg_urgent },
	})

	ruled.notification.append_rule({
		rule = { urgency = "critical", app_name = "Brave" },
		properties = { ignore = true },
	})
end)

naughty.connect_signal("request::icon", function(n, context, hints)
	if context ~= "app_icon" then
		return
	end

	local path = beautiful.lookup_icon(hints.app_icon, icon_size)
		or beautiful.lookup_icon(hints.app_icon:lower(), icon_size)

	if path then
		n.icon = path
	end
end)

naughty.connect_signal("request::display", function(n)
	local icon = n.icon or beautiful.lookup_icon_and_load("dialog-information-symbolic", icon_size)

	naughty.layout.box({
		notification = n,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 5)
		end,
		type = "notification",
		minimum_width = 100,
		border_width = dpi(1),
		border_color = n.border_color,
		widget_template = {
			{
				{
					{
						{
							widget = wibox.widget.imagebox,
							image = icon,
							resize = true,
							valign = "center",
							halign = "center",
							clip_shape = function(cr, w, h)
								gears.shape.rounded_rect(cr, w, h, 8)
							end,
						},
						widget = wibox.container.constraint,
						height = dpi(48),
						width = dpi(48),
					},
					{
						{
							{
								widget = wibox.widget.textbox,
								markup = n.title or n.app_name,
								align = "left",
								valign = "center",
								ellipsize = "end",
							},
							{
								widget = wibox.widget.textbox,
								text = n.message,
								ellipsize = "end",
							},
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.container.margin,
						left = dpi(8),
					},
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.margin,
				left = dpi(15),
				right = dpi(15),
				top = dpi(8),
				bottom = dpi(8),
			},
			widget = wibox.container.constraint,
			width = dpi(480),
			height = dpi(120),
		},
	})
end)
