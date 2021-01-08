ARG BASE_TAG

FROM aghost7/nodejs-dev:$BASE_TAG

ENV IMAGE_CLASS ruby

COPY ./plugin.vim /tmp/plugin.vim
COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> $HOME/.bashrc && sudo rm /tmp/bashrc-additions.sh

VOLUME /usr/share/rvm/rubies

VOLUME /usr/share/rvm/gems

RUN mkdir -p $HOME/.rvm/gems
VOLUME $HOME/.rvm/gems

RUN mkdir -p $HOME/.bundle
VOLUME $HOME/.bundle
