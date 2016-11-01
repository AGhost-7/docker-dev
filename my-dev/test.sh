#!/usr/bin/env bash

set -e

docker build -t aghost7/my-dev:5.6 .

docker run -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -d --name my-dev aghost7/my-dev:5.6

sleep 5

docker exec -ti my-dev mysql -u root -e 'select 1'
docker kill my-dev
docker rm my-dev
