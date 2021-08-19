-- Heavily inspired by javacafe's dotfiles (https://github.com/JavaCafe01/dotfiles/blob/master/.config/awesome/ui/notifs/init.lua)
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local gears_debug = require("gears.debug")

local lgi = require("lgi")
local icon_theme = lgi.Gtk.IconTheme.get_default()
local IconLookupFlags = lgi.Gtk.IconLookupFlags

local icon_size = dpi(48)
local icon_flags = { IconLookupFlags.GENERIC_FALLBACK }

local function lookup_icon(name)
	return icon_theme:lookup_icon(name, icon_size, icon_flags)
end

naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.icon_size = icon_size

naughty.connect_signal("request::icon", function(n, context, hints)
	if context ~= "app_icon" then
		return
	end

	local path = lookup_icon(hints.app_icon) or lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

naughty.connect_signal("request::display", function(n)
	gears_debug.print_error(gears_debug.dump_return(n))

	naughty.layout.box({
		notification = n,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 5)
		end,
		type = "notification",
		minimum_width = 100,
		border_width = dpi(1),
		border_color = beautiful.bg_lighter,
		widget_template = {
			{
				{
					{
						{
							widget = wibox.widget.imagebox,
							image = n.icon,
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
