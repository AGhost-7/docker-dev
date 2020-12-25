#!/usr/bin/env bash


set -ex

sudo apt-get update

apt-install () {
	sudo apt-get install -y --no-install-recommends "$@"
}

apt-install software-properties-common -y

# Fix the permissions from the copy...
sudo chown -R aghost-7:aghost-7 "$HOME/.config/nvim"

# Install neovim
sudo apt-get update
apt-install neovim -y

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

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
rm -rf /tmp/shellcheck
rm -rf ~/.cabal
sudo rm -rf /var/lib/apt/lists/*
