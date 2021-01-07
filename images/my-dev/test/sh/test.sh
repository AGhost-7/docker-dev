#!/usr/bin/env bash

set -e

podman run -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -d --name my-dev "$IMAGE"

sleep 5

#podman exec -ti my-dev mysql -u root -e 'select 1'
podman kill my-dev
podman rm my-dev
