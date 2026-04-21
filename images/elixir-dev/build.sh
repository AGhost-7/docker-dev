#!/usr/bin/env bash

set -exo pipefail

# install asdf, a version manager like nvm
curl -L -o /tmp/asdf.tar.gz https://github.com/asdf-vm/asdf/releases/download/v0.18.1/asdf-v0.18.1-linux-amd64.tar.gz
tar xvf /tmp/asdf.tar.gz -C /tmp
mv /tmp/asdf ~/.local/bin
~/.local/bin/asdf plugin add erlang
~/.local/bin/asdf plugin add elixir
sudo apt-get update
sudo apt-get install --no-install-recommends -y libncurses-dev libssl-dev
echo 'export PATH="$HOME/.asdf/shims:$PATH"' >> ~/.zshrc

nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

sudo rm -rf /var/lib/apt/lists/*
