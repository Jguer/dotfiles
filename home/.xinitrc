#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge "${HOME}/.Xresources"

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &


setxkbmap -layout "us,pt" -variant intl -option "grp:alt_shift_toggle" \
  -option caps:swapescape -option terminate:ctrl_alt_bksp

xset -b
xset r rate 190 25

xrandr --output VGA-1 --primary --left-of LVDS-1
if [ "$(cat /etc/hostname)" = "Paladium" ]; then
  xrandr --output HDMI-A-0 --primary --auto --right-of DVI-I-1
elif [ "$(cat /etc/hostname)" = "cobalt" ]; then
  blueman-applet
fi

# gnome-keyring-daemon --start --components=pkcs11,secrets &
pcmanfm -d &
xss-lock -- i3lock -t -c 282828 -e -i "$HOME/.config/awesome/themes/ngruvbox/background.jpg" &
redshift -l 38.72:-9.15 -t 5000:3400 &
start-pulseaudio-x11
xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &
nm-applet --sm-disable &
exec awesome
