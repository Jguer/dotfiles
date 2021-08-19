-- vim:fdm=marker foldlevel=0 tabstop=2 shiftwidth=2
-- luacheck: globals client awesome screen
local gears = require("gears")
local wibox = require("wibox")
local pulse = require("vex.pipewire")
local wtime = require("vex.timewidget")
local wkeyboard = require("vex.keyboard")
local beautiful = require("beautiful")
local awful = require("awful")
local wsystray = require("vex.systraypopup")
local power = require("vex.power_widget")
local dnd = require("vex.dnd")

local widgets = {}

-- Local Functions {{{
local taglist_buttons = {
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ "Mod4" }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ "Mod4" }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end),
}

-- @TASKLIST_BUTTON@
local tasklist_buttons = {
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end),
}

-- }}}

local function right_widgets(hostname, s)
	local right = {
		-- Right widgets
		layout = wibox.layout.fixed.horizontal,
		wsystray(),
		dnd(),
		wkeyboard(),
		wibox.container.margin(power, 0, 0, 4, 4),
		wibox.container.margin(pulse, 0, 0, 4, 4),
	}

	if not string.match(hostname, "atreides") then
		local wbrightness = require("vex.brightness")
		right = gears.table.join(right, { wbrightness(30) })
	end

	s.layoutbox = wibox.container.margin(awful.widget.layoutbox(s), 0, 2, 2, 4)
	s.layoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	right = gears.table.join(right, {
		wtime(),
		s.layoutbox,
		spacing = 10,
		layout = wibox.layout.fixed.horizontal,
	})

	return right
end

function widgets:init(hostname)
	-- @DOC_WALLPAPER@
	screen.connect_signal("request::wallpaper", function(s)
		-- Wallpaper
		if beautiful.wallpaper then
			local wallpaper = beautiful.wallpaper
			-- If wallpaper is a function, call it with the screen
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
	end)

	screen.connect_signal("request::desktop_decoration", function(s)
		-- Each screen has its own tag table.
		awful.tag({ " ", " ", " ", " ", " ", " ", " " }, s, awful.layout.layouts[1])

		s.taglist = awful.widget.taglist({
			screen = s,
			filter = awful.widget.taglist.filter.all,
			buttons = taglist_buttons,
			layout = { spacing = 4, layout = wibox.layout.fixed.horizontal },
			widget_template = {
				{
					wibox.widget.base.make_widget(),
					forced_height = 5,
					forced_width = 40,
					id = "background_role",
					widget = wibox.container.background,
				},
				{
					{ id = "text_role", widget = wibox.widget.textbox },
					-- margins = 5,
					left = 10,
					right = 10,
					top = -5,
					widget = wibox.container.margin,
				},
				nil,
				layout = wibox.layout.align.vertical,
			},
		})

		s.tasklist = awful.widget.tasklist({
			screen = s,
			filter = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons,
			layout = {
				spacing_widget = {
					{
						forced_width = 5,
						forced_height = 5,
						thickness = 0,
						color = beautiful.tasklist_separator,
						widget = wibox.widget.separator,
					},
					valign = "center",
					halign = "center",
					widget = wibox.container.place,
				},
				spacing = 10,
				layout = wibox.layout.fixed.horizontal,
			},
			widget_template = {
				{
					wibox.widget.base.make_widget(),
					forced_height = 4,
					id = "background_role",
					widget = wibox.container.background,
				},
				{
					{ id = "clienticon", widget = awful.widget.clienticon },
					left = 4,
					bottom = 0,
					widget = wibox.container.margin,
				},
				nil,
				create_callback = function(self, c, index, objects) -- luacheck: no unused args
					self:get_children_by_id("clienticon")[1].client = c
				end,
				layout = wibox.layout.align.vertical,
			},
		})

		s.wibox = awful.wibar({ position = "top", screen = s })

		-- Add widgets to the wibox
		s.wibox:setup({
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				{
					s.tasklist,
					left = 10,
					right = 10,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			{ s.taglist, layout = wibox.layout.fixed.horizontal },
			right_widgets(hostname, s),
		})
	end)
end

return widgets
