#!/usr/bin/env bash

set -e

set -x

if [ "$NODE_VERSION" == "" ]; then
	echo 'NODE_VERSION not set'
	exit 1
fi

tmp-download() {
	curl -o "/tmp/$1" "https://raw.githubusercontent.com/AGhost-7/docker-dev/master/nodejs-dev/$1"
}

tmp-download plugin.vim
cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim
rm /tmp/plugin.vim

tmp-download post-plugin.vim
cat /tmp/post-plugin.vim >> /home/aghost-7/.config/nvim/post-plugin.vim
rm /tmp/post-plugin.vim

# Install node version manager
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash

# customize fzf to ignore node_modules
tmp-download bashrc-additions.sh
cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc
rm /tmp/bashrc-additions.sh

# Install specified node version.
. /home/aghost-7/.nvm/nvm.sh
echo "Installing node version $NODE_VERSION"
nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# jq, the greatest command line JSON querier
sudo apt-get update
sudo apt-get install jq -y

# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Install vim plugins
nvim +PlugInstall +qall
