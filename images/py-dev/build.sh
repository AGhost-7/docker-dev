#!/usr/bin/env bash

set -e
set -x

sudo python3 -m pip install flake8 jedi virtualenv ptpython neovim pipenv
sudo apt-get update
sudo apt-get install -y --no-install-recommends python3-dev 

cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim

sudo apt-get install --no-install-recommends -y cmake
nvim +PlugInstall +qall
python3 "$HOME/.config/nvim/plugged/YouCompleteMe/install.py"
sudo apt-get purge cmake -y
sudo rm -rf /var/lib/apt/lists/*
