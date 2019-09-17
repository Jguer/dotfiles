local setmetatable = setmetatable
local button = require("awful.button")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears_color = require("gears.color")
local recolor_image = gears_color.recolor_image

local brightness = {mt = {}}

local style = {width = 56, icon = beautiful.wicons.brightness}

-- local GET_BRIGHTNESS_CMD = "xbacklight -get"
local brightness_cmd = "light -G"

local function update_status(self)
    awful.spawn.with_line_callback(brightness_cmd, {
        stdout = function(line)
            local brightness_level = tonumber(string.format("%.0f", line))
            self.text:set_text(brightness_level .. "%")
        end,
        stderr = function() end
    })
end

function brightness.new(timeout)
    local icon = wibox.widget{
        image = recolor_image(style.icon, beautiful.widget.fg),
        resize = true,
        forced_width = 16,
        forced_height = 16,
        widget = wibox.widget.imagebox
    }

    local text = wibox.widget{
        text = "0%",
        align = "center",
        valign = "center",
        forced_width = 40,
        widget = wibox.widget.textbox
    }

    local layout = wibox.layout.fixed.horizontal(wibox.container.place(icon),
                                                 text)

    local widget = wibox.container.constraint(layout, "exact", style.width)
    local self = widget_base.make_widget(widget)
    self.icon = icon
    self.text = text

    self.set_brightness = function(step)
        if step < 0 then
            awful.spawn("light -U " .. -step, false)
        else
            awful.spawn("light -A " .. step, false)
        end
        update_status(self)
    end

    -- Mouse bindings
    self:buttons(gears.table.join(button({}, 4,
                                         function() self.set_brightness(2) end),
                                  button({}, 5,
                                         function() self.set_brightness(-2) end)))

    update_status(self)
    gears.timer{
        timeout = timeout,
        call_now = true,
        autostart = true,
        callback = function() update_status(self) end
    }
    return self
end

local _instance = nil

function brightness.mt:__call(...)
    if _instance == nil then _instance = self.new(...) end
    return _instance
end

return setmetatable(brightness, brightness.mt)
