#!/usr/bin/env bash


. ~/.nvm/nvm.sh

set -e

nvm install "$1"
nvm alias default stable

# needed to work around bug in npm
npm install	-g npm@6 || true
sudo chown -R $USER:$USER ~/.npm
npm install -g npm@6
rm -rf ~/.npm/*
npm -v

yarn global add flip-table
sudo apt-get update
ycm-install --ts-completer
sudo rm -rf /var/lib/apt/lists/*
yarn cache clean
