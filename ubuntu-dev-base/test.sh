#!/usr/bin/env bash

set -e

set -x

docker build -t aghost7/ubuntu-dev-base:latest .

docker run --rm aghost7/ubuntu-dev-base:latest tldr man

docker run -t --rm aghost7/ubuntu-dev-base:latest which ag

