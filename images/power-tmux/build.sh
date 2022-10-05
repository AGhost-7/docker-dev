#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

install-tmux() {
	pushd /tmp
	local tmux_src="/tmp/tmux"
	git clone --branch "$TMUX_VERSION" --depth 1 https://github.com/tmux/tmux.git "$tmux_src"
	pushd "$tmux_src"
	# libevent is a run-time requirement. *-dev are for the header files.
	apt-install libevent-2.1-7 libevent-dev libncurses-dev autoconf automake pkg-config bison
	sh autogen.sh
	./configure
	make
	sudo make install
	popd
	rm -rf "$tmux_src"
	sudo apt-get purge -y libevent-dev libncurses-dev autoconf automake pkg-config bison
	popd
}

install-powerline() {
	# POWER TMUX
	sudo pip3 install powerline-status

	# Make git status extra nice :)
	sudo pip3 install powerline-gitstatus
}


sudo apt-get update

# Fix file permissions from the copy
sudo chown -R aghost-7:aghost-7 "$HOME/.config"
sudo chown aghost-7:aghost-7 /home/aghost-7/.config/tmux/tmux.conf

# Need to update package cache...
sudo apt-get update

install-powerline

install-tmux

# Add fzf fuzzy finder
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Add bashrc addons for powerline and etc.
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"
sudo rm /tmp/bashrc-additions.sh

# Cleanup cache
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get autoremove -y
