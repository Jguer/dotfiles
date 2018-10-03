#!/usr/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
   eval $(dbus-launch --sh-syntax --exit-with-session)
   export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
fi

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output DVI-D-1 --primary --auto --right-of HDMI-A-0
  export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
fi

# xset r rate 300 40
setxkbmap -model "evdev" -rules "evdev" \
  -layout "us,pt" -variant "altgr-intl,sundeadkeys" \
  -option "grp:alt_shift_toggle" -option caps:swapescape -option terminate:ctrl_alt_bksp &

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
unclutter -noevents -idle 2 -jitter 1 -root &
nm-applet &
numlockx &
start-pulseadio-x11 &
compton --config ~/.compton.conf &
redshift -l 38.72:-9.15 &

exec awesome
