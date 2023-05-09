#!/usr/bin/env bash

rm -rf ~/.config/nvim
git clone --depth=1 --branch=main https://github.com/piotrpersona/nvim.git ~/.config/nvim
rm -rf ~/.config/nvim/.git
