#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo -e '\033[0;31mScript requires one argument\033[0;0,'
fi

if [ -z "$DOCKER_USER" ]; then
	export DOCKER_USER=developer
fi

docker run --rm -ti \
	-v "$HOME/.ssh:/home/$DOCKER_USER/.ssh" \
	tutorial:"$1" bash
