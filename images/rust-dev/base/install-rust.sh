#!/usr/bin/env bash

set -eo pipefail

set -x

sudo chown "$USER":"$USER" $HOME/.rust-toolchain
sudo chown -R "$USER":"$USER" $HOME/.cargo

toolchain="$(cat ~/.rust-toolchain)"
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$toolchain"

echo "export RUST_DEFAULT_TOOLCHAIN='$toolchain'" >> ~/.profile

# Source to update path
. ~/.profile

# Install cargo file watcher
cargo install cargo-watch

# required for goto source to work with the standard library
rustup component add rust-src --toolchain "$toolchain"

# Install new plugins.
nvim +PlugInstall +qall

# Install racer completer with ycmd
sudo apt-get update
ycm-install --racer-completer
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
