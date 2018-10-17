local awful = require("awful")
local beautiful = require("beautiful")


local function readAll(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

local hostname = readAll("/etc/hostname")

local function run_once(cmd_arr)
  local user = os.getenv("USER")
  for _, cmd in ipairs(cmd_arr) do
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.easy_async(string.format("pgrep -u %s -x %s", user, findme),
      function(_, _, _, exit_code)
        if exit_code ~= 0 then
          awful.spawn(cmd,false)
        end
      end)
    end
  end

local autorun = {}
autorun["all"] = {
  "xss-lock -- lockscreen " .. beautiful.wallpaper,
  "redshift -l 38.72:-9.15 -t 5700:3600",
  "numlockx",
  "nm-applet",
  "unclutter -noevents -idle 2 -jitter 1 -root"
}

run_once(autorun["all"])
run_once(autorun[hostname] or {})
