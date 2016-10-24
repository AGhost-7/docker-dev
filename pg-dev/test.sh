#!/usr/bin/env bash

set -e

docker build -t aghost7/pg-dev:9.3 .

docker run --name pg-dev -d -p 8081:8081 aghost7/pg-dev:9.3

sleep 5

# I should be able to connect to pgweb without any configuration...
curl localhost:8081

docker kill pg-dev

