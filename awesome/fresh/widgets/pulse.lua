local setmetatable = setmetatable
local button        = require("awful.button")
local gears         = require("gears")
local awful         = require("awful")
local beautiful     = require("beautiful")
local widget_base   = require("wibox.widget.base")
local wibox         = require("wibox")
local gears_color   = require("gears.color")
local recolor_image = gears_color.recolor_image

local pulse = { mt = {} }
local request_command = 'amixer -D pulse sget Master'

local style = {
  width   = 100,
  icon    = beautiful.themes_path .. "widgets/audio.svg",
}

-- Callback for updating current status.
local function update_status (self)
  awful.spawn.easy_async(request_command, function(stdout, _, _, _)
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))
    local mute = string.match(stdout, "%[(o%D%D?)%]")

    if self.mute ~= mute then
      self.mute = mute
      if mute == "off" then
        self.icon:set_image(
          recolor_image(style.icon, beautiful.widget.off))
        self.dash:set_color(beautiful.widget.off)
      else
        self.icon:set_image(
          recolor_image(style.icon, beautiful.widget.bg))
        self.dash:set_color(beautiful.widget.fg)
      end
    end

    if self.volume ~= volume then
      self.volume = volume
      self.dash:set_value(volume/100)
    end
  end)
end

-- @return A pulse widget.
function pulse.new(timeout)
  local icon = wibox.widget {
    image  = recolor_image(style.icon, beautiful.widget.bg),
    resize = true,
    widget = wibox.widget.imagebox
  }

  local dash = wibox.widget {
    max_value     = 1,
    forced_width  = 100,
    margins  = {
      left   = 6,
      top    = 8,
      bottom = 8,
    },
    background_color = beautiful.widget.bg,
    color            = beautiful.widget.fg,
    shape            = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 2)
    end
    ,
    ticks = 5,
    ticks_gap = 1,
    ticks_size = 10,
    widget           = wibox.widget.progressbar,
  }

  local layout = wibox.layout.fixed.horizontal()
  layout:add(wibox.container.margin(icon, 0, 0, 3, 3))
  layout:add(dash)

  local widget = wibox.container.constraint(layout, "exact", style.width)
  local self = widget_base.make_widget(widget)
  self.icon = icon
  self.dash = dash

  self.volume = 0
  self.mute = "off"

  self.widget_tooltip = awful.tooltip({
    objects = { widget },
    timer_function = function()
      return "Sound " .. self.mute .. " " .. self.volume .. "%"
    end,
  })

  self.set_volume = function(step)
    awful.spawn("amixer -D pulse sset Master ".. step, false)
    update_status(self)
  end

  self.toggle_mute = function()
    awful.spawn("amixer -D pulse sset Master toggle", false)
    update_status(self)
  end

  -- Mouse bindings
  self:buttons(gears.table.join(
    button({ }, 4, function() self.set_volume("5%+") end),
    button({ }, 5, function() self.set_volume("5%-") end),
    button({ }, 1, function() self.toggle_mute() end)))

  update_status(self)
  gears.timer {
    timeout   = timeout,
    call_now  = true,
    autostart = true,
    callback  = function()
      update_status(self)
    end
  }
  pulse.instance = self
  return self
end

local _instance = nil;

function pulse.mt:__call(...)
  if _instance == nil then
    _instance = self.new(...)
  end
  return _instance
end

return setmetatable(pulse, pulse.mt)
