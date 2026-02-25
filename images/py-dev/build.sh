#!/usr/bin/env bash

set -e
set -x


sudo apt-get update
sudo apt-get install -y --no-install-recommends python3-dev python3-venv pipx

pipx install poetry
export PATH="$PATH:$HOME/.local/bin"
poetry config virtualenvs.in-project true

sudo chown -R $USER:$USER ~/.config/nvim

curl -o /tmp/uv.tar.gz -L https://github.com/astral-sh/uv/releases/download/0.10.6/uv-x86_64-unknown-linux-gnu.tar.gz
tar xvf /tmp/uv.tar.gz -C /tmp --strip-components=1
mv /tmp/{uv,uvx} ~/.local/bin

nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

# needed for the pre-commit hook to read from the pyproject.toml file
pip install --user --break-system-packages tomlkit
