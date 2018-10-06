--- default keybinding: b
local utils = require 'mp.utils'
local mp = require 'mp'

local subl = "/bin/subdl"
local lang_list = {"fre","eng"}

function load_sub_fn()
    local path = mp.get_property("path")
    mp.osd_message("Searching subtitle")
    local t = {}
    for _, lang in ipairs(lang_list) do
        t.args = {subl, "--existing=bypass",
        string.format("--lang=%s", lang), "--output={m}.{L}.{S}",path}
        t.res = utils.subprocess(t)
        if t.res.error == nil then
            t.reload = true
            mp.osd_message("Subtitle download succeeded by path")
        end
    end
    if t.reload then
        mp.commandv("rescan_external_files", "reselect")
    end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)
