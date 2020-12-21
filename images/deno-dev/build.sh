#!/usr/bin/env bash

set -e

set -x

for file in plugin post-plugin; do
	cat "/tmp/$file.vim" >> "$HOME/.config/nvim/$file.vim"
	sudo rm "/tmp/$file.vim"
done

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

# for YMC
curl -o- https://raw.githubusercontent.com/AGhost-7/nvm/v0.33.11/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node
# install ymc
ycm-install --ts-completer


# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
