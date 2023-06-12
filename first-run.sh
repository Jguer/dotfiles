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
code-insiders --install-extension --pre-release eamodio.gitlens
code-insiders --install-extension --pre-release enkia.tokyo-night
code-insiders --install-extension --pre-release GitHub.copilot-chat
code-insiders --install-extension --pre-release GitHub.copilot-labs
code-insiders --install-extension --pre-release GitHub.copilot-nightly
code-insiders --install-extension --pre-release golang.go
code-insiders --install-extension --pre-release hashicorp.terraform
code-insiders --install-extension --pre-release ms-azuretools.vscode-docker
code-insiders --install-extension --pre-release ms-kubernetes-tools.vscode-kubernetes-tools
code-insiders --install-extension --pre-release ms-python.python
code-insiders --install-extension --pre-release ms-python.vscode-pylance
code-insiders --install-extension --pre-release ms-vsliveshare.vsliveshare
code-insiders --install-extension --pre-release PKief.material-icon-theme
code-insiders --install-extension --pre-release redhat.vscode-yaml
code-insiders --install-extension --pre-release streetsidesoftware.code-spell-checker
code-insiders --install-extension --pre-release tilt-dev.tiltfile
code-insiders --install-extension --pre-release vscodevim.vim

gsettings set org.gnome.desktop.interface icon-theme 'Tokyonight-Dark-Cyan'
gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Storm'
