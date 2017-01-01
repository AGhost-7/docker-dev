#!/usr/bin/env bash

set -e

set -o verbose

for d in *; do
	if [ -d "$d" ] && [ -f "$d/test.sh" ];  then
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
