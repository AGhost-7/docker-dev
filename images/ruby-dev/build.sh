#!/usr/bin/env bash

set -eo pipefail

# Install rvm for managing different ruby versions.
gpg --keyserver hkp://keys.gnupg.net --recv-keys \
	409B6B1796C275462A1703113804BB82D39DC0E3 \
	7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

# Make rvm completions available
cat - >> ~/.bashrc <<BASHRC
[[ -r \$rvm_path/scripts/completion ]] && . \$rvm_path/scripts/completion
BASHRC

sudo apt-get update

# base ruby distribution
sudo apt-get install -y ruby

# Install stuff that rvm will install itself if not already present...
sudo apt-get install -y gawk zlib1g-dev libyaml-dev libsqlite3-dev sqlite3 \
	autoconf libgmp-dev libgdbm-dev automake libtool bison pkg-config libffi-dev \
	libgmp-dev libreadline6-dev libssl-dev

# Plugins
cat - >> ~/.config/nvim/plugin.vim <<PLUGINS
Plug 'vim-ruby/vim-ruby'
PLUGINS

# Install plugins ^^
nvim +PlugInstall +qall

# Cleanup
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*
