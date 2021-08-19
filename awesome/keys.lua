-- vim:fdm=marker foldlevel=2 tabstop=2 shiftwidth=2
-- luacheck: globals client awesome root
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys = { mouse = {}, keys = {} }
local hotkeys_popup = require("awful.hotkeys_popup").widget
local pulse = require("vex.pipewire")
local light = require("vex.brightness")

local altkey = "Mod1"
local modkey = "Mod4"

function hotkeys:init()
	awful.mouse.append_global_mousebindings({
		awful.button({}, 4, awful.tag.viewprev),
		awful.button({}, 5, awful.tag.viewnext),
	})

	-- General Awesome keys
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
		awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
		awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
		awful.key({ modkey }, "Return", function()
			awful.spawn("kitty")
		end, {
			description = "open a terminal",
			group = "launcher",
		}),
	})

	-- Tags related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
		awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
		awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
	})

	-- Focus related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, "l", function()
			awful.client.focus.global_bydirection("right")
		end, {
			description = "focus right",
			group = "client",
		}),
		awful.key({ modkey }, "h", function()
			awful.client.focus.global_bydirection("left")
		end, {
			description = "focus left",
			group = "client",
		}),
		awful.key({ modkey }, "k", function()
			awful.client.focus.global_bydirection("up")
		end, {
			description = "focus up",
			group = "client",
		}),
		awful.key({ modkey }, "j", function()
			awful.client.focus.global_bydirection("down")
		end, {
			description = "focus down",
			group = "client",
		}),
		awful.key({ modkey, "Control" }, "h", function()
			awful.screen.focus_bydirection("left")
		end, {
			description = "focus the next screen",
			group = "screen",
		}),
		awful.key({ modkey, "Control" }, "l", function()
			awful.screen.focus_bydirection("right")
		end, {
			description = "focus the previous screen",
			group = "screen",
		}),
		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:activate({ raise = true, context = "key.unminimize" })
			end
		end, {
			description = "restore minimized",
			group = "client",
		}),
	})

	-- Layout related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, {
			description = "swap with next client by index",
			group = "client",
		}),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, {
			description = "swap with previous client by index",
			group = "client",
		}),
		awful.key(
			{ modkey },
			"u",
			awful.client.urgent.jumpto,
			{ description = "jump to urgent client", group = "client" }
		),
		awful.key({ modkey, "Shift" }, "l", function()
			awful.tag.incmwfact(0.05)
		end, {
			description = "increase master width factor",
			group = "layout",
		}),
		awful.key({ modkey, "Shift" }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, {
			description = "decrease master width factor",
			group = "layout",
		}),
		awful.key({ modkey }, "space", function()
			awful.layout.inc(1)
		end, {
			description = "select next",
			group = "layout",
		}),
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(-1)
		end, {
			description = "select previous",
			group = "layout",
		}),
	})

	-- Application related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({}, "XF86AudioRaiseVolume", pulse.volume_up, { description = "increase volume", group = "audio" }),
		awful.key({ altkey }, "Up", pulse.volume_up, {
			description = "increase volume",
			group = "audio",
		}),
		awful.key({}, "XF86AudioLowerVolume", pulse.volume_down, { description = "decrease volume", group = "audio" }),
		awful.key({ altkey }, "Down", pulse.volume_down, {
			description = "decrease volume",
			group = "audio",
		}),
		awful.key({}, "XF86AudioMute", pulse.toggle_muted, { description = "toggle volume", group = "audio" }),
		awful.key({ altkey }, "m", pulse.toggle_muted, {
			description = "toggle volume",
			group = "audio",
		}),
		awful.key({}, "XF86AudioMicMute", pulse.toggle_muted_mic, { description = "toggle mic", group = "audio" }),
		awful.key({}, "XF86AudioPlay", function()
			awful.spawn("playerctl play-pause", false)
		end, {
			description = "Play media",
			group = "audio",
		}),
		awful.key({}, "XF86AudioPrev", function()
			awful.spawn("playerctl previous", false)
		end, {
			description = "Previous media",
			group = "audio",
		}),
		awful.key({}, "XF86AudioNext", function()
			awful.spawn("playerctl next", false)
		end, {
			description = "Next media",
			group = "audio",
		}),
		awful.key({ altkey }, "Home", function()
			awful.spawn("playerctl play-pause", false)
		end, {
			description = "Play media",
			group = "audio",
		}),
		awful.key({ altkey }, "Insert", function()
			awful.spawn("playerctl previous", false)
		end, {
			description = "Previous media",
			group = "audio",
		}),
		awful.key({ altkey }, "Prior", function()
			awful.spawn("playerctl next", false)
		end, {
			description = "Next media",
			group = "audio",
		}),
		awful.key({ modkey }, "Print", function()
			awful.spawn("flameshot gui")
		end, {
			description = "screenshot",
			group = "applications",
		}),
		awful.key({ modkey, "Shift" }, "c", function()
			awful.spawn("xkill")
		end, {
			description = "xkill",
			group = "applications",
		}),
		awful.key({}, "XF86MonBrightnessUp", function()
			light().set_brightness(5)
		end, {
			description = "Increase brightness by 5%",
			group = "screen",
		}),
		awful.key({}, "XF86MonBrightnessDown", function()
			light().set_brightness(-5)
		end, {
			description = "Decrease brightness by 5%",
			group = "screen",
		}),
		awful.key({ modkey }, "q", function()
			awful.spawn("brave")
		end, {
			description = "brave",
			group = "applications",
		}),
		awful.key({ altkey }, "e", function()
			awful.spawn("rofi-power " .. beautiful.theme_path .. "rofi.rasi")
		end, {
			description = "end session",
			group = "launcher",
		}),
		awful.key({ altkey }, "q", function()
			awful.spawn("rofi-pass " .. beautiful.theme_path .. "rofi.rasi")
		end, {
			description = "show rofi pass",
			group = "applications",
		}),
		awful.key({ modkey }, "x", function()
			awful.spawn(
				"rofi -matching fuzzy -combi-modi window,drun,ssh -theme "
					.. beautiful.theme_path
					.. "rofi.rasi"
					.. " -show combi"
			)
		end, {
			description = "show rofi combi",
			group = "launcher",
		}),
		awful.key({ modkey }, "z", function()
			awful.spawn(
				"rofi -combi-modi window,drun,ssh -theme " .. beautiful.theme_path .. "rofi.rasi" .. " -show window"
			)
		end, {
			description = "show rofi window",
			group = "launcher",
		}),
		awful.key({ modkey }, "e", function()
			awful.spawn("lockscreen " .. beautiful.wallpaper)
		end, {
			description = "lock screen",
			group = "applications",
		}),
	})

	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			keygroup = "numrow",
			description = "only view tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					tag:view_only()
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			keygroup = "numrow",
			description = "toggle tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			keygroup = "numrow",
			description = "move focused client to tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control", "Shift" },
			keygroup = "numrow",
			description = "toggle focused client on tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey },
			keygroup = "numpad",
			description = "select layout directly",
			group = "layout",
			on_press = function(index)
				local t = awful.screen.focused().selected_tag
				if t then
					t.layout = t.layouts[index] or t.layout
				end
			end,
		}),
	})
end
-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys
