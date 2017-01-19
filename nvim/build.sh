#!/usr/bin/env bash

set -e

set -x

sudo apt-get update

apt-install () {
	sudo apt-get install -y --no-install-recommends "$@"
}

apt-install software-properties-common -y

# Fix the permissions from the copy...
sudo chown -R aghost-7:aghost-7 /home/aghost-7/.config/nvim

# Install neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
apt-install neovim -y

# Install neovim python api.
sudo pip install neovim

# Add environment variables and `vim` alias.
cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc

sudo rm /tmp/bashrc-additions.sh

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all plugins.
nvim +PlugInstall +qall

# Shellcheck: Grade A shell script linter
git clone -b v0.4.5 https://github.com/koalaman/shellcheck.git /tmp/shellcheck
apt-install haskell-platform
cabal update
cd /tmp/shellcheck
cabal install --force-reinstalls
sudo cp ~/.cabal/bin/shellcheck /usr/local/bin/shellcheck

# Install ctags for code jump
apt-install exuberant-ctags

# Cleanups
sudo apt-get purge software-properties-common haskell-platform -y
sudo apt-get autoremove -y
sudo apt-get clean
rm -rf /tmp/shellcheck
rm -rf ~/.cabal
sudo rm -rf /var/lib/apt/lists/*
