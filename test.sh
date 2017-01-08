#!/usr/bin/env bash

set -e

set -o verbose

for d in ubuntu-dev-base power-tmux nvim nodejs-dev scala-dev rust-dev py-dev; do
	if [ -f "$d/test.sh" ];  then
		pushd "$d" >> /dev/null
		bash "test.sh"
		popd >> /dev/null
	fi
done

set +x

echo ''
echo ----------------
echo All tests passed
echo ----------------
