#!/usr/bin/env bash

set -e

set -x

testnode() {
	docker build -t "aghost7/nodejs-dev:$1" --build-arg NODE_VERSION="$1" .
	docker run --rm -ti "aghost7/nodejs-dev:$1" \
		bash -c ". /home/aghost-7/.nvm/nvm.sh && node -p '1 + 1'"
	docker run --rm "aghost7/nodejs-dev:$1" \
		bash -c ". /home/aghost-7/.nvm/nvm.sh && node -v"
}

testnode v0.10.38
testnode v4.5.0
