#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

sudo apt-get update

# Fix file permissions from the copy
sudo chown -R aghost-7:aghost-7 /home/aghost-7/.config
sudo chown aghost-7:aghost-7 /home/aghost-7/.tmux.conf

apt-install software-properties-common fontconfig

# Add tmux repo for latest
sudo add-apt-repository -y ppa:pi-rho/dev

# Need to update package cache...
sudo apt-get update

# Need this for proper fonts....
apt-install language-pack-en-base
sudo dpkg-reconfigure locales
sudo apt-get purge language-pack-en-base -y

# Install tmux
apt-install tmux

# POWER TMUX
sudo pip install powerline-status

# Install the nice powerline fonts :)
git clone https://github.com/powerline/fonts.git /tmp/fonts
/tmp/fonts/install.sh
sudo rm -r /tmp/fonts

# Add fzf fuzzy finder
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Add bashrc addons for powerline and etc.
cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc
sudo rm /tmp/bashrc-additions.sh

# Cleanup deps
sudo apt-get purge software-properties fontconfig -y

# Cleanup cache
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

