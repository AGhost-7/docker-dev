#!/usr/bin/env bash

set -e

docker build -t aghost7/pg-dev:9.3 .

docker run --name pg-dev -d -p 5432:5432 aghost7/pg-dev:9.3

sleep 5

if [ "$(which psql)" == "" ]; then
	sudo apt-get update
	sudo apt-get install postgresql-client -y
fi

psql template1 -U postgres

docker kill pg-dev
docker rm pg-dev
