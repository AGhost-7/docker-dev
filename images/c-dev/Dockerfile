FROM docker.io/aghost7/dev-base:noble

ENV IMAGE_CLASS c

COPY /build.sh /tmp/build.sh

COPY /post-plugin.vim /tmp/post-plugin.vim
COPY /plugin.vim /tmp/plugin.vim

RUN /tmp/build.sh && sudo rm /tmp/build.sh
