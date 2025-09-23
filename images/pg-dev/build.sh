#!/usr/bin/env bash

set -e

apt-get update 
apt-get install -y --no-install-recommends pipx

export PIPX_BIN_DIR=/usr/local/bin
pipx install pgcli

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
