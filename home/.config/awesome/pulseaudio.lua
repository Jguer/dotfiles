local io       = io
local tonumber = tonumber
local tostring = tostring
local string   = string
local awful    = require("awful")
local naughty  = require("naughty")
local mouse    = mouse
local iconlib  = require("freedesktop.utils")

module("pulseaudio")

function get_default_card()
    local d  = io.popen([[pacmd stat | awk -F": " '/^Default sink name: /{print $2}']])
    local dc = d:read()
    d:close()
    return dc
end

function get_volume(dc)
    local fI = io.popen([[pacmd list-sinks | awk '/^\s+name: /{indefault = $2 == "<']]..dc..[['>"}/^\s+volume: / && indefault {print $5; exit}']])
    local v  = fI:read()
    fI:close()
    return tonumber(v:sub(1, -2))
end

function get_mute(dc)
    local fI   = io.popen([[pacmd list-sinks | awk '/^\s+name: /{indefault = $2 == "<']]..dc..[['>"}/^\s+muted: / && indefault {print $2; exit}']])
    local mute = fI:read()
    fI:close()
    if mute == "yes" then; return true; end
    return false
end

function volume_change(change)
    local dc  = get_default_card()
    local vol = get_volume(dc)

    if change:sub(1,1) == '-' then; if vol < 0 then; return; end
    else; if vol > 100 then; return; end
    end

    awful.spawn("pactl set-sink-volume "..dc.." "..change)
end

function volume_mute()
    local dc = get_default_card()
    awful.spawn("pactl set-sink-mute " ..dc.." toggle")
end

function volume_info()
    local dc   = get_default_card()
    local mute = get_mute(dc)
    local vol  = get_volume(dc)
    local iconI

    if vol == nil then
        return "Vol: N/A% "
    end

    if mute == false then
        if vol >= 67 and vol <= 100 then
            iconI = ""
        elseif vol >= 33 and vol <= 66 then
            iconI = ""
        else
            iconI = ""
        end
    else
        volume = "✕"
        iconI = "🔇"
    end

    --return "Volume: "..volume
    return iconI.." Vol: "..vol.."% "
end

local cid = nil

function cycle_devices()
    local fB = io.popen([[pacmd list-sinks | grep index | tail -n1 -c 2]])
    local maxsink = tonumber(fB:read())
    fB:close()

    local fC = io.popen([[pacmd list-sinks | grep "* index" | tail -n1 -c 2]])
    local sink = tonumber(fC:read())
    fC:close()

    local newsink = sink + 1
    if newsink > maxsink then
        newsink = 0
    end

    awful.spawn("pacmd set-default-sink "..newsink)

    awful.spawn.with_line_callback([[bash -c 'pactl list sink-inputs short | cut -f 1']], {
            stdout = function(line)
                awful.spawn("pactl move-sink-input "..line.." "..newsink)
            end,
            stderr = function(line)
                naughty.notify { text = "ERR:"..line}
            end,
        })

    local fD = io.popen([[pacmd list-sinks| grep -e 'index' -e 'device.description' | sed -n '/* index/{n;p;}' | grep -o '".*"' | sed 's/"//g']])
    local sinkname = fD:read()
    fD:close()

    cid = naughty.notify({ text = sinkname,
            icon = iconlib.lookup_icon({ icon = 'audio-speakers' }),
            timeout = 2,
            screen = mouse.screen, -- Important, not all screens may be visible
            replaces_id = cid
        }).id

end
