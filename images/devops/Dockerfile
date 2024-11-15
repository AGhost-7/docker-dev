ARG BASE_TAG=noble

FROM docker.io/aghost7/py-dev:$BASE_TAG

ENV IMAGE_CLASS devops

COPY ./build.sh /tmp/build.sh

COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh
COPY ./devops.lua $HOME/.config/nvim/lua/plugins/devops.lua

RUN /tmp/build.sh && sudo rm /tmp/build.sh

# store session and stuff
RUN mkdir -p $HOME/.azure $HOME/.kube $HOME/.terraform.version
VOLUME $HOME/.azure
VOLUME $HOME/.kube
VOLUME $HOME/.terraform.versions
