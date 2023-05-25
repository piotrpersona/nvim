#!/usr/bin/env bash

rm -rf ~/.config/nvim/*
cp -r "$( dirname ${0})/" ~/.config/nvim
rm -rf ~/.config/nvim/.git

