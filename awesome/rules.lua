local awful = require("awful")
local beautiful = require("beautiful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    size_hints_honor = false,
    honor_workarea = true,
    honor_padding = true,
    raise = true,
    screen = awful.screen.preferred
}

rules.floating_any = {
    class = {"Sxiv"},
    role = {"AlarmWindow", "pop-up"},
    type = {"dialog"}
}

rules.titlebar_any = {class = {"VirtualBox Machine"}, type = {"dialog"}}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)
    local args = args or {}
    self.base_properties.keys = args.hotkeys.keys.client
    self.base_properties.buttons = args.hotkeys.mouse.client

    -- Build rules
    --------------------------------------------------------------------------------
    self.rules = {
        {rule = {}, properties = args.base_properties or self.base_properties},
        {
            rule_any = args.floating_any or self.floating_any,
            properties = {floating = true}
        },
        {rule_any = self.titlebar_any, properties = {titlebars_enabled = true}},
        {
            rule_any = {type = {"normal"}},
            properties = {
                placement = awful.placement.no_overlap +
                    awful.placement.no_offscreen
            }
        }
    }

    -- Set rules
    --------------------------------------------------------------------------------
    awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
