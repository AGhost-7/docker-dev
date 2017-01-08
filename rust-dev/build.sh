#!/usr/bin/env bash

set -e

set -x

apt-install() {
	sudo apt-get install -y --no-install-recommends "$@"
}

sudo apt-get update

# Install rust!
curl https://sh.rustup.rs -sSf | sh -s -- -y

. ~/.bashrc

# Add new plugins.
cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
nvim +PlugInstall +qall

# Install racer completer with ycmd
ycm-install --racer-completer

# I need the header files in this one so I can compile against it for hyper.
apt-install libssl-dev

# Install cargo file watcher
cargo install cargo-watch

# Compiler message prettifier
git clone https://github.com/ticki/dybuk.git
cargo install --path dybuk
rm -rf dybuk

# Put in profile to always have the path set properly
echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> /home/aghost-7/.profile

sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
