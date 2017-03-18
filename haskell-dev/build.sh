#!/usr/bin/env bash

set -e

sudo apt-get update

ycm-install

sudo apt-get install --no-install-recommends haskell-platform -y

use-nvim-config() {
	cat "/tmp/$1" >> "$HOME/.config/nvim/$1"
	sudo rm "/tmp/$1"
}

use-nvim-config post-plugin.vim
use-nvim-config plugin.vim

nvim +PlugInstall +qall
