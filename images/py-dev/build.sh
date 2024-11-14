#!/usr/bin/env bash

set -e
set -x


sudo apt-get update
sudo apt-get install -y --no-install-recommends python3-dev python3-venv pipx

pipx install poetry ptpython

sudo chown -R $USER:$USER ~/.config/nvim

nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

# needed for the pre-commit hook to read from the pyproject.toml file
pip install --user --break-system-packages tomlkit
