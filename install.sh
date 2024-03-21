#!/usr/bin/env bash

rm -rf ~/.config/nvim/*
cp -r "$( dirname ${0})/" ~/.config/nvim
rm -rf ~/.config/nvim/.git

pip3 install pynvim

git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim
