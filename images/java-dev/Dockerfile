ARG BASE_TAG=jammy

FROM docker.io/aghost7/dev-base:$BASE_TAG

ENV IMAGE_CLASS java

ENV JDTLS_HOME /usr/local/share/jdtls

COPY ./jdtls /usr/local/bin/jdtls

COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./plugin.vim /tmp/plugin.vim

RUN mkdir -p $HOME/.m2/repository
VOLUME $HOME/.m2/repository
COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh
COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh

RUN cat /tmp/zshrc-additions.sh >> ~/.zshrc && sudo rm /tmp/zshrc-additions.sh
