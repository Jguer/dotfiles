#!/bin/sh

# Launch dbus
if [ -d /etc/X11/xinit/xinitrc.d ]; then

  for f in /etc/X11/xinit/xinitrc.d/?*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Load our X resources
[[ -f ~/.config/.Xresources ]] && xrdb -merge -I$HOME/.config/.Xresources.d ~/.config/.Xresources

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output HDMI-1 --primary --auto --right-of DVI-I-1
fi

# xset r rate 300 40
setxkbmap -model "evdev" -rules "evdev" \
  -layout "us,pt" -variant "altgr-intl,sundeadkeys" \
  -option "grp:alt_shift_toggle" -option caps:swapescape -option terminate:ctrl_alt_bksp &
unclutter -noevents -idle 2 -jitter 1 -root &
eval "$(gnome-keyring-daemon --replace --daemonize --components=secrets,ssh,pcks11)"
export SSH_AUTH_SOCK

lxpolkit &
nm-applet &
numlockx &
start-pulseadio-x11 &
compton &
redshift -l 38.72:-9.15 &

exec dbus-launch --sh-syntax --exit-with-session awesome
