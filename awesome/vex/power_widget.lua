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
]]

local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local lgi = require('lgi')
local icon_theme = lgi.Gtk.IconTheme.get_default()
local IconLookupFlags = lgi.Gtk.IconLookupFlags

local power = require("upower_dbus")
local WarningLevel = power.enums.BatteryWarningLevel

local spawn_with_shell = awful.spawn.with_shell or awful.util.spawn_with_shell

local math = math
local string = string

local function to_hour_min_str(seconds)
  local hours = math.floor(seconds/3600)
  local minutes = math.ceil( (seconds % 3600) / 60)
  return string.format("%02dh:%02dm", hours, minutes)
end

local icon_size = 64
local icon_flags = {IconLookupFlags.GENERIC_FALLBACK}
local notification = nil
local device = nil

local power_widget = wibox.widget {
  resize = true,
  widget = wibox.widget.imagebox
}

local function get_percentage()
  local percentage = device.Percentage

  if percentage then
    return math.floor(percentage)
  end

  return 0
end

local function update_icon(widget)
  local icon = icon_theme:lookup_icon(
    device.IconName,
    icon_size,
    icon_flags
  )

  if icon then
    widget.image = icon:load_surface()
  end
end

local function maybe_warn(widget, warning_condition, notification_preset, message)

  if warning_condition then
    local warning_level = device.warninglevel or power.enums.BatteryWarningLevel.None
    local msg = message or (warning_level.name == "None" and "Low" or warning_level.name) .. " battery!"

    if notification then
      naughty.destroy(
        notification,
        naughty.notificationClosedReason.dismissedByCommand
      )
    end

    notification = naughty.notify({
        preset = notification_preset,
        title = msg,
        text = get_percentage() .. "% remaining"})
  end
end

local function update_tooltip(widget)
  if device.IsPresent then
    local percentage = get_percentage()
    local charge_status_msg = ""
    local what
    local when
    if device.type == power.enums.DeviceType.Battery then
      if device.TimeToEmpty > 0 then
        what = "Emtpy"
        when = device.TimeToEmpty
      elseif device.TimeToFull > 0 then
        what = "Full"
        when = device.TimeToFull
      end
      if when then
        charge_status_msg = string.format("\n%s in %s", what, to_hour_min_str(when))
      end
    end

    widget.tooltip:set_text(
      string.format(
        "%d%% - %s%s",
        percentage,
        device.state.name,
        charge_status_msg
      )
    )
  else
    -- We don't know how we're powered, but we must be somehow!
    widget.tooltip:set_text("Plugged In")
  end

end

local function should_warn_critical(widget)
  if not device.IsPresent then
    return false
  end

  local percentage = get_percentage()

  return (
    device.state == power.enums.BatteryState.Discharging and
      (
        percentage <= widget.critical_percentage
          or device.warninglevel == WarningLevel.Low
          or device.warninglevel == WarningLevel.Critical
      )
  )
end

local function update(widget)
  device:update_mappings()
  update_icon(widget)
  update_tooltip(widget)

  local critical_warn = should_warn_critical(widget)

  maybe_warn(
    widget,
    critical_warn,
    naughty.config.presets.critical
  )

  if not critical_warn then
    maybe_warn(
      widget,
      get_percentage() <= widget.warning_config.percentage,
      widget.warning_config.preset,
      widget.warning_config.message
    )
  end

  if device.state ~= power.enums.BatteryState.Discharging and notification then
    naughty.destroy(
      notification,
      naughty.notificationClosedReason.dismissedByCommand
    )
  end

end

local function init(widget)
  -- https://upower.freedesktop.org/docs/UPower.html#UPower.GetDisplayDevice
  device = power.create_device("/org/freedesktop/UPower/devices/DisplayDevice")

  device:on_properties_changed(
    function ()
      update(widget)
    end
  )

  widget.tooltip = awful.tooltip({ objects = { widget },})
  widget.gui_client = nil
  widget.critical_percentage = 5

  widget.warning_config = {
    percentage = -1,            -- disabled by default
    -- https://awesomewm.org/doc/api/libraries/naughty.html#config.presets
    preset = naughty.config.presets.normal,
  }

  update(widget)

  widget:buttons(awful.util.table.join(
                   awful.button({ }, 3,
                     function ()
                       if widget.gui_client then
                         spawn_with_shell(widget.gui_client)
                       end
                     end
  )))
  return widget
end

return init(power_widget)
