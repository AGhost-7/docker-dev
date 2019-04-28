#!/usr/bin/env bash

set -e

pg_version="$1"

apt-get update 
apt-get install -y \
	build-essential \
	python-pip \
	python-dev \
	postgresql-server-dev-"$pg_version" \
	git

pip install pgcli

apt-get purge python-dev postgresql-server-dev-"$pg_version" build-essential git -y
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
