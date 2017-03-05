-- ~/.awesome/themes/Gruvbox dark, hard/theme.lua
-- awesome wm theme
-- Base16 Gruvbox dark, hard by Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
-- template by Luke Jones @luke-nukem

--{{{ Main
local awful = require("awful")
awful.util  = require("awful.util")

theme = {}

home   = os.getenv("HOME")
config = awful.util.getdir("config")
shared = "/usr/share/awesome"

if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared = "/usr/share/local/awesome"
end

sharedicons  = shared .. "/icons"
sharedthemes = shared .. "/themes"
themes       = config .. "/themes"
themename    = "/gruvbox2"

if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
    themes = sharedthemes
end

themedir         = themes .. themename
theme.icon_theme = "vimix-dark"
theme.font       = "Noto Sans UI 10"
theme.wallpaper  = themedir .. "/background.png"
--}}}


-- {{{ Colors
theme.fg_normal   = "#ebdbb2"
theme.fg_focus    = "#458588"
theme.fg_urgent   = "#3c3836"
theme.fg_minimize = "#8ec07c"

theme.bg_normal   = "#3c3836"
theme.bg_focus    = "#3c3836"
theme.bg_urgent   = "#fabd2f"
theme.bg_minimize = "#3c3836"
-- }}}

-- {{{ Borders
theme.border_width  = 2
theme.border_normal = "#282828"
theme.border_focus  = theme.fg_focus
theme.border_marked = "#fabd2f"
-- }}}

-- {{{ Systray
theme.systray_icon_spacing = 1
theme.bg_systray           = "#076678"
-- }}}

-- {{{ Taglist
theme.taglist_fg_focus      = theme.fg_focus
theme.taglist_bg_focus      = theme.bg_normal
theme.taglist_squares_sel   = themedir .. "/taglist/squaref.png"
theme.taglist_squares_unsel = themedir .. "/taglist/square.png"
-- }}}

-- {{{ Tasklist
theme.tasklist_disable_icon = true
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_focus = theme.fg_focus
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Snaping
theme.snap_bg         = "#d79921"
theme.snapborderwidth = 3
-- }}}

-- {{{ Menu
theme.menu_height = 20
theme.menu_width  = 160
theme.menu_submenu_icon = themedir .. "/submenu.png"
theme.menu_fg_normal = theme.fg_normal
theme.menu_fg_focus = theme.fg_focus
theme.menu_bg_normal = theme.bg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_border_color = theme.bg_focus
-- }}}

-- {{{ Icons / Misc.
theme.layout_fairh      = themedir .. "/layouts/fairh.png"
theme.layout_fairv      = themedir .. "/layouts/fairv.png"
theme.layout_floating   = themedir .. "/layouts/floating.png"
theme.layout_magnifier  = themedir .. "/layouts/magnifier.png"
theme.layout_max        = themedir .. "/layouts/max.png"
theme.layout_fullscreen = themedir .. "/layouts/fullscreen.png"
theme.layout_tilebottom = themedir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = themedir .. "/layouts/tileleft.png"
theme.layout_tile       = themedir .. "/layouts/tile.png"
theme.layout_tiletop    = themedir .. "/layouts/tiletop.png"
theme.layout_spiral     = themedir .. "/layouts/spiral.png"
theme.layout_dwindle    = themedir .. "/layouts/dwindle.png"
theme.awesome_icon      = themedir .. "/awesome.png"
-- }}}

-- {{{ Separators
theme.arrow0 = themedir .. "/arrows/0.png"
theme.arrow1 = themedir .. "/arrows/1.png"
theme.arrow2 = themedir .. "/arrows/2.png"
-- }}}

return theme
