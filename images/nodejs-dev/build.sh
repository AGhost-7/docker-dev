#!/usr/bin/env bash

set -e

set -x

for file in plugin post-plugin; do
	cat "/tmp/$file.vim" >> "$HOME/.config/nvim/$file.vim"
	sudo rm "/tmp/$file.vim"
done

# Install node version manager
curl -o- https://raw.githubusercontent.com/AGhost-7/nvm/v0.33.11/install.sh | zsh

# Install yarn without nodejs. The package being at the system-level means it
# will still be available if you switch node version.
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install --no-install-recommends -y yarn

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
nvim +PlugInstall +qall


. ~/.nvm/nvm.sh

nvm install 20
nvm alias default stable

yarn global add flip-table
sudo apt-get update
ycm-install --ts-completer
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf ~/.cache/yarn/*
