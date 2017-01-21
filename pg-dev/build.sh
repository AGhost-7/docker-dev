#!/usr/bin/env bash

set -e

apt-get update 
apt-get install build-essential python-pip python-dev postgresql-server-dev-9.3 git -y

# Install pgcli through my fork to have the configurable auto_expand.
git clone https://github.com/AGhost-7/pgcli.git /tmp/pgcli
cd /tmp/pgcli
pip install .
cd /
rm -rf /tmp/pgcli

apt-get purge python-dev postgresql-server-dev-9.3 build-essential git -y
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
