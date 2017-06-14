#!/usr/bin/env bash

# This script updates all of the build branches for dockerhub. Decided to do this since I want to
# keep everything in a single repository but didn't want to deal with the hassle of rebuilding all
# images every time I update just a single dockerfile.

if [ ! -d .build ]; then
	git clone git@github.com:AGhost-7/docker-dev .build
	cat .git/config > .build/.git/config
fi

cd .build
for d in $(find . -maxdepth 1 -not -name '.*' -and -type d); do
	image_name="$(basename $d)"
	branch="dockerhub/$image_name"
	git checkout "$branch" 2> /dev/null || (git checkout --orphan "$branch" && git reset --hard)
	cp -r "../$d/"* .
	git add -A
	if ! git diff-index --quiet HEAD --; then
		git commit -m "Update branch for image $image_name"
	fi
done
