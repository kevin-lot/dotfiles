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

if [[ "${OS}" == "fedora" ]]; then
    ln -sf ~/.dotfiles/config/Cursor/User/keybindings.json ~/.config/Cursor/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/settings.json ~/.config/Cursor/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/keybindings.json ~/.config/Code/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/settings.json ~/.config/Code/User/.
else
    ln -sf ~/.dotfiles/config/Cursor/User/keybindings.json ~/Library/Application\ Support/Cursor/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/settings.json ~/Library/Application\ Support/Cursor/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/keybindings.json ~/Library/Application\ Support/Cursor/User/.
    ln -sf ~/.dotfiles/config/Cursor/User/settings.json ~/Library/Application\ Support/Cursor/User/.
fi
