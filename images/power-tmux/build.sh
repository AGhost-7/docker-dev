#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

install-tmux() {
	local tmux_tar="tmux-$TMUX_VERSION.tar.gz"
	pushd /tmp
	curl -L -o "/tmp/tmux-$TMUX_VERSION.tar.gz" \
		"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$tmux_tar"
	tar xzf "$tmux_tar"
	local tmux_src="/tmp/tmux-$TMUX_VERSION"
	pushd "$tmux_src"
	local libevent="libevent-2.1.6" libevent_dev="libevent-dev"
	if [ "$UBUNTU_RELEASE" = "focal" ]; then
		libevent="libevent-2.1-7"
		libevent_dev="libevent-dev"
	fi
	# libevent is a run-time requirement. *-dev are for the header files.
	apt-install "$libevent_dev" "$libevent" libncurses-dev
	./configure
	make
	sudo make install
	popd
	rm -rf "$tmux_src"
	rm -rf "$tmux_tar"
	sudo apt-get purge -y libevent-dev libncurses-dev
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
sudo chown aghost-7:aghost-7 /home/aghost-7/.tmux.conf

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
