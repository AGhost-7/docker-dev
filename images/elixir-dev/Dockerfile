
ARG BASE_TAG=noble
ARG BASE_IMAGE=docker.io/aghost7/dev-base

FROM $BASE_IMAGE:$BASE_TAG

ENV IMAGE_CLASS elixir

RUN mkdir -p ~/.asdf/installs/
VOLUME /home/aghost-7/.asdf/installs

COPY ./elixir.lua $HOME/.config/nvim/lua/plugins/elixir.lua
RUN sudo chown -R $USER:$USER $HOME/.config/nvim/lua/plugins

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm -rf /tmp/*
