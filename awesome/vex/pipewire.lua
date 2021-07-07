--[[
  Copyright 2021 Jguer <space jguer at me, reversed>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
local awful = require("awful")
local gears = require("gears")

local wibox = require("wibox")
local naughty = require("naughty")


local lgi = require('lgi')
local icon_theme = lgi.Gtk.IconTheme.get_default()
local IconLookupFlags = lgi.Gtk.IconLookupFlags

local icon_size = 64
local icon_flags = {IconLookupFlags.GENERIC_FALLBACK}

local function lookup_icon(name)
    return icon_theme:lookup_icon(name, icon_size, icon_flags)
end


local function load_icon(icon) if icon ~= nil then return icon:load_surface() end end

local icon = {
    high = lookup_icon("audio-volume-high-symbolic"),
    med = lookup_icon("audio-volume-medium-symbolic"),
    low = lookup_icon("audio-volume-low-symbolic"),
    muted = lookup_icon("audio-volume-muted-symbolic"),
    muted_blocking = lookup_icon("audio-volume-muted-blocking-symbolic")
}

local preloaded_icons = {
    high = load_icon(icon.high),
    med = load_icon(icon.med),
    low = load_icon(icon.low),
    muted = load_icon(icon.muted),
    muted_blocking = load_icon(icon.muted_blocking)
}

local widget = wibox.widget {resize = true, widget = wibox.widget.imagebox}

widget.tooltip = awful.tooltip({objects = {widget}})

function widget:update_appearance(name, v, muted)
    local i, msg

    if v == nil then
        msg = "??%"
        i = preloaded_icons.muted_blocking
    elseif muted == "MUTED" then
        msg = string.format("%s\n%.0f%%", name,v)
        i = preloaded_icons.muted
    else
        msg = string.format("%s\n%.0f%%", name,v)
        if v <= 33 then
            i = preloaded_icons.low
        elseif v <= 66 then
            i = preloaded_icons.med
        else
            i = preloaded_icons.high
        end
    end

    self.image = i
    self.tooltip:set_text(msg)
end

function widget:notify(name, v)
    local vol = string.format("%.0f%%\n%s", v, name) or nil
    if vol == nil then
        return
    end
    if self.notification then
        naughty.destroy(self.notification,
                        naughty.notificationClosedReason.dismissedByCommand)
    end

    self.notification = naughty.notify({
        text = vol,
        title = "Audio",
        timeout = self.notification_timeout_seconds,
        preset = naughty.config.presets.low
    })
end

function widget.volume_up()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
    widget:get_volume_and_notify()
end

function widget.volume_down()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
    widget:get_volume_and_notify()
end

function widget.toggle_muted()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    widget:get_volume_and_notify()
end

function widget.toggle_muted_mic()
    awful.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
end

local function parse_output(stdout)
    local name_n, vol_n, muted = string.match(stdout, "%. (.*)  .*(%d%d?%.%d%d)%s?(.*)%]")

    if vol_n ~= nil then
        vol_n = tonumber(vol_n) *100
    end

    if muted == "" then
        muted = nil
    end

    return name_n, vol_n, muted
end

function widget:get_volume()
    awful.spawn.easy_async_with_shell([[wpctl status | grep -Eom 1 "\*.+"]], function(stdout, _, _, _)
        self:update_appearance(parse_output(stdout))
    end)
end

function widget:get_volume_and_notify()
    awful.spawn.easy_async_with_shell([[wpctl status | grep -Eom 1 "\*.+"]], function(stdout, _, _, _)
        local name,vol_n,muted = parse_output(stdout)
        self:update_appearance(name,vol_n, muted)
        self:notify(name,vol_n)
    end)
end

widget:buttons(gears.table.join(awful.button({}, 1, widget.toggle_muted),
                                awful.button({}, 3, function() awful.spawn(widget.mixer) end),
                                awful.button({}, 4, widget.volume_up),
                                awful.button({}, 5, widget.volume_down)))

function widget:init()
    self.mixer = "pavucontrol"
    self.notification_timeout_seconds = 1
    self.timeout = 26

    self.__index = self
    gears.timer {
        timeout = self.timeout,
        call_now = true,
        autostart = true,
        callback = function() self:get_volume() end
    }

    return self
end

return widget:init()
