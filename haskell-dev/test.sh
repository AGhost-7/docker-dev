#!/usr/bin/env bash

set -e

set -x

docker build -t aghost7/haskell-dev:latest .

docker run -ti aghost7/haskell-dev:latest which ghci ghc

