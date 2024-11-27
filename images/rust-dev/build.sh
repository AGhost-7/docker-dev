#!/usr/bin/env zsh

set -eo pipefail

set -x

curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$RUST_DEFAULT_TOOLCHAIN"

source "$HOME/.cargo/env"

# Install cargo file watcher
cargo install cargo-watch

# required for goto source to work with the standard library
rustup component add rust-src --toolchain "$RUST_DEFAULT_TOOLCHAIN"

# Install new plugins.
nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'
