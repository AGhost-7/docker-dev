#!/usr/bin/env bash

set -ex

sudo apt-get update
sudo apt-get install -y cmake gdb
sudo apt-get install -y --no-install-recommends valgrind

# Download latest clang and build cquery completion engine.
git clone https://github.com/cquery-project/cquery.git --recursive /tmp/cquery
cd /tmp/cquery
git submodule update --init
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
cmake --build .
sudo cmake --build . --target install
cd /

# Add plugins and customizations.
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
nvim +PlugInstall +qall

# Clean up.
sudo rm -rf /tmp/cquery
sudo rm /tmp/post-plugin.vim
sudo rm /tmp/plugin.vim
sudo rm -rf /var/lib/apt/lists/*
