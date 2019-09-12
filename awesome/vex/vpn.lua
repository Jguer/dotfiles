---------------------------------------------------------------------------
--- VPN widget
--
-- @author Jguer
-- @copyright 2019 Jguer
-- @classmod vex.vpn
---------------------------------------------------------------------------
local beautiful = require("beautiful")
local button = require("awful.button")
local gtable = require("gears.table")
local os = os
local setmetatable = setmetatable
local spawn = require("awful.spawn")
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local awful = require("awful")

local vpn = {mt = {}}

--- Set the vpn's refresh rate
-- @property refresh
-- @tparam number How often the vpn is updated, in seconds

function vpn:set_refresh(refresh)
    self._private.refresh = refresh or self._private.refresh
    self:force_update()
end

function vpn:get_refresh() return self._private.refresh end

--- Force vpn to update now.
function vpn:force_update() self._timer:emit_signal("timeout") end

--- Create a vpn widget. It checks the presence of the openvpn process.
-- @tparam[opt="/home/jguer/vpn-folder"] location of .ovpn files.
-- @tparam[opt="vpn: "] prefix of widget.
-- @tparam[opt=30] number refresh How often to check (in seconds).
-- @treturn table A vpn widget.
-- @function vex.vpn
local function new(vpn_dir, prefix, refresh)
    local w = textbox()
    gtable.crush(w, vpn, true)

    w._private.vpn_dir = vpn_dir or os.getenv("HOME") .. "/vpn-folder"
    w._private.prefix = prefix or "vpn: "
    w._private.refresh = refresh or 30
    w._private.ovpns = {off = 1}
    w._private.connected = "off"

    spawn.easy_async("ls " .. w._private.vpn_dir, function(stdout, _, _, _)
        for line in stdout:gmatch("[^\r\n]+") do
            if line:match("%s*(%S+)%.ovpn") then
                w._private.ovpns[line:match("%s*(%S+)%.")] = line:match("(%w+)")
            end
        end
    end)

    function w._private.set_vpn()
        if w._private.selected ~= w._private.connected then
            if w._private.connected ~= "off" then
                awful.spawn("sudo kill " ..
                                w._private.ovpns[w._private.connected], true,
                            function()
                    if w._private.selected == "off" then
                        w:force_update()
                    end
                end)
            end

            if w._private.selected ~= "off" then
                w._private.ovpns[w._private.selected] =
                    awful.spawn("sudo openvpn " .. w._private.vpn_dir .. "/" ..
                                    w._private.selected .. ".ovpn", true,
                                function() w:force_update() end)
            end
        end
        w._select_timer:stop()
    end

    function w._private.vpn_update()
        spawn.easy_async("ps ahx -o pid,command", function(stdout, _, _, _)
            local color
            local file
            w._private.connected = nil
            for line in stdout:gmatch("[^\r\n]+") do
                if line:match("%w*openvpn") and not line:match("sudo") then
                    file = line:sub(line:find("/[^/]*$") + 1):match(
                               "(%S+)%.ovpn")
                    if w._private.ovpns[file] then
                        w._private.connected = file
                        w._private.selected = file
                        w._private.ovpns[file] = line:match("(%w+)")
                        color = beautiful.widget.on
                    end
                end
            end
            if not w._private.connected then
                w._private.connected = "off"
                w._private.selected = "off"
                color = beautiful.widget.off
            end

            w:set_markup(string.format("%s<span color='%s'>%s</span>",
                                       w._private.prefix, color,
                                       w._private.connected))
            w._timer:again()
        end)
        return true
    end

    -- Mouse bindings
    w:buttons(gtable.join(button({}, 1, function()
        local k = next(w._private.ovpns, w._private.selected)
        if not k then k = next(w._private.ovpns, nil) end
        w._private.selected = k
        w:set_markup(string.format("%s<span color='%s'>%s</span>",
                                   w._private.prefix, beautiful.widget.fg, k))
        w._select_timer:again()
    end)))

    w._select_timer = timer.weak_start_new(3.0, w._private.set_vpn)
    w._select_timer:stop()
    w._timer = timer.weak_start_new(w._private.refresh, w._private.vpn_update)
    w:force_update()
    return w
end

function vpn.mt:__call(...) return new(...) end

-- @DOC_widget_COMMON@

-- @DOC_object_COMMON@

return setmetatable(vpn, vpn.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
