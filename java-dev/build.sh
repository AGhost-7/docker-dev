#!/usr/bin/env bash

sudo apt-get update
# Probably don't need Swing and stuff so don't install it...
sudo apt-get install openjdk-9-jdk-headless -y

sudo apt-get install --no-install-recommends python3-pip python3-setuptools -y
sudo pip3 install neovim

cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim

nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall

sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*
