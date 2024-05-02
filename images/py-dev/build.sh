#!/usr/bin/env bash

set -e
set -x

if [ "$UBUNTU_RELEASE" = "jammy" ]; then
	sudo python3 -m pip install jedi virtualenv ptpython neovim pipenv poetry
else
	sudo python3 -m pip install --break-system-packages jedi virtualenv ptpython neovim pipenv poetry
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends python3-dev python3-venv

cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim
sudo rm /tmp/plugin.vim
cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim
sudo rm /tmp/post-plugin.vim

sudo apt-get install --no-install-recommends -y cmake
nvim +PlugInstall +qall
python3 "$HOME/.config/nvim/plugged/YouCompleteMe/install.py"
sudo apt-get purge cmake -y
sudo rm -rf /var/lib/apt/lists/*

# needed for the pre-commit hook to read from the pyproject.toml file
if [ "$UBUNTU_RELEASE" = "jammy" ]; then
	pip install --user tomlkit
else
	pip install --user --break-system-packages tomlkit
fi

# add shims for ale to work with poetry virtualenvs
sudo chown -R "$USER:$USER" "$HOME/.local"
for program in flake8 mypy bandit black; do
	ln -s "$HOME/.local/bin/ale-poetry-shim" "$HOME/.local/bin/$program"
done
