#!/bin/bash

INSTALLER="yay -S --needed --noconfirm "
declare -a install_array
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

function usage() {
cat <<_EOT_
Usage:
  $0 dotfiles
Description:
  Restore dotfiles and applications
Operations:
  dotfiles    Restores dotfiles
  root    Restores root settings
_EOT_
exit 1
}

dotfile() {
  cp -rsfvT "$DIR/home/" "$HOME/"
  #dconf dump /org/gnome/terminal/ > gnome-terminal.dconf
  #dconf load /org/gnome/terminal/ < "$DIR/dconf/gnome-terminal.dconf"
}

restore_root_settings() {
  sudo cp -f "$DIR/root/etc/makepkg.conf" "/etc/makepkg.conf"
  sudo cp -f "$DIR/root/etc/pacman.conf" "/etc/pacman.conf"
  sudo cp -f "$DIR/root/etc/default/tlp" "/etc/default/tlp"
  sudo sed -i 's/#background=/background=\/etc\/lightdm\/background.jpg/' /etc/lightdm/lightdm-gtk-greeter.conf
}

set_wallpaper() {
  sudo cp -f "$wallpaper" "/etc/lightdm/background.jpg"
  sudo chown lightdm:lightdm "/etc/lightdm/background.jpg"
}
