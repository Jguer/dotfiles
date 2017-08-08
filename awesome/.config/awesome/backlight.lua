local io = io
local tonumber = tonumber
local math = math
local string = string

module("backlight")

function Info()
  local f = io.popen("xbacklight -get")
  local v = f:read()
  local iconI = "🔅"
  f:close()

  if (v == "No outputs have backlight property\n" or v == nil) then
      return iconI.." BckL: N/A% "
  end

  local num = math.ceil(tonumber(v))

  if num >= 50 then
      iconI = "🔆"
  end

  return iconI.." BckL: "..num.."% "
end

function Change(per)
    local f = io.popen("xbacklight "..per)
    f:close()
end

