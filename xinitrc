#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge "${HOME}/.Xresources"

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

xset -b r rate 190 35
setxkbmap -layout "us,pt" -variant altgr-intl -option "grp:alt_shift_toggle" \
  -option caps:swapescape -option terminate:ctrl_alt_bksp

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output HDMI-A-0 --primary --auto --right-of DVI-I-1
elif [ "$(cat /etc/hostname)" = "harkonnen" ]; then
  blueman-applet &
fi

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec awesome
