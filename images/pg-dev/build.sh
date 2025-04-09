#!/usr/bin/env bash

set -e

apt-get update 
apt-get install -y \
	build-essential \
	python3-pip \
	python3-dev \
	postgresql-server-dev-16 \
	git

pip install --break-system-packages pgcli

apt-get purge python3-dev postgresql-server-dev-16 build-essential git -y
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
