#!/usr/bin/env lua

local lgi = require 'lgi'
local Gtk = lgi.require('Gtk', '3.0')
local os = os

local action_list = {}
local to_execute = {}

function on_check_button_toggled(checkbutton)
    local label = checkbutton:get_label()

    if checkbutton:get_active() then
        print(string.format('%s has been spotted', label))
        to_execute[label] = action_list[label]
    else
        to_execute[label] = nil
    end
end

function on_restore_click(button)
    print('Button Clicked')
    for i, action in pairs(to_execute) do
        print(string.format('%s - %s performed', i, action))
    end
end

function create_checkbox(name)
    local checkbutton = Gtk.CheckButton{
        label = name,
        on_toggled = on_check_button_toggled
    }
    return checkbutton
end

local res_folder = os.getenv("RESDIR") or os.getenv("HOME").."/awmdotfiles/res"
local header_file,err = io.open( res_folder.. "/header" )
if err then print("Unable to Open File"); return; end

local window = Gtk.Window{
    title = 'CheckButton',
    on_destroy = Gtk.main_quit,
    resizable = false,
    default_width = 200
}

local vbox = Gtk.Box{
    orientation = 'VERTICAL'
}
window:add(vbox)

local label = Gtk.Label{
    label = 'Restore Utility'
}
vbox:pack_start(label, false, false, 0)

local listbox = Gtk.ListBox{}
vbox:pack_start(listbox, false, false, 0)

local btn_restore = Gtk.Button{
    label = 'Restore',
    on_clicked = on_restore_click
    }
vbox:pack_start(btn_restore, false, false, 0)

while true do
    line = header_file:read()
    if line == nil then break end
    print (line)
    for k, v in string.gmatch(line, "(%w[%w ]*):(%w+)") do
        action_list[k] = v
        local checkbutton = create_checkbox(k)
        listbox:insert(checkbutton, -1)
    end
end

header_file:close()
window:show_all()

Gtk:main()

