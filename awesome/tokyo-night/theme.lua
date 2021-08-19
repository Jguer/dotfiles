-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local theme_assets = require("beautiful.theme_assets")

local xresources = require("beautiful.xresources")
local util = require("awful.util")
local gears = require("gears")
local gfs = require("gears.filesystem")
local gears_color = require("gears.color")
local lgi = require("lgi")

local recolor_image = gears_color.recolor_image
local icon_theme = lgi.Gtk.IconTheme.get_default()
local IconLookupFlags = lgi.Gtk.IconLookupFlags
local dpi = xresources.apply_dpi

local xrdb = xresources.get_current_theme()
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path .. "xresources/theme.lua")

local theme_path = gfs.get_configuration_dir() .. "tokyo-night/"

theme.theme_path = theme_path

theme.panel_height = dpi(28)

theme.font = "Inter bold " .. dpi(11)
theme.hotkeys_font = "monospace " .. dpi(11)
theme.hotkeys_description_font = "Inter " .. dpi(11)

theme.bg_normal = xrdb.background
theme.wibar_bg = xrdb.background

-- Normal
theme.border_color_normal = xrdb.color4
theme.border_color_active = xrdb.color2
theme.border_color_marked = xrdb.color10

theme.fg_normal = xrdb.foreground
theme.fg_darker = xrdb.color8
theme.hotkeys_modifiers_fg = xrdb.color2
theme.snap_fg = theme.bg_focus

-- Focus
theme.bg_focus = theme.bg_normal
theme.fg_focus = xrdb.color2
theme.border_focus = theme.fg_focus

-- Urgent
theme.bg_urgent = theme.bg_normal
theme.fg_urgent = xrdb.color5

-- Minimized
theme.bg_minimize = xrdb.color6
theme.fg_minimize = xrdb.color6

-- Marked
theme.border_marked = xrdb.color5
theme.hotkeys_border_color = xrdb.color2

-- Spacings
theme.border_width = dpi(3)
theme.useless_gap = dpi(3)
theme.systray_icon_spacing = dpi(2)

-- taglist {{{
theme.taglist_bg_focus = theme.fg_focus
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_bg_occupied = xrdb.color4
theme.taglist_bg_urgent = theme.fg_urgent
theme.taglist_bg_empty = xrdb.foreground
theme.taglist_separator = xrdb.color8
theme.taglist_spacing = dpi(4)
-- theme.taglist_bg_empty = xrdb.foreground
-- }}}

-- tasklist {{{
theme.tasklist_bg_urgent = theme.fg_urgent
theme.tasklist_bg_focus = theme.fg_focus
theme.tasklist_bg_normal = xrdb.color4
theme.tasklist_separator = xrdb.color8

-- }}}

-- Notification {{{
theme.notification_border_color = xrdb.color12
theme.notification_border_width = dpi(0)
theme.notification_border_radius = dpi(3)
theme.notification_margin = dpi(15)
theme.notification_opacity = 0.90
theme.notification_padding = dpi(20)
theme.notification_spacing = dpi(16)

--- }}}

theme.hotkeys_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 2)
end

theme.tooltip_align = "bottom"
theme.tooltip_shape = theme.hotkeys_shape
theme.tooltip_border_width = dpi(1)

theme = theme_assets.recolor_layout(theme, xrdb.foreground)
-- }}}

theme.wallpaper = theme_path .. "wallpaper.png"
theme.set_wallpaper = function(s)
	if util.file_readable(theme.wallpaper) then
		gears.wallpaper.maximized(theme.wallpaper, s, true)
	else
		gears.wallpaper.set(theme.bg_normal)
	end
end

theme.icon = function(utf, color)
	return string.format("<span font='Ionicons 12' color='%s'>%s</span>", color, utf)
end

theme.lookup_icon = function(name, icon_size)
	return icon_theme:lookup_icon(name, dpi(icon_size), { IconLookupFlags.GENERIC_FALLBACK })
end

theme.lookup_icon_and_load = function(name, icon_size)
	local icon = icon_theme:lookup_icon(name, dpi(icon_size), { IconLookupFlags.GENERIC_FALLBACK })

	if icon then
		return recolor_image(icon:load_surface(), xrdb.foreground)
	end

	return nil
end

return theme
