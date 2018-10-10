#!/usr/bin/env bash

set -e

set -x

for file in plugin post-plugin; do
	cat "/tmp/$file.vim" >> "$HOME/.config/nvim/$file.vim"
	sudo rm "/tmp/$file.vim"
done

# Install node version manager
curl -o- https://raw.githubusercontent.com/AGhost-7/nvm/v0.33.11/install.sh | bash

# customize fzf to ignore node_modules
cat /tmp/bashrc-additions.sh >> ~/.bashrc
sudo rm /tmp/bashrc-additions.sh

sudo apt-get update
ycm-install

# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Install vim plugins
nvim +PlugInstall +qall

