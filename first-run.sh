#!/bin/bash
# Heavy installs
set -e

# Fira font
mkdir -p ~/.fonts &&
    curl https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip -L -o /tmp/FiraCode.zip &&
    unzip /tmp/FiraCode -d ~/.fonts

rm -fv ~/.fonts/Fura* ~/.fonts/*Windows*

fc-cache

# Code extensions
# code --list-extensions | xargs -L 1 echo code --install-extension
code --install-extension eamodio.gitlens
code --install-extension enkia.tokyo-night
code --install-extension GitHub.copilot
code --install-extension golang.go
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension PKief.material-icon-theme
code --install-extension vscodevim.vim

gsettings set org.gnome.desktop.interface icon-theme 'oomox-tokyo-night'
gsettings set org.gnome.desktop.interface gtk-theme 'oomox-tokyo-night'
