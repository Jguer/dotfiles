local setmetatable = setmetatable
local button = require("awful.button")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local timer = require("gears.timer")
local gtable = require("gears.table")

local pulse = {mt = {}}
local command = "amixer -D pulse sget Master | tail -n 1"
local get_sink = "pacmd list-sinks | grep '* index:' | cut -b12-"

function pulse:force_update() self._timer:emit_signal("timeout") end

-- @return A pulse widget.
local function new(timeout)
    local self = wibox.widget{
        markup = string.format("%s %s%%",
                               beautiful.icon("", beautiful.widget.fg), 0),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }
    gtable.crush(self, pulse, true)

    self.volume = "0"
    self._private.refresh = timeout or 12

    self.set_volume = function(step)
        spawn.easy_async("pactl set-sink-volume @DEFAULT_SINK@ " .. step,
                         self._private.update)
    end

    self.toggle_mute = function()
        spawn.easy_async("amixer -D pulse sset Master toggle",
                         self._private.update)
    end

    self.toggle_mic = function()
        awful.spawn("amixer set Capture toggle", false)
    end

    function self._private.update()
        spawn.easy_async_with_shell(command, function(stdout, _, _, _)
            local status = string.match(stdout, "%[(o%D%D?)%]") or "N/A"
            self.volume = string.match(stdout, "(%d?%d?%d)%%") or "0"

            if status == "on" then
                self:set_markup(string.format("%s %s%%", beautiful.icon("",
                                                                        beautiful.widget
                                                                            .fg),
                                              self.volume))
            else
                self:set_markup(string.format("%s %s%%", beautiful.icon("",
                                                                        beautiful.widget
                                                                            .off),
                                              self.volume))
            end

            self._timer:again()
        end)
    end

    -- Mouse bindings
    self:buttons(gears.table.join(button({}, 4,
                                         function() self.set_volume("+2%") end),
                                  button({}, 5,
                                         function() self.set_volume("-2%") end),
                                  button({}, 3, function()
        awful.spawn("pavucontrol")
    end), button({}, 1, self.toggle_mute)))

    self._timer = timer.weak_start_new(self._private.refresh,
                                       self._private.update)
    self:force_update()
    return self
end

local _instance = nil

function pulse.mt:__call(...)
    if _instance == nil then _instance = new(...) end
    return _instance
end

return setmetatable(pulse, pulse.mt)
