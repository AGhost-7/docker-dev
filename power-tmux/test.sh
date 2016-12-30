#!/usr/bin/env bash

set -e

set -x

docker build -t aghost7/power-tmux:latest .

docker run --rm aghost7/power-tmux:latest which powerline-daemon

files="$(docker run --rm aghost7/power-tmux:latest find /home/aghost-7 -group root)"

if [ "$files" != "" ]; then
	echo Bad file permissions...
	exit 1
fi

#tmuxVersion="$(docker run --rm aghost7/power-tmux:latest tmux -V)"

#if [ "$tmuxVersion" -lt "2.2" ]; then
#	echo Version $tmuxVersion is lower than 2.2
#	exit 1
#fi
