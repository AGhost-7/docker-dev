#!/usr/bin/env bash

set -eo pipefail
set -x

# Install rvm for managing different ruby versions.
sudo apt-get update
sudo apt-get install -y --no-install-recommends software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install -y rvm
sudo apt-get remove -y software-properties-common

# Make rvm completions available
cat - >> ~/.bashrc <<BASHRC
[[ -r \$rvm_path/scripts/completion ]] && . \$rvm_path/scripts/completion
BASHRC

sudo apt-get update

# base ruby distribution
sudo apt-get install -y ruby ruby-dev

# Install stuff that rvm will install itself if not already present...
sudo apt-get install -y gawk zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 \
	autoconf libgmp-dev libgdbm-dev automake libtool bison pkg-config libffi-dev \
	libgmp-dev libreadline6-dev libssl-dev

# needed for tzdata to install...
export DEBIAN_FRONTEND=noninteractive
# typically required for rails projects
echo 'Etc/UTC' | sudo tee /etc/timezone
sudo -E apt-get install -y tzdata
sudo apt-get install -y --no-install-recommends libpq-dev nodejs

# yarn for webpack stuff
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install --no-install-recommends -y yarn

# Install pry (improved repl) globally
sudo gem install pry

# semantic completion engine
sudo gem install solargraph

# proper debugger
sudo gem install byebug

# Plugins
cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim

# Install plugins ^^
nvim +PlugInstall +qall

# Cleanup
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*
sudo rm /tmp/plugin.vim
sudo rm /tmp/post-plugin.vim
