#!/usr/bin/bash
dbus-daemon --session &
start-pulseaudio-x11

eval `ssh-agent -s`
dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output DVI-D-1 --primary --auto --right-of HDMI-A-0
fi

setxkbmap -model "evdev" -rules "evdev" \
  -layout "us,pt" -variant "altgr-intl,sundeadkeys" \
  -option "grp:alt_shift_toggle" -option caps:swapescape -option terminate:ctrl_alt_bksp

compton --config ~/.compton.conf &

exec awesome
