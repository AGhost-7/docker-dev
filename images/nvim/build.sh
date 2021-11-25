#!/usr/bin/env bash

set -ex

sudo apt-get update

apt-install () {
	sudo apt-get install -y --no-install-recommends "$@"
}

apt-install software-properties-common -y

# Fix the permissions from the copy...
sudo chown -R "$USER:$USER" "$HOME/.config/nvim"

sudo chown "$USER:$USER" "$HOME/.editorconfig"

sudo apt-get update

# Install neovim
curl -o /tmp/nvim.appimage -L https://github.com/neovim/neovim/releases/download/v0.5.1/nvim.appimage
chmod +x /tmp/nvim.appimage
cd /tmp
/tmp/nvim.appimage --appimage-extract
cd /tmp/squashfs-root
find . -type f -path './usr/*' | sed 's#./##' | while read line; do sudo mkdir -p "$(dirname "/$line")"; sudo mv "$line" "/$line"; done
rm -rf /tmp/{nvim.appimage,squashfs-root}
cd ~/

# Install neovim python api.
sudo pip3 install neovim

# Python 3 api required for denite.vim
apt-install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install setuptools
sudo pip3 install neovim

# Add environment variables and `vim` alias.
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"

sudo rm /tmp/bashrc-additions.sh

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all plugins.
nvim +PlugInstall +qall

# Shellcheck: shell script linter
apt-install shellcheck

# Install ctags for code jump
apt-install exuberant-ctags

# Install editorconfig cli needed for vim plugin
apt-install editorconfig

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
rm -rf /tmp/shellcheck
rm -rf ~/.cabal
sudo rm -rf /var/lib/apt/lists/*
