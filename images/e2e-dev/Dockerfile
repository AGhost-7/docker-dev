ARG BASE_TAG=noble
ARG BASE_IMAGE=docker.io/aghost7/nodejs-dev
from $BASE_IMAGE:$BASE_TAG

USER aghost-7

ENV IMAGE_CLASS e2e-dev

# for the playwright cli to download the actual correct chromium version, etc
RUN mkdir -p $HOME/.cache/ms-playwright
VOLUME $HOME/.cache/ms-playwright

COPY ./e2e.lua $HOME/.config/nvim/lua/plugins/e2e.lua
COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm -rf /tmp/*
