local setmetatable = setmetatable

local awful = require("awful")
local gears = require("gears")
local spawn = require("awful.spawn")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears_color = require("gears.color")
local naughty = require("naughty")
local recolor_image = gears_color.recolor_image
local watch = require("awful.widget.watch")

local audio = { mt = {} }
local volume

local request_command = 'amixer -D pulse sget Master'

local style = {
  width   = 100,
  icon    = beautiful.themes_path .. "widgets/audio.svg",
}

function audio:change_volume(step)
  awful.spawn("amixer -D pulse sset Master ".. step, false)
  awful.spawn.easy_async(request_command, function(stdout, _, _, _)
    audio:update_volume(audio.widget, stdout)
  end)
end

function audio:set_watch(timeout)
  watch(request_command, timeout, function(widget, stdout)
    audio:update_volume(widget, stdout)
  end
  , self)
end

function audio:mute()
  awful.spawn("amixer -D pulse sset Master toggle", false)
  awful.spawn.easy_async(request_command, function(stdout, _, _, _)
    self:update_volume(self.widget, stdout)
  end)
end

function audio:update_volume(self, stdout)
  volume = string.match(stdout, "(%d?%d?%d)%%")
  volume = tonumber(string.format("% 3d", volume))
  local mute = string.match(stdout, "%[(o%D%D?)%]")

  if mute == "off" then
    self:set_value(volume/100)
    self:set_mute(true)
  else
    self:set_value(volume/100)
    self:set_mute(false)
  end
end

function audio:set_value(x) self.dash.value = x; end

function audio:set_mute(bool)
  self.icon.image = recolor_image(style.icon, bool and beautiful.widget.off or beautiful.widget.bg)
  self.dash.color = bool and beautiful.widget.off or beautiful.widget.fg
end

function audio.new()

  -- Construct widget
  --------------------------------------------------------------------------------

  local icon = wibox.widget {
    image  = recolor_image(style.icon, beautiful.widget.bg),
    resize = true,
    widget = wibox.widget.imagebox
  }

  local dash = wibox.widget {
    max_value     = 1,
    forced_width  = 100,
    margins  = {
      left = 6,
      top    = 8,
      bottom = 8,
    },
    background_color = beautiful.widget.bg,
    color            = beautiful.widget.fg,
    shape            = gears.shape.rounded_bar,
    widget           = wibox.widget.progressbar,
  }

  local layout = wibox.layout.fixed.horizontal()
  layout:add(wibox.container.margin(icon, 0, 0, 3, 3))
  layout:add(dash)

  local self = wibox.container.constraint(layout, "exact", style.width)
  self.icon = icon
  self.dash = dash

  local widg_t = awful.tooltip({
    objects = { self },
    timer_function = function()
      return "Volume: " .. volume
    end,
  })

  -- User functions
  ------------------------------------------------------------

  --------------------------------------------------------------------------------
  return self
end

local _instance = nil;

function audio.mt:__call(...)
  if _instance == nil then
    _instance = audio.new(...)
  end
  return _instance
end

return setmetatable(audio, audio.mt)
