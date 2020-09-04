#!/usr/bin/env bash

set -e

set -x

for file in plugin post-plugin; do
	cat "/tmp/$file.vim" >> "$HOME/.config/nvim/$file.vim"
	sudo rm "/tmp/$file.vim"
done

# used in the install.sh https://github.com/denoland/deno_install#unzip-is-required
sudo apt-get update

# Install Deno 🦕
curl -fsSL https://deno.land/x/install/install.sh | sh

# add Deno bash completion
if [ ! -d "/usr/local/etc/bash_completion.d" ]; then
	sudo mkdir -p "/usr/local/etc/bash_completion.d"
	sudo chown "$USER:$USER" "/usr/local/etc/bash_completion.d"
fi

sudo "$HOME/.deno/bin/deno" completions bash > "/usr/local/etc/bash_completion.d/deno.bash"

# add source for completions
cat /tmp/bashrc-additions.sh >> ~/.bashrc
sudo rm /tmp/bashrc-additions.sh

ycm-install

# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Install vim plugins
nvim +PlugInstall +qall
