# vim: set ft=dockerfile

ARG BASE_TAG=jammy

FROM docker.io/aghost7/dev-base:$BASE_TAG

USER aghost-7

ENV IMAGE_CLASS node-js

COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-pluggin.vim /tmp/post-plugin.vim

COPY ./repl /usr/local/bin/repl

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV NVM_DIR $HOME/.nvm

RUN mkdir -p $HOME/.npm
VOLUME $HOME/.npm

RUN mkdir -p $HOME/.cache/yarn
VOLUME $HOME/.cache/yarn

COPY ./pre-commit $HOME/.config/git/hooks/pre-commit

RUN sudo chown $USER:$USER $HOME/.config/git/hooks/pre-commit
