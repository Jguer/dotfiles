-- vim:fdm=marker foldlevel=2 tabstop=2 shiftwidth=2
-- luacheck: globals client awesome root
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys = {mouse = {}, keys = {}}
local xrandr = require("vex.xrandr")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local pulse = require("vex.pulse")
local light = require("vex.brightness")

local altkey = "Mod1"

-- change window focus by history
local function focus_to_previous()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
end

local function restore_client()
    local c = awful.client.restore()
    if c then
        client.focus = c
        c:raise()
    end
end

-- numeric keys function builders
local function tag_numkey(i, mod, action)
    return awful.key(mod, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then action(tag) end
    end)
end

local function client_numkey(i, mod, action)
    return awful.key(mod, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then action(tag) end
        end
    end)
end

local focus_switch_byd = function(dir)
    return function()
        awful.client.focus.global_bydirection(dir)
        -- if client.focus then client.focus:raise() end
    end
end

function hotkeys:init(args)
    local args = args or {}
    local modkey = args.modkey

    -- {{{ Global Mouse
    self.mouse.root = awful.util.table
                          .join( -- awful.button({ }, 3, function () mainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev))
    -- }}}

    -- {{{ Global Keys
    -- {{{ General
    self.keys.root = gears.table.join(awful.key({modkey}, "s",
                                                hotkeys_popup.show_help, {
        description = "show help",
        group = "awesome"
    }), awful.key({modkey}, "Left", awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
                                      awful.key({modkey}, "Right",
                                                awful.tag.viewnext, {
        description = "view next",
        group = "tag"
    }), awful.key({altkey}, "j", awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
                                      awful.key({altkey}, "k",
                                                awful.tag.viewnext, {
        description = "view next",
        group = "tag"
    }), awful.key({modkey}, "Escape", awful.tag.history.restore,
                  {description = "go back", group = "tag"}), -- Switch By ID
    -- awful.key({ modkey,           }, "j", focus_switch_byid(1),
    --   {description = "focus next by index", group = "client"}
    -- ),
    -- awful.key({ modkey,           }, "k", focus_switch_byid(-1),
    --   {description = "focus previous by index", group = "client"}
    -- ),
    awful.key({modkey}, "l", focus_switch_byd("right"),
              {description = "focus next by index", group = "client"}),
                                      awful.key({modkey}, "h",
                                                focus_switch_byd("left"), {
        description = "focus previous by index",
        group = "client"
    }), awful.key({modkey}, "k", focus_switch_byd("up"),
                  {description = "focus next by index", group = "client"}),
                                      awful.key({modkey}, "j",
                                                focus_switch_byd("down"), {
        description = "focus previous by index",
        group = "client"
    }), -- Layout manipulation
    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
                                      awful.key({modkey, "Shift"}, "k",
                                                function()
        awful.client.swap.byidx(-1)
    end, {description = "swap with previous client by index", group = "client"}),
                                      awful.key({modkey, "Control"}, "h",
                                                function()
        awful.screen.focus_bydirection("left")
    end, {description = "focus the next screen", group = "screen"}),
                                      awful.key({modkey, "Control"}, "l",
                                                function()
        awful.screen.focus_bydirection("right")
    end, {description = "focus the previous screen", group = "screen"}),
                                      awful.key({modkey}, "u",
                                                awful.client.urgent.jumpto, {
        description = "jump to urgent client",
        group = "client"
    }), awful.key({modkey}, "Tab", focus_to_previous,
                  {description = "go back", group = "client"}),
    -- Standard program
                                      awful.key({modkey, "Control"}, "r",
                                                awesome.restart, {
        description = "reload awesome",
        group = "awesome"
    }), awful.key({modkey, "Shift"}, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
                                      awful.key({altkey}, "l", function()
        awful.tag.incmwfact(0.05)
    end, {description = "increase master width factor", group = "layout"}),
                                      awful.key({altkey}, "h", function()
        awful.tag.incmwfact(-0.05)
    end, {description = "decrease master width factor", group = "layout"}),
                                      awful.key({modkey, "Shift"}, "h",
                                                function()
        awful.tag.incnmaster(1, nil, true)
    end, {
        description = "increase the number of master clients",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "l",
                  function() awful.tag.incnmaster(-1, nil, true) end, {
        description = "decrease the number of master clients",
        group = "layout"
    }), awful.key({modkey, "Control"}, "k",
                  function() awful.tag.incncol(1, nil, true) end, {
        description = "increase the number of columns",
        group = "layout"
    }), awful.key({modkey, "Control"}, "j",
                  function() awful.tag.incncol(-1, nil, true) end, {
        description = "decrease the number of columns",
        group = "layout"
    }), awful.key({modkey}, "space", function() awful.layout.inc(1) end,
                  {description = "select next", group = "layout"}),
                                      awful.key({modkey, "Shift"}, "space",
                                                function()
        awful.layout.inc(-1)
    end, {description = "select previous", group = "layout"}),
                                      awful.key({modkey, "Control"}, "n",
                                                restore_client, {
        description = "restore minimized",
        group = "client"
    }), -- Volume and Music
    awful.key({}, "XF86AudioRaiseVolume",
              function() pulse().set_volume("+2%") end,
              {description = "increase volume", group = "audio"}),
                                      awful.key({altkey}, "Up", function()
        pulse().set_volume("+2%")
    end, {description = "increase volume", group = "audio"}),
                                      awful.key({}, "XF86AudioLowerVolume",
                                                function()
        pulse().set_volume("-2%")
    end, {description = "decrease volume", group = "audio"}),
                                      awful.key({altkey}, "Down", function()
        pulse().set_volume("-2%")
    end, {description = "decrease volume", group = "audio"}),
                                      awful.key({}, "XF86AudioMute", function()
        pulse().toggle_mute()
    end, {description = "toggle volume", group = "audio"}),
                                      awful.key({altkey}, "m", function()
        pulse().toggle_mute()
    end, {description = "toggle volume", group = "audio"}),
                                      awful.key({}, "XF86AudioMicMute",
                                                function()
        pulse().toggle_mic()
    end, {description = "toggle mic", group = "audio"}),
                                      awful.key({}, "XF86AudioPlay", function()
        awful.spawn("playerctl play-pause", false)
    end, {description = "Play media", group = "audio"}),
                                      awful.key({}, "XF86AudioPrev", function()
        awful.spawn("playerctl previous", false)
    end, {description = "Previous media", group = "audio"}),
                                      awful.key({}, "XF86AudioNext", function()
        awful.spawn("playerctl next", false)
    end, {description = "Next media", group = "audio"}),
                                      awful.key({altkey}, "Home", function()
        awful.spawn("playerctl play-pause", false)
    end, {description = "Play media", group = "audio"}),
                                      awful.key({altkey}, "Insert", function()
        awful.spawn("playerctl previous", false)
    end, {description = "Previous media", group = "audio"}),
                                      awful.key({altkey}, "Prior", function()
        awful.spawn("playerctl next", false)
    end, {description = "Next media", group = "audio"}), -- Applications
    awful.key({modkey}, "Return", function() awful.spawn("kitty") end,
              {description = "open a terminal", group = "applications"}),
                                      awful.key({}, "Print", function()
        awful.spawn("screenshot")
    end, {description = "screenshot screen", group = "applications"}),
                                      awful.key({modkey}, "Print", function()
        awful.spawn("screenshot -s")
    end, {description = "screenshot window", group = "applications"}),
                                      awful.key({modkey, "Shift"}, "c",
                                                function()
        awful.spawn("xkill")
    end, {description = "xkill", group = "applications"}),
                                      awful.key({}, "XF86MonBrightnessUp", function()
       light().set_brightness(5)
    end, {description = "Increase brightness by 5%", group = "screen"}),
                                      awful.key({}, "XF86MonBrightnessDown", function()
       light().set_brightness(-5)
    end, {description = "Decrease brightness by 5%", group = "screen"}),
                                      awful.key({modkey}, "q", function()
        awful.spawn("firefox")
    end, {description = "firefox", group = "applications"}),
                                      awful.key({modkey}, "p",
                                                function() xrandr.xrandr() end,
                                                {
        description = "xrandr",
        group = "applications"
    }), awful.key({altkey}, "e", function()
        awful.spawn("rofi-power " .. beautiful.themes_path .. "rofi.rasi")
    end, {description = "end session", group = "applications"}),
                                      awful.key({modkey}, "x", function()
        awful.spawn("rofi -combi-modi window,drun,ssh -theme " ..
                        beautiful.themes_path .. "rofi.rasi" .. " -show combi")
    end, {description = "show rofi combi", group = "applications"}),
                                      awful.key({modkey}, "z", function()
        awful.spawn("rofi -combi-modi window,drun,ssh -theme " ..
                        beautiful.themes_path .. "rofi.rasi" .. " -show window")
    end, {description = "show rofi window", group = "applications"}),
                                      awful.key({modkey}, "e", function()
        awful.spawn("lockscreen " .. beautiful.wallpaper)
    end, {description = "lock screen", group = "applications"}))
    -- }}}

    -- {{{ Tags
    for i = 1, 9 do
        self.keys.root = awful.util.table.join(self.keys.root, tag_numkey(i, {
            modkey
        }, function(t) t:view_only() end), tag_numkey(i, {modkey, "Control"},
                                                      function(t)
            awful.tag.viewtoggle(t)
        end), client_numkey(i, {modkey, "Shift"},
                            function(t) client.focus:move_to_tag(t) end),
                                               client_numkey(i, {
            modkey, "Control", "Shift"
        }, function(t) client.focus:toggle_tag(t) end))
    end
    -- }}}
    -- }}}

    -- {{{ Client Mouse
    self.mouse.client = gears.table.join(
                            awful.button({}, 1, function(c)
            client.focus = c
            c:raise()
        end), awful.button({modkey}, 1, awful.mouse.client.move), awful.button(
                                {modkey}, 3, awful.mouse.client.resize))
    -- }}}

    -- {{{ Client Keys
    self.keys.client = gears.table.join(awful.key({modkey}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {description = "toggle fullscreen", group = "client"}),
                                        awful.key({altkey}, "u", function(c)
        local i = awful.tag.selected(client.focus.screen).index
        local tag = awful.tag.gettags(client.focus.screen)[i - 1]
        if tag then
            c:tags({tag})
            awful.tag.viewprev()
        end
    end, {description = "move to previous tag", group = "client"}),
                                        awful.key({modkey, "Shift"}, "Left",
                                                  function(c)
        local i = awful.tag.selected(client.focus.screen).index
        local tag = awful.tag.gettags(client.focus.screen)[i - 1]
        if tag then
            c:tags({tag})
            awful.tag.viewprev()
        end
    end, {description = "move to previous tag", group = "client"}),
                                        awful.key({altkey}, "i", function(c)
        local i = awful.tag.selected(client.focus.screen).index
        local tag = awful.tag.gettags(client.focus.screen)[i + 1]
        if tag then
            c:tags({tag})
            awful.tag.viewnext()
        end
    end, {description = "move to next tag", group = "client"}),

                                        awful.key({modkey, "Shift"}, "Right",
                                                  function(c)
        local i = awful.tag.selected(client.focus.screen).index
        local tag = awful.tag.gettags(client.focus.screen)[i + 1]
        if tag then
            c:tags({tag})
            awful.tag.viewnext()
        end
    end, {description = "move to next tag", group = "client"}),
                                        awful.key({modkey}, "c",
                                                  function(c) c:kill() end, {
        description = "close",
        group = "client"
    }), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle,
                  {description = "toggle floating", group = "client"}),
                                        awful.key({modkey, "Control"}, "Return",
                                                  function(c)
        c:swap(awful.client.getmaster())
    end, {description = "move to master", group = "client"}),
                                        awful.key({modkey}, "o", function(c)
        c:move_to_screen()
    end, {description = "move to screen", group = "client"}),
                                        awful.key({modkey}, "t", function(c)
        c.ontop = not c.ontop
    end, {description = "toggle keep on top", group = "client"}),
                                        awful.key({modkey}, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, {description = "minimize", group = "client"}),
                                        awful.key({modkey}, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {description = "(un)maximize", group = "client"}),
                                        awful.key({modkey, "Control"}, "m",
                                                  function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {description = "(un)maximize vertically", group = "client"}),
                                        awful.key({modkey, "Shift"}, "m",
                                                  function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {description = "(un)maximize horizontally", group = "client"}))
    -- }}}

    root.keys(self.keys.root)
    root.buttons(self.mouse.root)
end
-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
