#!/usr/bin/env bash

set -e

docker build -t aghost7/pg-dev:9.3 .

if [ "$(docker network ls | awk '$2 == "test" { print $2 }')" == "" ]; then
	docker network create test
fi

docker run --name pg-dev --net=test -d -p 5432:5432 -p 8081:8081 aghost7/pg-dev:9.3

sleep 5

if [ "$(which psql)" == "" ]; then
	sudo apt-get update
	sudo apt-get install postgresql-client -y
fi

docker run --net=test --rm postgres:9.3 psql template1 -U postgres -h pg-dev

# I should be able to connect to pgweb without any configuration...
#curl localhost:8081

docker kill pg-dev
docker rm pg-dev
