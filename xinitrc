#!/bin/sh

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/Xresources

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

# Launch dbus
if [ -d /etc/X11/xinit/xinitrc.d ]; then

  for f in /etc/X11/xinit/xinitrc.d/?*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output HDMI-A-0 --primary --auto --right-of DVI-I-1
fi

xset r rate 300 40
setxkbmap -layout "us,pt" -variant altgr-intl -option "grp:alt_shift_toggle" \
  -option caps:swapescape -option terminate:ctrl_alt_bksp &

unclutter -noevents -idle 2 -jitter 1 -root &>/dev/null &

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

exec awesome
