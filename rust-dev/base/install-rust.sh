#!/usr/bin/env bash

set -e

set -x

toolchain="$(cat ~/.rust-toolchain)"
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$toolchain"

# Source to update path
. ~/.profile

# Install cargo file watcher
cargo install cargo-watch

# Compiler message prettifier
git clone https://github.com/ticki/dybuk.git
cargo install --path dybuk
rm -rf dybuk
