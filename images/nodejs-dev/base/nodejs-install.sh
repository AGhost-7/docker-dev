#!/usr/bin/env bash

set -e

. ~/.nvm/nvm.sh

nvm install "$1"
nvm alias default stable
npm install	-g npm@6 # needed to work around bug in npm
yarn global add flip-table
sudo apt-get update
ycm-install --ts-completer
rm -rf /var/lib/apt/lists/*
yarn cache clean
