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
curl -L -o /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz
sudo tar xvf /tmp/nvim.tar.gz -C /usr/local --strip-components=1
rm -rf /tmp/nvim.tar.gz
sudo pip install --break-system-package pynvim

# Install all plugins.
nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

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
