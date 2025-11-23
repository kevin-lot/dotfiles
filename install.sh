#!/usr/bin/env bash

cd ./config
for LN_PATH in ./*; do
    ln -sf ~/.dotfiles/config/${LN_PATH} ~/.config/${LN_PATH}
done
