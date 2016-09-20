#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -e

# Print every line executed to the terminal
set -x

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

sudo apt-get update

# Super essential tools
apt-install tree curl

# Going to need this a lot
apt-install python-pip

# See readme for how to get the clipboard working.
apt-install xclip

# For dockerception
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker aghost-7
cat /etc/group

sudo pip install docker-compose

# Man pages on base debian image aren't installed...
apt-install man-db

# tldr for a short form man pages.
sudo pip install tldr

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc.
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# Packet sniffer for debugging.
apt-install tcpdump

# Blazing fast search tool.
apt-install silversearcher-ag

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# cache is useless to keep
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

