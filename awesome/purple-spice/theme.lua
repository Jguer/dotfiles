-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local util = require("awful.util")
local gears = require("gears")
local gfs = require("gears.filesystem")

local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local theme = {}
local themes_path = gfs.get_configuration_dir() .. "purple-spice/"

theme.themes_path = themes_path

theme.panel_height = dpi(28)

theme.font = "sans bold " .. dpi(11)
theme.hotkeys_font = "monospace " .. dpi(11)
theme.hotkeys_description_font = "sans " .. dpi(11)

theme.bg_normal = xrdb.background
theme.wibar_bg = xrdb.background

-- Normal
theme.border_normal = xrdb.color4
theme.fg_normal = xrdb.foreground
theme.hotkeys_modifiers_fg = xrdb.color3
theme.snap_fg = theme.bg_focus

-- Focus
theme.bg_focus = theme.bg_normal
theme.fg_focus = xrdb.color3
theme.border_focus = theme.fg_focus

-- Urgent
theme.bg_urgent = theme.bg_normal
theme.fg_urgent = xrdb.color5

-- Minimized
theme.bg_minimize = xrdb.color6
theme.fg_minimize = xrdb.color6

-- Marked
theme.border_marked = xrdb.color5
theme.hotkeys_border_color = xrdb.color3

-- Spacings
theme.calendar_normal_border_width = dpi(1)
theme.calendar_weekday_border_width = dpi(1)
theme.calendar_weekday_border_color = xrdb.color2
theme.border_width = dpi(3)
theme.useless_gap = dpi(3)
theme.systray_icon_spacing = dpi(3)

-- taglist {{{
theme.taglist_bg_focus = theme.fg_focus
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_bg_occupied = xrdb.color4
theme.taglist_bg_urgent = theme.fg_urgent
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

-- Widgets {{{
theme.widget = {
    bg = xrdb.foreground,
    fg = xrdb.foreground,
    focus = xrdb.color3,
    charging = xrdb.color2,
    on = xrdb.color2,
    off = xrdb.color1
}
-- }}}

theme.wicons = {
    brightness = themes_path ..
        "gtk-icons/status/symbolic/display-brightness-high-symbolic.svg",
    battery = themes_path ..
        "gtk-icons/status/symbolic/battery-full-symbolic.svg",
    keyboard = themes_path ..
        "gtk-icons/status/symbolic/capslock-enabled-symbolic.svg",
    systray = themes_path ..
        "gtk-icons/status/symbolic/notification-symbolic.svg"
}

-- Notification {{{
theme.notification_shape = gears.shape.rounded_rect
theme.notification_border_color = xrdb.color10
theme.notification_bg = xrdb.background
theme.notification_fg = xrdb.foreground
theme.notification_font = theme.font
theme.notification_crit_bg = xrdb.color3
theme.notification_crit_fg = xrdb.color0
theme.notification_border_width = dpi(0)
theme.notification_border_radius = dpi(3)
theme.notification_icon_size = dpi(60)
theme.notification_margin = dpi(15)
theme.notification_opacity = 1
theme.notification_padding = dpi(20)
theme.notification_spacing = dpi(10)

--- }}}

theme.hotkeys_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 2)
end
theme.tooltip_align = "bottom"
theme.tooltip_border_width = dpi(0)

-- Title Bar {{{
theme.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path ..
                                            "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path ..
                                           "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive =
    themes_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive =
    themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active =
    themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active =
    themes_path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive =
    themes_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive =
    themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active =
    themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active =
    themes_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive =
    themes_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive =
    themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active =
    themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active =
    themes_path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive =
    themes_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive =
    themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active =
    themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active =
    themes_path .. "titlebar/maximized_focus_active.png"
-- }}}

-- Layout {{{
theme.layout_fairh = themes_path .. "layouts/fair.svg"
theme.layout_fairv = themes_path .. "layouts/fair.svg"
theme.layout_floating = themes_path .. "layouts/floating.svg"
theme.layout_magnifier = themes_path .. "layouts/magnifier.svg"
theme.layout_max = themes_path .. "layouts/max.svg"
theme.layout_fullscreen = themes_path .. "layouts/fullscreen.svg"
theme.layout_tilebottom = themes_path .. "layouts/tilebottom.svg"
theme.layout_tileleft = themes_path .. "layouts/tileleft.svg"
theme.layout_tile = themes_path .. "layouts/tile.svg"
theme.layout_tiletop = themes_path .. "layouts/tiletop.svg"
theme.layout_spiral = themes_path .. "layouts/spiral.svg"
theme.layout_dwindle = themes_path .. "layouts/spiral.svg"
theme.layout_cornernw = themes_path .. "layouts/cornernw.svg"
theme.layout_cornerne = themes_path .. "layouts/cornerne.svg"
theme.layout_cornersw = themes_path .. "layouts/cornersw.svg"
theme.layout_cornerse = themes_path .. "layouts/cornerse.svg"
theme_assets.recolor_layout(theme, xrdb.foreground)
-- }}}

theme.wallpaper = themes_path .. "wallpaper.png"
theme.set_wallpaper = function(s)
    if util.file_readable(theme.wallpaper) then
        gears.wallpaper.maximized(theme.wallpaper, s, true)
    else
        gears.wallpaper.set(theme.bg_normal)
    end
end

theme.icon = function(utf, color)
    return string.format("<span font='Ionicons 12' color='%s'>%s</span>", color,
                         utf)
end

return theme
