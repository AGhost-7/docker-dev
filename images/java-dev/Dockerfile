ARG BASE_TAG=noble

FROM docker.io/aghost7/dev-base:$BASE_TAG

ENV IMAGE_CLASS java

RUN mkdir -p $HOME/.m2/repository
VOLUME $HOME/.m2/repository
COPY ./build.sh /tmp/build.sh

COPY ./java.lua $HOME/.config/nvim/lua/plugins/java.lua
RUN sudo chown -R $USER:$USER $HOME/.config/nvim/lua/plugins

RUN /tmp/build.sh && sudo rm /tmp/build.sh
COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh

RUN cat /tmp/zshrc-additions.sh >> ~/.zshrc && sudo rm /tmp/zshrc-additions.sh
