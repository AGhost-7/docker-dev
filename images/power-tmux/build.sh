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
	# libevent is a run-time requirement. *-dev are for the header files.
	local libevent_version=2.0-5
	if [ "$UBUNTU_RELEASE" == "bionic" ]; then
		libevent_version=2.1-6
	fi
	apt-install "libevent-$libevent_version" libevent-dev libncurses-dev
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

install-tmate() {
	curl -o /tmp/tmate.tar.gz -L https://github.com/tmate-io/tmate/releases/download/2.2.1/tmate-2.2.1-static-linux-amd64.tar.gz
	tar -xzf /tmp/tmate.tar.gz -C /tmp
	sudo cp /tmp/tmate-2.2.1-static-linux-amd64/tmate /usr/local/bin/tmate
	rm -rf /tmp/tmate*
}

sudo apt-get update

# Fix file permissions from the copy
sudo chown -R aghost-7:aghost-7 "$HOME/.config"
sudo chown aghost-7:aghost-7 /home/aghost-7/.tmux.conf
sudo chown $USER:$USER ~/.tmate.conf

# Need to update package cache...
sudo apt-get update

install-powerline

install-tmux

install-tmate

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
