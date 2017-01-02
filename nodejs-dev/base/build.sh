#!/usr/bin/env bash

set -e

set -x

cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim

cat /tmp/post-plugin.vim >> /home/aghost-7/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim

# Install node version manager
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

# customize fzf to ignore node_modules
cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc
sudo rm /tmp/bashrc-additions.sh

# jq, the greatest command line JSON querier
sudo apt-get update
sudo apt-get install jq -y

ycm-install

# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Install vim plugins
nvim +PlugInstall +qall

