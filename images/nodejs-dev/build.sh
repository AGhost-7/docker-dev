#!/usr/bin/env bash

set -e

set -x

# fix permission issues
sudo chown -R $USER:$USER $HOME/.config/nvim

# Install node version manager
curl -o- https://raw.githubusercontent.com/AGhost-7/nvm/v0.33.11/install.sh | zsh

git clone https://github.com/chrisands/zsh-yarn-completions ~/.oh-my-zsh/custom/plugins/zsh-yarn-completions
echo 'plugins+=(zsh-yarn-completions)' >> ~/.zshrc

# customize fzf to ignore node_modules
cat /tmp/zshrc-additions.sh >> ~/.zshrc
sudo rm /tmp/zshrc-additions.sh

# Cleanup whats left...
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Install vim plugins
nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

. ~/.nvm/nvm.sh

nvm install --lts
nvm alias default $(node --version)

npm install -g corepack

yarn dlx flip-table
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf ~/.cache/yarn/*
