## Usage

[Read here.](https://github.com/copycat-killer/lain/wiki/Widgets#usage)

### Description

Shows [Google Play Music Desktop Player](http://www.googleplaymusicdesktopplayer.com) status.

```lua
local mygpmdp = lain.widget.contrib.gpmdp()
```

Now playing songs are notified like this:

	+--------------------------------------------------------+
	| +-------+                                              |
	| |/^\_/^\| Now playing                                  |
    | |\ O O /| Cannibal Corpse (Hammer Smashed Face) - 1993 |
    | | '.o.' | Hammer Smashed Face (Radio Disney Version)   |
	| +-------+                                              |
	+--------------------------------------------------------+

## Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | number | 2
`notify` | Show notification popups | string | "off"
`file_location` |
`followtag` | Display the notification on currently focused screen | boolean | false
`settings` | User settings | function | empty function

`settings` can use `gpm_now` table, which contains the following *strings*:

- artist
- title
- album
- cover_url
- playing

and can modify `gpmdp_notification_preset` table, which will be the preset for the naughty notifications. Check [here](http://awesome.naquadah.org/doc/api/modules/naughty.html#notify) for the list of variables it can contain. Default definition:

```lua
gmpd_notification_preset = {
   title   = "Now playing",
   timeout = 6,
   text    = string.format("%s (%s) - %s", gpm_now.artist,
             gpm_now.album gpm_now.title)
}
```

In multiple screen setups, the default behaviour is to show a visual notification pop-up window on the first screen. By setting `followtag` to `true` it will be shown on the currently focused tag screen.

## Output table

Variable | Meaning | Type
--- | --- | ---
`widget` | The widget | `wibox.widget.textbox`
`update` | Update `widget` | function
`timer` | The widget timer | [`gears.timer`](https://awesomewm.org/doc/api/classes/gears.timer.html)

The `update` function can be used to refresh the widget before `timeout` expires.

You can use `timer` to start/stop the widget as you like.