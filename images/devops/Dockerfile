FROM aghost7/py-dev:bionic

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim
COPY ./post-plugin.vim /tmp/post-plugin.vim

ENV TERRAFORM_VERSION=0.11.13

RUN /tmp/build.sh && sudo rm /tmp/build.sh

# store session and stuff
VOLUME $HOME/.azure
