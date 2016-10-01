#!/usr/bin/env bash

docker build -t aghost7/go-dev:latest .

# Needs to be login shell as I appended to .profile
docker run --rm -ti aghost7/go-dev:latest bash -l -c "which go"

