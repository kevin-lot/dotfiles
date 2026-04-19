#!/usr/bin/env bash

#set -o xtrace -o errexit
set -o errexit

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "${OS}" == "linux" ]]; then
    OS=$(uname -n | tr '[:upper:]' '[:lower:]')
fi

ln -sf ~/.dotfiles/config/fontconfig ~/.config/.
ln -sf ~/.dotfiles/config/lazygit ~/.config/.
ln -sf ~/.dotfiles/config/lsd ~/.config/.
ln -sf ~/.dotfiles/config/micro ~/.config/.
ln -sf ~/.dotfiles/config/niri ~/.config/.
ln -sf ~/.dotfiles/config/niriswitcher ~/.config/.
ln -sf ~/.dotfiles/config/noctalia ~/.config/.
ln -sf ~/.dotfiles/config/terminator ~/.config/.
ln -sf ~/.dotfiles/config/zsh ~/.config/.
ln -sf ~/.dotfiles/config/starship.toml ~/.config/.
