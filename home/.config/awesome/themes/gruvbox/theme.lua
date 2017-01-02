-- gruvbox awesome theme
--
-- Copyright (C) 2016 Raphael McSinyx
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

theme = {}

theme.font = "Noto Sans UI 10"

theme.bg_normal = "#282828"
theme.bg_focus = "#3c3836"
theme.bg_urgent = theme.bg_normal
--theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#ebdbb2"
theme.fg_focus = theme.fg_normal
theme.fg_urgent = "#d3869b"
--theme.fg_minimize = "#ffffff"

theme.border_width = 2
theme.border_normal = "#3c3836"
theme.border_focus = "#b16286"
theme.border_marked = "#91231c"

-- There are other variable sets overriding the default one when defined,
-- the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

theme.titlebar_bg_focus = "#282828"

mythemedir = "~/.config/awesome/themes/gruvbox/"

-- Display the taglist squares
theme.taglist_squares_sel   = mythemedir .. "taglist/squaref.png"
theme.taglist_squares_unsel = mythemedir .. "taglist/square.png"

theme.tasklist_disable_icon = true

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = mythemedir .. "submenu.png"
theme.menu_height = 20
theme.menu_width  = 160

-- You can add as many variables as you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = mythemedir .. "titlebar/normal.png"
theme.titlebar_close_button_focus  = mythemedir .. "titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = mythemedir .. "titlebar/normal.png"
theme.titlebar_ontop_button_focus_inactive  = mythemedir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = mythemedir .. "titlebar/normal.png"
theme.titlebar_ontop_button_focus_active  = mythemedir .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = mythemedir .. "titlebar/normal.png"
theme.titlebar_sticky_button_focus_inactive  = mythemedir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = mythemedir .. "titlebar/normal.png"
theme.titlebar_sticky_button_focus_active  = mythemedir .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = mythemedir .. "titlebar/normal.png"
theme.titlebar_floating_button_focus_inactive  = mythemedir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = mythemedir .. "titlebar/normal.png"
theme.titlebar_floating_button_focus_active  = mythemedir .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = mythemedir .. "titlebar/normal.png"
theme.titlebar_maximized_button_focus_inactive  = mythemedir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = mythemedir .. "titlebar/normal.png"
theme.titlebar_maximized_button_focus_active  = mythemedir .. "titlebar/maximized_focus_active.png"

theme.wallpaper = mythemedir .. "background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = mythemedir .. "layouts/fairh.png"
theme.layout_fairv = mythemedir .. "layouts/fairv.png"
theme.layout_floating  = mythemedir .. "layouts/floating.png"
theme.layout_magnifier = mythemedir .. "layouts/magnifier.png"
theme.layout_max = mythemedir .. "layouts/max.png"
theme.layout_fullscreen = mythemedir .. "layouts/fullscreen.png"
theme.layout_tilebottom = mythemedir .. "layouts/tilebottom.png"
theme.layout_tileleft   = mythemedir .. "layouts/tileleft.png"
theme.layout_tile = mythemedir .. "layouts/tile.png"
theme.layout_tiletop = mythemedir .. "layouts/tiletop.png"
theme.layout_spiral  = mythemedir .. "layouts/spiral.png"
theme.layout_dwindle = mythemedir .. "layouts/dwindle.png"

theme.awesome_icon = mythemedir .. "awesome.png"

-- Define the icon theme for application icons. If not set then the icons from
-- /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Arrows
theme.arrow0 = mythemedir .. "arrows/0.png"
theme.arrow1 = mythemedir .. "arrows/1.png"
theme.arrow2 = mythemedir .. "arrows/2.png"
theme.arrow3 = mythemedir .. "arrows/3.png"
theme.arrow4 = mythemedir .. "arrows/4.png"
theme.arrow5 = mythemedir .. "arrows/5.png"
theme.arrow6 = mythemedir .. "arrows/6.png"
theme.arrow7 = mythemedir .. "arrows/7.png"

return theme
