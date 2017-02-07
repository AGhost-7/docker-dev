#!/usr/bin/env bash

set -e

apt-get update

apt-get install --no-install-recommends curl python-pip python-dev build-essential less git -y

git clone https://github.com/AGhost-7/mycli.git /tmp/mycli

cd /tmp/mycli
pip install .
cd ~/
rm -rf /tmp/mycli

apt-get purge build-essential python-dev git -y
rm -rf /var/lib/apt/lists/*
