#!/usr/bin/env bash

set -e

set -x

tests=(ubuntu-dev-base power-tmux nvim nodejs-dev haskell-dev)

for t in "${tests[@]}"; do
	pushd "$t" >> /dev/null
	bash "test.sh"
	popd
done

set +x

echo ''
echo ----------------
echo All tests passed
echo ----------------
