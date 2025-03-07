#!/usr/bin/env bash

[[ ! -d ~/.dotfiles_backup ]] && mkdir -p ~/.dotfiles_backup

for LN_PATH in \
    ".config/btop/btop.conf" \
    ".config/lsd/config.yaml" \
    ".config/lsd/icons.yaml" \
    ".p10k.zsh"; do
    # don't move symbolic links
    if [[ -f ~/${LN_PATH} ]]; then
        cp -a ~/${LN_PATH} ~/.dotfiles_backup/${LN_PATH}
    fi

    ln -sf ~/.dotfiles/intall/${LN_PATH} ~/${LN_PATH}
done
