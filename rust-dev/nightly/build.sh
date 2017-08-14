#!/usr/bin/env bash

set -e
set -x

. ~/.profile

rustup component add rls --toolchain nightly
rustup component add rust-analysis --toolchain nightly
rustup component add rust-src --toolchain nightly

cargo install racer

cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim

nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall

