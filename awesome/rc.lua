pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

require("awful.hotkeys_popup.keys")

require("awful.autofocus")

local hostname = io.lines("/proc/sys/kernel/hostname")()

-- Error handling on startup
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

beautiful.init(gears.filesystem.get_configuration_dir() .. "tokyo-night/theme.lua")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.fair,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.floating,
	})
end)

require("notifications")

-- Wibar
local widgets = require("widgets") -- load file with hotkeys configuration
widgets:init(hostname)

-- HotKeys
local hotkeys = require("keys") -- load file with hotkeys configuration
hotkeys:init()

-- Rules
require("client_ruled")

client.connect_signal("request::default_mousebindings", ClientMouseBindings)

client.connect_signal("request::default_keybindings", ClientKeybindings)

ruled.client.connect_signal("request::rules", ClientRules)

-- {{{ TitleBar
-- Signal function to execute when a new client appears.

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{
			-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			-- Middle
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			-- Right
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)
-- }}}

-- Signals
local signals = require("signals")
signals:init()

-- Autostart Applications {{{
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		local findme = cmd
		local firstspace = cmd:find(" ")
		if firstspace then
			findme = cmd:sub(0, firstspace - 1)
		end
		awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd), false)
	end
end

local autorun = {}
autorun["all"] = {
	"xss-lock -- lockscreen " .. beautiful.wallpaper,
	"numlockx",
	"nm-applet",
	"unclutter -noevents -idle 2 -jitter 1 -root",
	"picom --experimental-backends",
	"redshift-gtk -l 38.72:-9.15 -t 6500:3400",
}

autorun["laptop"] = { "blueman-applet" }

run_once(autorun["all"])
run_once(autorun[hostname] or autorun["laptop"])

-- }}}
