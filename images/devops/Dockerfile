ARG BASE_TAG=bionic

FROM aghost7/py-dev:$BASE_TAG

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim
COPY ./post-plugin.vim /tmp/post-plugin.vim

ENV TERRAFORM_VERSION=0.13.5

RUN /tmp/build.sh && sudo rm /tmp/build.sh

# store session and stuff
RUN mkdir -p $HOME/.azure
VOLUME $HOME/.azure
