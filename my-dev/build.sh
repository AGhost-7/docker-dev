#!/usr/bin/env bash

apt-get update

apt-get install --no-install-recommends curl python-pip python-dev build-essential -y

curl -L --create-dirs -o /root/.config/mycli \
    https://raw.githubusercontent.com/AGhost-7/docker-dev/master/pg-dev/pgcliconfig

pip install mycli

apt-get purge build-essential python-dev -y
rm -rf /var/lib/apt/lists/*
