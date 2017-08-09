## Usage

[Read here.](https://github.com/copycat-killer/lain/wiki/Widgets#usage)

### Description

Shows PulseAudio volume with a progressbar; provides tooltips and notifications.

```lua
local volume = lain.widget.pulsebar()
```

## Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | number | 5
`settings` | User settings | function | empty function
`width` | Bar width | number | 63
`height` | Bar height | number | 1
`ticks` | Set bar ticks on | boolean | false
`ticks_size` | Ticks size | number | 7
`cmd` | PulseAudio command | string | same as [here](https://github.com/copycat-killer/lain/wiki/pulseaudio)
`scallback` | [PulseAudio sink callback](https://github.com/copycat-killer/lain/wiki/pulseaudio/) | function | `nil`
`sink` | Mixer sink | number | 0
`colors` | Bar colors | table | see [Default colors](https://github.com/copycat-killer/lain/wiki/pulsebar#default-colors)
`notification_preset` | Notification preset | table | See [default `notification_preset`](https://github.com/copycat-killer/lain/wiki/pulsebar#default-notification_preset)
`followtag` | Display the notification on currently focused screen | boolean | false

`settings` can use [these variables](https://github.com/copycat-killer/lain/wiki/pulseaudio#settings-variables).

### Default colors

Variable | Meaning | Type | Default
--- | --- | --- | ---
`background` | Bar backgrund color | string | "#000000"
`mute` | Bar mute color | string | "#EB8F8F"
`unmute` | Bar unmute color | string | "#A4CE8A"

### Default `notification_preset`

```lua
notification_preset = {
    font = "Monospace 10"
}
```

## Output table

Variable | Meaning | Type
--- | --- | ---
`bar` | The widget | `wibox.widget.progressbar`
`sink` | PulseAudio sink | string
`notify` | The notification | function
`update` | Update state | function
`tooltip` | The tooltip | `awful.tooltip`

In multiple screen setups, the default behaviour is to show a visual notification pop-up window on the first screen. By setting `followtag` to `true` it will be shown on the currently focused tag screen.

## Buttons

If you want buttons, just add the following after your widget in `rc.lua`.

```lua
volume.bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn(string.format("pactl set-sink-volume %d 100%%", volume.sink))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("pactl set-sink-mute %d toggle", volume.sink))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("pactl set-sink-volume %d +1%%", volume.sink))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("pactl set-sink-volume %d -1%%", volume.sink))
        volume.update()
    end)
))
```

## Keybindings

Read [here](https://github.com/copycat-killer/lain/wiki/pulseaudio#keybindings). If you want notifications, use `volume.notify()` instead of `volume.update()`.