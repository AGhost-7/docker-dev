ARG BASE_TAG=focal

FROM aghost7/py-dev:$BASE_TAG

ENV IMAGE_CLASS devops

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim
COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh

# store session and stuff
RUN mkdir -p $HOME/.azure $HOME/.kube
VOLUME $HOME/.azure
VOLUME $HOME/.kube
VOLUME $HOME/.terraform.versions
