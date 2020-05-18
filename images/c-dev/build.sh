#!/usr/bin/env bash

set -ex

sudo apt-get update
sudo apt-get install -y cmake gdb
sudo apt-get install -y --no-install-recommends valgrind clang-tools clangd

# Add plugins and customizations.
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
nvim +PlugInstall +qall

# Clean up.
sudo rm /tmp/post-plugin.vim
sudo rm /tmp/plugin.vim
sudo rm -rf /var/lib/apt/lists/*
