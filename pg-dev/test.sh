#!/usr/bin/env bash

set -e

docker build -t aghost7/pg-dev:9.3 .

docker run --name pg-dev -d aghost7/pg-dev:9.3

sleep 5

docker exec pg-dev psql -U postgres template1 -c 'select 1'

docker kill pg-dev
docker rm pg-dev
