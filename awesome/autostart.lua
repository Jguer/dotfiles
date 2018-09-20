local awful = require("awful")
local beautiful = require("beautiful")

local function run_once(cmd_arr)
  for _, cmd in ipairs(cmd_arr) do
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
  end
end

run_once({
  "xss-lock -- lockscreen " .. beautiful.wallpaper
  })
