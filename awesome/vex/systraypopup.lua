local setmetatable = setmetatable
local awful = require("awful")
local beautiful = require("beautiful")
local widget_base = require("wibox.widget.base")
local wibox = require("wibox")
local gears_color = require("gears.color")
local gears = require("gears")
local button = require("awful.button")

local recolor_image = gears_color.recolor_image

local systraypopup = {mt = {}}

local style = {width = 48, icon = beautiful.wicons.systray}

-- @return A systraypopup widget.
function systraypopup.new(systray_widget)
    local icon = wibox.widget{
        image = recolor_image(style.icon, beautiful.widget.fg),
        resize = true,
        forced_width = 16,
        forced_height = 16,
        widget = wibox.widget.imagebox
    }

    local systray = wibox.widget.systray()

    local p = awful.popup{
        widget = wibox.container.constraint(systray, "exact", nil, 28),
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
        offset = {y = 32},
        placement = awful.placement.bottom_right,
        ontop = true,
        visible = false
        -- shape = gears.shape.rounded_rect
    }

    local layout = wibox.layout.align.horizontal(wibox.container.place(icon, p))
    -- layout.expand = 'outside'

    local self = widget_base.make_widget(layout)

    self.icon = icon
    self.popup = p
    self.systray = systray

    self:buttons(gears.table.join(button({}, 1, function()
        self.popup.visible = not self.popup.visible
    end)))

    return self
end

local _instance = nil

function systraypopup.mt:__call(...)
    if _instance == nil then _instance = self.new(...) end
    return _instance
end

return setmetatable(systraypopup, systraypopup.mt)
