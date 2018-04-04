#!/bin/sh

userresources=$HOME/.Xresources

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output HDMI-A-0 --primary --auto --right-of DVI-I-1
fi

xset -b r rate 190 35 &
setxkbmap -layout "us,pt" -variant altgr-intl -option "grp:alt_shift_toggle" \
  -option caps:swapescape -option terminate:ctrl_alt_bksp &

eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
dbus-update-activation-environment --systemd DISPLAY
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
export SSH_AUTH_SOCK

exec awesome
