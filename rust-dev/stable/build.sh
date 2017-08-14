#!/usr/bin/env bash

set -e

set -x

# Add new plugins.
cat /tmp/post-plugin.vim ~/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim
nvim +PlugInstall +qall

sudo apt-get update
# Install racer completer with ycmd
ycm-install --racer-completer
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
