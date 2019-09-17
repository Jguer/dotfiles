local setmetatable = setmetatable
local button = require("awful.button")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears_color = require("gears.color")
local recolor_image = gears_color.recolor_image
local naughty = require("naughty")

local battery = {mt = {}}
local notification

local style = {width = 56, icon = beautiful.wicons.battery}

local function show_battery_warning()
    naughty.notify{
        icon = recolor_image(style.icon, beautiful.widget.off),
        icon_size = 100,
        text = "I keep hearing about battery innovation, but it never makes it to my phone.",
        title = "Battery is dying",
        timeout = 5,
        hover_timeout = 0.5,
        width = 300
    }
end

local function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']], function(stdout, _, _, _)
        notification = naughty.notify{
            text = stdout,
            title = "Battery status",
            timeout = 5,
            hover_timeout = 0.5,
            width = 200
        }
    end)
end

local function update_status(self)
    awful.spawn.with_line_callback("acpi", {
        stdout = function(line)
            local _, status, charge_str, _ =
                string.match(line, "(.+): (%a+), (%d?%d%d)%%,? ?.*")
            local charge = tonumber(charge_str)

            if self.mode == true then
                self.text:set_text(charge .. "%")
            else
                local time_left = string.match(line, ".-(%d+:%d+)")

                self.text:set_text(time_left)
            end

            if status == "Charging" then
                self.icon.image = recolor_image(style.icon,
                                                beautiful.widget.charging)
            else
                if charge < 15 then
                    self.icon.image = recolor_image(style.icon,
                                                    beautiful.widget.off)
                    if status ~= "Charging" then
                        show_battery_warning()
                    end
                else
                    self.icon.image = recolor_image(style.icon,
                                                    beautiful.widget.fg)
                end
            end
        end,
        stderr = function() end
    })
end

-- @return A battery widget.
function battery.new(timeout)
    local icon = wibox.widget{
        image = recolor_image(style.icon, beautiful.widget.bg),
        resize = true,
        forced_width = 16,
        forced_height = 16,
        widget = wibox.widget.imagebox
    }

    local text = wibox.widget{
        text = "0%",
        align = "center",
        valign = "center",
        forced_width = 48,
        widget = wibox.widget.textbox
    }

    local layout = wibox.layout.fixed.horizontal(wibox.container.place(icon),
                                                 text)

    local widget = wibox.container.constraint(layout, "exact", style.width)
    local self = widget_base.make_widget(widget)
    self.icon = icon
    self.text = text
    self.mode = true

    -- Mouse bindings
    self:buttons(gears.table.join(button({}, 1, function()
        self.mode = not self.mode
        update_status(self)
    end)))

    self:connect_signal("mouse::enter", function() show_battery_status(self) end)
    self:connect_signal("mouse::leave",
                        function() naughty.destroy(notification) end)

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

function battery.mt:__call(...)
    if _instance == nil then _instance = self.new(...) end
    return _instance
end

return setmetatable(battery, battery.mt)
