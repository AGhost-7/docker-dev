#!/usr/bin/env bash

vimOut="$(podman run --rm aghost7/nvim:latest nvim --headless -c ':T' +qall)"

if [[ "$vimOut" == Error ]]; then
	echo Plugin error...
	exit 1
fi

podman run --rm aghost7/nvim:latest which shellcheck

files="$(podman run --rm aghost7/nvim:latest find /home/aghost-7 -group root)"

if [ "$files" != "" ]; then
	echo Permission error...
	exit 1
fi

