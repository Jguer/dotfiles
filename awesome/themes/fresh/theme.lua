---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "themes/fresh/"
local theme = {}

theme.font          = "Ubuntu Bold 9"

theme.bg_normal     = xrdb.background
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.bg_normal
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = xrdb.foreground
theme.fg_focus      = xrdb.color3
theme.fg_urgent     = xrdb.color1
theme.fg_minimize   = xrdb.color6

theme.border_width  = dpi(2)
theme.border_normal = xrdb.color12
theme.border_focus  = xrdb.color3
theme.border_marked = xrdb.color5

theme.taglist_fg_occupied = xrdb.color12
theme.tasklist_disable_icon = true
theme.notification_shape = gears.shape.rounded_rect

theme.useless_gap   = dpi(3)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."layouts/fairhw.png"
theme.layout_fairv = themes_path.."layouts/fairvw.png"
theme.layout_floating  = themes_path.."layouts/floatingw.png"
theme.layout_magnifier = themes_path.."layouts/magnifierw.png"
theme.layout_max = themes_path.."layouts/maxw.png"
theme.layout_fullscreen = themes_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."layouts/tileleftw.png"
theme.layout_tile = themes_path.."layouts/tilew.png"
theme.layout_tiletop = themes_path.."layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."layouts/spiralw.png"
theme.layout_dwindle = themes_path.."layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."layouts/cornernww.png"
theme.layout_cornerne = themes_path.."layouts/cornernew.png"
theme.layout_cornersw = themes_path.."layouts/cornersww.png"
theme.layout_cornerse = themes_path.."layouts/cornersew.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = Arc

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
