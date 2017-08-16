#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge "${HOME}/.Xresources"
export QT_QPA_PLATFORMTHEME=gtk2
export DESKTOP_SESSION=gnome

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

xset -b
xset r rate 330 75
setxkbmap -layout "us,pt" -variant altgr-intl -option "grp:alt_shift_toggle" \
  -option caps:swapescape -option terminate:ctrl_alt_bksp

if [ "$(cat /etc/hostname)" = "atreides" ]; then
  xrandr --output HDMI-A-0 --primary --auto --right-of DVI-I-1
elif [ "$(cat /etc/hostname)" = "harkonnen" ]; then
  blueman-applet
elif [ "$(cat /etc/hostname)" = "jguerreiro.multicert.inet" ]; then
  xrandr --output VGA1 --primary --left-of LVDS1
fi

eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

compton &
xss-lock -- i3lock -t -c 282828 -e -i "$HOME/.config/awesome/themes/ngruvbox/background.jpg" &
redshift -l 38.72:-9.15 -t 5000:3400 &
start-pulseaudio-x11 &
nm-applet --sm-disable &
exec awesome
