#!/usr/bin/env bash

cd ./config
for LN_PATH in ./*; do
    if [[ -L ~/.config/${LN_PATH} ]]; then continue; fi
    ln -s ~/.dotfiles/config/${LN_PATH} ~/.config/${LN_PATH}
done
