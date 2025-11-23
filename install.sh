#!/usr/bin/env bash

for LN_PATH in ./.config/*; do
    ln -sf ~/.dotfiles/install/${LN_PATH} ~/${LN_PATH}
done
