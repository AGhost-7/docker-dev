#!/usr/bin/env bash

apt-get update

apt-get install --no-install-recommends curl python-pip python-dev build-essential less -y

git clone https://github.com/AGhost-7/mycli.git /tmp/mycli

cp /tmp/mycli
pip install .
rm -rf /tmp/mycli

apt-get purge build-essential python-dev -y
rm -rf /var/lib/apt/lists/*
