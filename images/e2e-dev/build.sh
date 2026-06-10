#!/usr/bin/env bash

sudo apt-get update
#sudo apt-get install -y libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

# needed for headless chromium
sudo apt-get install --no-install-recommends -y libglib2.0-0t64 \
  libnspr4 \
  libnss3 \
  libatk1.0-0t64 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libxkbcommon0 \
  libasound2t64 \
  libatspi2.0-0t64

sudo chown -R $USER:$USER ~/.config/nvim/plugins 
nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

sudo rm -rf /var/lib/apt/lists/*
