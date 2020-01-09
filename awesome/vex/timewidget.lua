local setmetatable = setmetatable
local awful = require("awful")
local button = require("awful.button")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")

local timewidget = {mt = {}}

local style = {icon = beautiful.themes_path .. "widgets/clock.svg"}

-- @return A pulse widget.
function timewidget.new()
    local text = wibox.widget.textclock("%R %Z w:%w", 60)
    text.timezone = "Europe/Paris"

    local layout = wibox.layout.fixed.horizontal()
    layout:add(text)

    local widget = wibox.container.constraint(layout, "exact", style.width)
    local self = widget_base.make_widget(widget)
    self.text = text

    local month_calendar = awful.widget.calendar_popup.month()
    month_calendar:attach(self, "tr")

    -- Mouse bindings, for when you want to add GMT change
    self:buttons(gears.table.join(button({}, 1, function()
        if text.timezone == "Europe/Paris" then
            text.timezone = "UTC"
        else
            text.timezone = "Europe/Paris"
        end
    end)))

    return self
end

local _instance = nil

function timewidget.mt:__call(...)
    if _instance == nil then _instance = self.new(...) end
    return _instance
end

return setmetatable(timewidget, timewidget.mt)
