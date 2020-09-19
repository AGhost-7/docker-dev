# vim: set ft=dockerfile

ARG BASE_TAG=focal

FROM aghost7/nvim:$BASE_TAG

USER aghost-7

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-pluggin.vim /tmp/post-plugin.vim

COPY ./repl /usr/local/bin/repl

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV NVM_DIR $HOME/.nvm

COPY ./nodejs-install.sh /usr/local/bin/nodejs-install.sh

VOLUME $HOME/.npm

VOLUME $HOME/.cache/yarn

CMD ["/bin/bash"]
