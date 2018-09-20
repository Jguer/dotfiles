-- default keybinding: b
local utils = require 'mp.utils'
function load_sub_fn()
  subl = "/bin/subdl"
  path = mp.get_property("path")
  srt_path = string.gsub(path, "%.%w+$", ".srt")
  srt_args = "--lang=fre,eng --existing=bypass --output="..path
  mp.msg.info("Searching subtitle")
  mp.osd_message("Searching subtitle")
  t = {}
  t.args = {subl, srt_args, path}
  res = utils.subprocess(t)
  if res.status == 0 then
    mp.commandv("rescan_external_files", "reselect")
    mp.msg.info("Subtitle download succeeded by path")
    mp.osd_message("Subtitle download succeeded by path")
  else
    t.args = {subl,mp.get_property("media-title")}
    res = utils.subprocess(t)
    if res.status == 0 then
      mp.commandv("rescan_external_files", "reselect")
      mp.msg.info("Subtitle download succeeded by title")
      mp.osd_message("Subtitle download succeeded by title")
    else
      mp.msg.warn("Subtitle download failed")
      mp.osd_message("Subtitle download failed")
      t.args = {subl,mp.get_property("title")}
      res = utils.subprocess(t)
    end
  end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)
