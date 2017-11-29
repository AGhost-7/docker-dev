#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -e

# Print every line executed to the terminal
set -x

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

apt-get update

# Super essential tools
apt-install tree curl

# Going to need this a lot
apt-install python-pip

pip install --upgrade pip

pip install setuptools

# See readme for how to get the clipboard working.
apt-install xclip

# For dockerception
curl -sSL https://get.docker.com/ | sh
usermod -aG docker aghost-7
cat /etc/group

pip install docker-compose

# Man pages on base debian image aren't installed...
apt-install man-db

# tldr for a short form man pages.
pip install tldr

# Just gitgud
pip install gitgud

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc.
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# Packet sniffer for debugging.
apt-install tcpflow

# Very usefull for finding issues coming from syscalls
apt-install strace

# Blazing fast search tool.
apt-install silversearcher-ag

# Install sudo command...
apt-install sudo

# Install bash tab completion.
apt-install bash-completion

# ssh
apt-install openssh-client

# get lines of code in a directory
apt-install cloc

# pager better than less...
apt-install less

# Install latest git
apt-install software-properties-common
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
apt-install git
sudo apt-get purge -y software-properties-common

# Required for so many languages this will simply be included by default.
apt-install build-essential

# Mail client for testing
apt-install swaks

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# Alias for tree view of commit history.
git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"
# cache is useless to keep
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

