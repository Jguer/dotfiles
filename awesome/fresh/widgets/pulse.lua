local setmetatable  = setmetatable
local button        = require("awful.button")
local gears         = require("gears")
local awful         = require("awful")
local naughty       = require("naughty")
local beautiful     = require("beautiful")
local widget_base   = require("wibox.widget.base")
local wibox         = require("wibox")
local gears_color   = require("gears.color")
local recolor_image = gears_color.recolor_image

local pulse = { mt = {} }
local alsaCommand = 'amixer get Master | grep -P -o "\\[(on|off)\\]|[0-9]+(%=?)"';
alsaCommand = "bash -c '"..alsaCommand.."'";

local style = {
  width   = 56,
  icon    = beautiful.themes_path .. "widgets/audio.svg",
  mute_icon    = beautiful.themes_path .. "widgets/mute.svg",
}

local function update_status (self)
  awful.spawn.with_line_callback(alsaCommand, {
    stdout = function(line)
      if line:find("off") then
        self.icon:set_image(
          recolor_image(style.mute_icon, beautiful.widget.off))
      elseif line:find("on") then
        self.icon:set_image(
          recolor_image(style.icon, beautiful.widget.fg))
      else
        local volume = tonumber(line:match("%d+"));
        self.text:set_text(volume .. "%")
      end

    end;
    stderr = function() end;
  })
end


-- @return A pulse widget.
function pulse.new(timeout)
  local icon = wibox.widget {
    image  = recolor_image(style.icon, beautiful.widget.bg),
    resize = true,
    forced_width = 16,
    forced_height = 16,
    widget = wibox.widget.imagebox
  }

  local text = wibox.widget{
    text = '0%',
    align  = 'center',
    valign = 'center',
    forced_width = 42,
    widget = wibox.widget.textbox
  }

  local layout = wibox.layout.fixed.horizontal()
  layout:add(wibox.container.margin(icon, 0, 2, 4, 4))
  layout:add(text)

  local widget = wibox.container.constraint(layout, "exact", style.width)
  local self = widget_base.make_widget(widget)
  self.icon = icon
  self.text = text

  self.set_volume = function(step)
    awful.spawn("amixer -D pulse sset Master ".. step, false)
    update_status(self)
  end

  self.toggle_mute = function()
    awful.spawn("amixer -D pulse sset Master toggle", false)
    update_status(self)
  end

  self.toggle_mic = function()
    awful.spawn("amixer set Capture toggle", false)
  end

  -- Mouse bindings
  self:buttons(gears.table.join(
    button({ }, 4, function() self.set_volume("2%+") end),
    button({ }, 5, function() self.set_volume("2%-") end),
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
