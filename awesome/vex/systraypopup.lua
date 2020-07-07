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
function systraypopup.new()
    local icon = wibox.widget {
        image = recolor_image(style.icon, beautiful.widget.fg),
        resize = true,
        forced_width = 16,
        forced_height = 16,
        widget = wibox.widget.imagebox
    }

    local systray = wibox.widget.systray()

    local container = wibox.container.place(systray)
    local fixed_layout = wibox.layout.fixed.horizontal()
    local layout = wibox.layout.fixed.horizontal(fixed_layout,
                                                 wibox.container.place(icon))

    local self = widget_base.make_widget(layout)

    self.systray = systray
    self.visible = false

    self:buttons(gears.table.join(button({}, 1, function()
        if self.visible == false then
            fixed_layout:add(container)
            self.visible = true
        else
            fixed_layout:remove_widgets(container)
            self.visible = false
        end
        self.systray:set_screen(awful.screen.focused())

    end)))

    return self
end

local _instance = nil

function systraypopup.mt:__call(...)
    if _instance == nil then _instance = self.new(...) end
    return _instance
end

return setmetatable(systraypopup, systraypopup.mt)
