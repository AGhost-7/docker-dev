#!/usr/bin/env bash

# Simple script which merges all the different dockerfiles together.
cat $(echo Dockerfile.* | sort) | grep -Ev '^FROM tutorial:|^# vim:'
