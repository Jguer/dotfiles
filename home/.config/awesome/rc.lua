local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Custom
local vicious    = require("vicious")
local scratchdrop = require("scratchdrop")
local pulseaudio = require("pulseaudio")
local backlight  = require("backlight")
local xrandr     = require("xrandr")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local sloppyfocus = true

-- {{{ Error handling
-- @DOC_ERROR_HANDLING@
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- @DOC_LOAD_THEME@
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/ngruvbox/theme.lua")

-- @DOC_DEFAULT_APPLICATIONS@
-- This is used later as the default terminal and editor to run.
terminal = "termite"
lock_cmd = "i3lock -t -c 282828 -i " .. beautiful.wallpaper
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- @DOC_LAYOUT@
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.magnifier,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.container.background(awful.widget.textclock("%F %H:%M"), "#076678")

--{{ Brightness Widget }} --
backlight_text = wibox.container.background(wibox.widget({
    text   = backlight.Info(),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}), "#076678")

--{{ Audio Widget }} --
volumewidget = wibox.widget({
    text   = pulseaudio.volume_info(),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
})

volumetimer = timer({ timeout = 31 })
volumetimer:add_signal("timeout", function() volumewidget.text = pulseaudio.volume_info() end)
volumetimer:start()

backlight_text:buttons(gears.table.join(
  awful.button({ }, 4, function() backlight.Change("+2%"); backlight_text.text = backlight.Info() end),
  awful.button({ }, 5, function() backlight.Change("-2%"); backlight_text.text = backlight.Info() end)
))

volumewidget:buttons(gears.table.join(
  awful.button({ }, 2, function() pulseaudio.volume_mute(); volumewidget.text = pulseaudio.volume_info() end),
  awful.button({ }, 3, function() awful.util.spawn("pavucontrol") end),
  awful.button({ }, 4, function() pulseaudio.volume_change("+3db"); volumewidget.text = pulseaudio.volume_info() end),
  awful.button({ }, 5, function() pulseaudio.volume_change("-3db"); volumewidget.text = pulseaudio.volume_info() end)
))

vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.mem)
vicious.cache(vicious.widgets.bat)

--{{ Battery Widget }} --
battext = wibox.widget.textbox()
vicious.register( battext, vicious.widgets.bat, '$1 Bat: $2% ($3) ', 61, "BAT0" )
batwidget = wibox.container.background(battext, "#3c3836")

--{{---| CPU / sensors widget |-----------
cputext = wibox.widget.textbox()
vicious.register(cputext, vicious.widgets.cpu,
'CPU: $2% ', 7)
cpuwidget = wibox.container.background(cputext, "#076678")

--{{--| MEM widget |-----------------
memtext = wibox.widget.textbox()
vicious.register(memtext, vicious.widgets.mem, 'RAM: $2MB ', 7)
memwidget = wibox.container.background(memtext, "#3c3836")

-- Create a wibox for each screen and add it
-- @TAGLIST_BUTTON@
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

-- @TASKLIST_BUTTON@
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- @DOC_WALLPAPER@
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- @DOC_FOR_EACH_SCREEN@
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({'⬤', '⬤','⬤', '⬤', '⬤', '⬤'}, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })
    -- @DOC_SETUP_WIDGETS@
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mykeyboardlayout,
            backlight_text,
            volumewidget,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
-- @DOC_ROOT_BUTTONS@
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
-- @DOC_GLOBAL_KEYBINDINGS@
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- Layout manipulation
    awful.key({ modkey, }, "v", function () sloppyfocus = not sloppyfocus end,
              {description = "toggles sloppyfocus", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey, "Control" }, "n", function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),
    -- Applications
    awful.key({ modkey, }, "x", function () awful.spawn("rofi -combi-modi window,drun -show combi -modi combi") end,
              {description = "launch rofi", group = "applications"}),
    awful.key({ modkey, }, "q", function() awful.spawn("bash -c 'cd ~/Projects/lulogout/ && lua ./lulogout'") end),
    awful.key({ modkey, }, "z", function () scratchdrop("termite", "bottom", "right", 0.5, 0.4, true) end,
              {description = "launch scratchdrop", group = "applications"}),
    awful.key({ modkey, }, "e", function() awful.spawn(lock_cmd) end,
              {description = "Lock Screen", group = "applications"}),
    awful.key({ modkey, }, "F1", function() awful.spawn(lock_cmd) end,
              {description = "Lock Screen", group = "applications"}),
    awful.key({ }, "Print", function () awful.spawn("scrot -e 'mv $f ~/Desktop/ 2>/dev/null'") end,
              {description = "screenshot", group = "applications"}),
    -- Display
    awful.key({}, "XF86Display", function () xrandr.xrandr() end,
              {description = "cycles display setups", group = "system"}),
    awful.key({ modkey, }, "p", function () xrandr.xrandr() end,
              {description = "cycles display setups", group = "system"}),
    -- Audio
    awful.key({ modkey, "Shift"}, "p", function () pulseaudio.cycle_devices(); volumewidget.text = pulseaudio.volume_info() end,
              {description = "cycles audio setups", group = "system"}),
    awful.key({}, "XF86AudioMute", function() pulseaudio.volume_mute(); volumewidget.text = pulseaudio.volume_info() end),
    awful.key({}, "XF86AudioLowerVolume", function() pulseaudio.volume_change("-3db"); volumewidget.text = pulseaudio.volume_info() end),
    awful.key({}, "XF86AudioRaiseVolume", function() pulseaudio.volume_change("+3db"); volumewidget.text = pulseaudio.volume_info() end),
    -- Backlight
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("xbacklight +5%"); backlight_text.text = backlight.Info() end),
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("xbacklight -5%"); backlight_text.text = backlight.Info() end),
    -- Sound
    awful.key({}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end),
    awful.key({}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end),
    awful.key({}, "XF86AudioNext", function() awful.spawn("playerctl next") end)
)

-- @DOC_CLIENT_KEYBINDINGS@
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
        {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
        {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
        {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left", function (c)
        local i = awful.tag.selected(client.focus.screen).index
        local tag = awful.tag.gettags(client.focus.screen)[i - 1]
        if tag then
            c:tags({tag})
            awful.tag.viewprev()
        end
    end,
    {description = "move to previous tag", group = "client"}),
awful.key({ modkey, "Shift"   }, "Right", function (c)
    local i = awful.tag.selected(client.focus.screen).index
    local tag = awful.tag.gettags(client.focus.screen)[i + 1]
    if tag then
        c:tags({tag})
        awful.tag.viewnext()
    end
end,
{description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "n",
      function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "m",
      function (c)
          c.maximized = not c.maximized
          c:raise()
      end ,
      {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
      function (c)
          c.maximized_vertical = not c.maximized_vertical
          c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
      function (c)
          c.maximized_horizontal = not c.maximized_horizontal
          c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"})
  )

-- @DOC_NUMBER_KEYBINDINGS@
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- @DOC_CLIENT_BUTTONS@
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- @DOC_RULES@
awful.rules.rules = {
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     size_hints_honor = false,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- @DOC_FLOATING_RULE@
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "rofi",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},
    { rule = { class = "mpv" }, properties = { floating = true, ontop = true } },
    -- @DOC_DIALOG_RULE@
    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
-- @DOC_MANAGE_HOOK@
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- @DOC_TITLEBARS@
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and sloppyfocus
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- @DOC_BORDER@
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
