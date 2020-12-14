#!/usr/bin/env bash

apt-get update
apt-get install -y --no-install-recommends \
	python3 \
	python3-pip \
	python3-wheel \
	python3-setuptools

pip install iredis

apt-get purge -y \
	python3-pip \
	python3-wheel \
	python3-setuptools
