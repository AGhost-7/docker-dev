#!/usr/bin/env bash

set -e

set -x

apt-install() {
	sudo apt-get install -y --no-install-recommends "$@"
}

sudo apt-get update

# Install rust!
curl -sSf https://static.rust-lang.org/rustup.sh | sh

# Add new plugins.
cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
nvim +PlugInstall +qall

# Install racer completer/recompile ycmd
apt-install cmake build-essential
/home/aghost-7/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer

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

ycm-install --racer-completer

sudo apt-get purge build-essential cmake -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
