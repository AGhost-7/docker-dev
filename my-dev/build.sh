#!/usr/bin/env bash

set -e

apt-get update

apt-get install --no-install-recommends curl python-pip python-dev build-essential less -y

pip install mycli

apt-get purge build-essential python-dev -y
rm -rf /var/lib/apt/lists/*
