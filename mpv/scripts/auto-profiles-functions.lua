local utils = require 'mp.utils'
local msg = require 'mp.msg'

local function exec(process)
    p_ret = utils.subprocess({args = process})
    if p_ret.error and p_ret.error == "init" then
        print("ERROR executable not found: " .. process[1])
    end
    return p_ret
end

 loc = exec({"/usr/bin/cat","/etc/hostname"})

function is_desktop()
    return not string.find(loc.stdout, "harkonnen")
end

function is_laptop()
    return string.find(loc.stdout, "harkonnen")
end

function on_battery()
    local bat = exec({"/usr/bin/acpi"})
    return string.find(bat.stdout, "Discharging")
end
