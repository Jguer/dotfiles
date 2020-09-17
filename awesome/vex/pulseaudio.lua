--[[
  Copyright 2017-2019 Stefano Mazzucco <stefano AT curso DOT re>

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

  This program was inspired by the
  [Awesome Pulseaudio Widget (APW)](https://github.com/mokasin/apw)
]] local string = string

local awful = require("awful")
local gears = require("gears")

local wibox = require("wibox")
local naughty = require("naughty")

local pulse = require("pulseaudio_dbus")

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
    muted = lookup_icon("audio-volume-muted-symbolic")
}

local widget = wibox.widget {resize = true, widget = wibox.widget.imagebox}

widget.tooltip = awful.tooltip({objects = {widget}})

function widget:update_appearance(v)
    local i, msg

    if v == "Muted" then
        msg = v
        i = load_icon(icon.muted)
    else
        v = v == "Unmuted" and self.sink:get_volume_percent()[1] or tonumber(v)
        msg = string.format("%d%%", v)
        if v <= 33 then
            i = load_icon(icon.low)
        elseif v <= 66 then
            i = load_icon(icon.med)
        else
            i = load_icon(icon.high)
        end
    end

    self.image = i
    self.tooltip:set_text(msg)

end

function widget:notify(v)
    local msg = tonumber(v) and string.format("%d%%", v) or v

    if self.notification then
        naughty.destroy(self.notification,
                        naughty.notificationClosedReason.dismissedByCommand)
    end

    self.notification = naughty.notify({
        text = msg,
        icon = icon.high.get_filename(icon.high),
        title = "Audio",
        timeout = self.notification_timeout_seconds,
        preset = naughty.config.presets.low,
        icon_size = 100
    })

end

function widget:update_sink(object_path)
    self.sink = pulse.get_device(self.connection, object_path)
end

function widget:update_sources(sources)
    for _, source_path in ipairs(sources) do
        local s = pulse.get_device(self.connection, source_path)
        if s.Name and not s.Name:match("%.monitor$") then
            self.source = s
            break
        else
            self.source = nil
        end
    end
end

function widget.volume_up()
    if not widget.sink:is_muted() then widget.sink:volume_up() end
end

function widget.volume_down()
    if not widget.sink:is_muted() then widget.sink:volume_down() end
end

function widget.toggle_muted() widget.sink:toggle_muted() end

function widget.volume_up_mic()
    if widget.source and not widget.source:is_muted() then
        widget.source:volume_up()
    end
end

function widget.volume_down_mic()
    if widget.source and not widget.source:is_muted() then
        widget.source:volume_down()
    end
end

function widget.toggle_muted_mic()
    if widget.source then widget.source:toggle_muted() end
end

widget:buttons(gears.table.join(awful.button({}, 1, widget.toggle_muted),
                                awful.button({}, 3, function()
    awful.spawn(widget.mixer)
end), awful.button({}, 4, widget.volume_up),
                                awful.button({}, 5, widget.volume_down)))

function widget:connect_device(device)
    if not device then return end

    if device.signals.VolumeUpdated then
        device:connect_signal(function(this, volume)
            -- FIXME: BaseVolume for sources (i.e. microphones) won't give the correct percentage
            local v = math.ceil(tonumber(volume[1]) / this.BaseVolume * 100)
            if this.object_path == self.sink.object_path then
                self:update_appearance(v)
                self:notify(v)
            end
        end, "VolumeUpdated")
    end

    if device.signals.MuteUpdated then
        device:connect_signal(function(this, is_mute)
            local m = is_mute and "Muted" or "Unmuted"
            if this.object_path == self.sink.object_path then
                self:update_appearance(m)
                self:notify(m)
            end
        end, "MuteUpdated")
    end
end

function widget:init()
    local status, address = pcall(pulse.get_address)
    if not status then
        naughty.notify({
            title = "Error while loading the PulseAudio widget",
            text = address,
            preset = naughty.config.presets.critical
        })
        return self
    end

    self.mixer = "pavucontrol"
    self.notification_timeout_seconds = 1

    self.connection = pulse.get_connection(address)
    self.core = pulse.get_core(self.connection)

    -- listen on ALL objects as sinks and sources may change
    self.core:ListenForSignal("org.PulseAudio.Core1.Device.VolumeUpdated", {})
    self.core:ListenForSignal("org.PulseAudio.Core1.Device.MuteUpdated", {})

    self.core:ListenForSignal("org.PulseAudio.Core1.NewSink",
                              {self.core.object_path})
    self.core:connect_signal(function(_, newsink)
        self:update_sink(newsink)
        self:connect_device(self.sink)
        local volume = self.sink:is_muted() and "Muted" or
                           self.sink:get_volume_percent()[1]
        self:update_appearance(volume)
    end, "NewSink")

    self.core:ListenForSignal("org.PulseAudio.Core1.NewSource",
                              {self.core.object_path})
    self.core:connect_signal(function(_, newsource)
        self:update_sources({newsource})
        self:connect_device(self.source)
    end, "NewSource")

    self:update_sources(self.core:get_sources())
    self:connect_device(self.source)

    local sink_path = assert(self.core:get_sinks()[1], "No sinks found")
    self:update_sink(sink_path)
    self:connect_device(self.sink)

    local volume = self.sink:is_muted() and "Muted" or
                       self.sink:get_volume_percent()[1]
    self:update_appearance(volume)

    self.__index = self

    return self
end

return widget:init()
