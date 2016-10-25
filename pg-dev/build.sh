#!/usr/bin/env bash

set -e

apt-get update 
apt-get install build-essential python-pip python-dev postgresql-server-dev-9.3 -y

pip install pgcli

apt-get install unzip curl -y
curl -L -o /tmp/pgweb.zip https://github.com/sosedoff/pgweb/releases/download/v0.9.5/pgweb_linux_amd64.zip
cd /tmp
unzip /tmp/pgweb.zip
mv /tmp/pgweb_linux_amd64 /usr/local/bin/pgweb

apt-get purge python-dev postgresql-server-dev-9.3 build-essential unzip -y
apt-get autoremove -y
apt-get clean
