#!/usr/bin/env bash

set -e

apt-get update

apt-get install --no-install-recommends curl python-pip python-dev build-essential less -y

pip install setuptools
pip install mycli

cat > /etc/mysql/conf.d/dev.cnf <<CONFIG
[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
CONFIG

apt-get purge build-essential python-dev -y
rm -rf /var/lib/apt/lists/*
