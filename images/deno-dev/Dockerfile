# vim: set ft=dockerfile

ARG BASE_TAG=focal

FROM aghost7/nvim:$BASE_TAG

USER aghost-7

ENV IMAGE_CLASS deno

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV DENO_INSTALL="$HOME/.deno"

ENV PATH="$DENO_INSTALL/bin:$PATH"
