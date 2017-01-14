local io = io
local tonumber = tonumber
local tostring = tostring
local string = string

module("pulseaudio")

function volumeUp()
  local dc = defaultCard()
  local df = tonumber(dc) + 1
  local fI = io.popen("pacmd list-sinks | awk '/^\\svolume:/{i++} i=='"..tostring(df).."'{print $5; exit}'")
  local v = fI:read()
  vol = tonumber(v:sub(1, -2))
  fI:close()
  if vol >= 100 or vol <= 0 then
    return
  end

  local f = io.popen("pactl set-sink-volume " ..dc.." +3db")
  f:close()
end

function volumeDown()
  local dc = defaultCard()
  local f = io.popen("pactl set-sink-volume " ..dc.." -3db")
  f:close()
end

function defaultCard()
  local d = io.popen("pacmd list-sinks | grep -e '* index' | tail -c 2")
  dc = d:read()
  d:close()
  return dc
end

function volumeMute()
  local dc = defaultCard()
  local g = io.popen("pactl set-sink-mute " ..tostring(dc).." toggle")
  g:close()
end

function volumeInfo()
  volmin = 0
  volmax = 65536
  local dc = defaultCard()
  local df = tonumber(dc) + 1
  -- local f = io.popen("pacmd dump |grep set-sink-volume | sed -n " ..tostring(df).."p")
  local f = io.popen("pacmd list-sinks | awk '/^\\svolume:/{i++} i=='"..tostring(df).."'{print $5; exit}'")
  local g = io.popen("pacmd dump |grep set-sink-mute | sed -n " ..tostring(df).."p")
  local v = f:read()
  local mute = g:read()
  local iconI

  if v == "" then
      return "Vol: N/A% "
  end

  if mute ~= nil and string.find(mute, "no") then
    vol = tonumber(v:sub(1, -2))
    volume = v
    if vol >= 67 and vol <= 100 then
      iconI = "🔊"
    elseif vol >= 33 and vol <= 66 then
      iconI = "🔉"
    else
      iconI = "🔈"
    end
  else
    volume = "✕%"
    iconI = "🔇"
  end
  f:close()
  g:close()

  --return "Volume: "..volume
  return iconI.." Vol: "..volume.." "
end
