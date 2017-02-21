theme = {}

theme.font = "Noto Sans UI 10"

--{{{ Main
local awful = require("awful")
awful.util = require("awful.util")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.get_configuration_dir()
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
themes        = config .. "/themes"
themename     = "/hybrid"
if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
       themes = sharedthemes
end
themedir      = themes .. themename

theme.icon_theme = "Paper"
theme.font       = "Noto Sans UI 10"
theme.wallpaper  = themedir .. "/background.png"
--}}}

-- {{{ Colors
theme.fg_normal     = "#c5c8c6"
theme.fg_focus      = "#1d1f21"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#969896"
theme.bg_normal     = "#282a2e"
theme.bg_focus      = "#cc6666"
theme.bg_urgent     = "#f0c674"
theme.bg_minimize   = "#373b41"
-- }}}

-- {{{ Borders
theme.border_width  = "3"
theme.border_normal = "#1d1f21"
theme.border_focus  = theme.bg_focus
theme.border_marked = "#f0c674"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Menu
theme.menu_height = "5"
theme.menu_width  = "70"
theme.menu_fg_normal = theme.fg_normal
theme.menu_fg_focus = theme.fg_focus
theme.menu_bg_normal = theme.bg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_border_color = theme.bg_focus
-- }}}

-- {{{ Icons / Misc.
theme.layout_fairh = themedir .. "/layouts/fairhw.png"
theme.layout_fairv = themedir .. "/layouts/fairvw.png"
theme.layout_floating  = themedir .. "/layouts/floatingw.png"
theme.layout_magnifier = themedir .. "/layouts/magnifierw.png"
theme.layout_max = themedir .. "/layouts/maxw.png"
theme.layout_fullscreen = themedir .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = themedir .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = themedir .. "/layouts/tileleftw.png"
theme.layout_tile = themedir .. "/layouts/tilew.png"
theme.layout_tiletop = themedir .. "/layouts/tiletopw.png"
theme.layout_spiral  = themedir .. "/layouts/spiralw.png"
theme.layout_dwindle = themedir .. "/layouts/dwindlew.png"
theme.awesome_icon = themedir .. "/menu.png"
-- }}}

return theme
