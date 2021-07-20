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
code --install-extension PKief.material-icon-theme
code --install-extension christian-kohler.path-intellisense
code --install-extension eamodio.gitlens
code --install-extension enkia.tokyo-night
code --install-extension esbenp.prettier-vscode
code --install-extension foxundermoon.shell-format
code --install-extension golang.go
code --install-extension mhutchie.git-graph
code --install-extension mikestead.dotenv
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension naumovs.color-highlight
code --install-extension oderwat.indent-rainbow
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension sumneko.lua
code --install-extension tamasfe.even-better-toml
code --install-extension vscodevim.vim
