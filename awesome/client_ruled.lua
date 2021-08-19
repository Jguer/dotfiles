local awful = require("awful")
local ruled = require("ruled")

local modkey = "Mod4"

function ClientMouseBindings()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end

function ClientKeybindings()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, {
			description = "toggle fullscreen",
			group = "client",
		}),
		awful.key({ modkey }, "c", function(c)
			c:kill()
		end, { description = "close", group = "client" }),
		awful.key({ modkey, "Shift" }, "Left", function(c)
			local i = awful.tag.selected(client.focus.screen).index
			local tag = awful.tag.gettags(client.focus.screen)[i - 1]
			if tag then
				c:tags({ tag })
				awful.tag.viewprev()
			end
		end, {
			description = "move to previous tag",
			group = "client",
		}),
		awful.key({ modkey, "Shift" }, "Right", function(c)
			local i = awful.tag.selected(client.focus.screen).index
			local tag = awful.tag.gettags(client.focus.screen)[i + 1]
			if tag then
				c:tags({ tag })
				awful.tag.viewnext()
			end
		end, {
			description = "move to next tag",
			group = "client",
		}),
		awful.key(
			{ modkey, "Control" },
			"space",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		),
		awful.key({ modkey, "Control" }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, {
			description = "move to master",
			group = "client",
		}),
		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, {
			description = "move to screen",
			group = "client",
		}),
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, {
			description = "toggle keep on top",
			group = "client",
		}),
		awful.key({ modkey }, "n", function(c)
			c.minimized = true
		end, { description = "minimize", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, {
			description = "(un)maximize",
			group = "client",
		}),
		awful.key({ modkey, "Control" }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, {
			description = "(un)maximize vertically",
			group = "client",
		}),
		awful.key({ modkey, "Shift" }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, {
			description = "(un)maximize horizontally",
			group = "client",
		}),
	})
end

function ClientRules()
	-- @DOC_GLOBAL_RULE@
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.focused,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	-- @DOC_FLOATING_RULE@
	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	})

	ruled.client.append_rule({
		id = "pip",
		rule_any = {
			name = {
				"Picture in picture",
				"Picture-in-Picture",
			},
		},
		properties = { sticky = true, floating = true },
	})
end
