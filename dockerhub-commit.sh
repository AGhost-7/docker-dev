#!/usr/bin/env bash

set -e

# This script updates all of the build branches for dockerhub. Decided to do this since I want to
# keep everything in a single repository but didn't want to deal with the hassle of rebuilding all
# images every time I update just a single dockerfile.

if [ ! -d .build ]; then
	git clone git@github.com:AGhost-7/docker-dev .build
	cat .git/config > .build/.git/config
fi

cd .build
find .. -maxdepth 1 -not -name '.*' -and -type d | while read d; do
	image_name="$(basename $d)"
	echo "Checking image $image_name"
	branch="dockerhub/$image_name"
	git checkout "$branch" 2> /dev/null || (git checkout --orphan "$branch" && git reset --hard)
	cp -r "../$image_name/"* .
	git add -A
	if ! git diff-index --quiet HEAD --; then
		git commit -m "Update branch for image $image_name"
	fi
	if [ "$1" == "--push" ]; then
		git push origin "branch"
	fi
done

