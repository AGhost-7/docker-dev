# vim: set ft=dockerfile

ARG BASE_TAG=bionic

FROM aghost7/nvim:$BASE_TAG

USER aghost-7

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-pluggin.vim /tmp/post-plugin.vim

COPY ./repl /usr/local/bin/repl

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV NVM_DIR $HOME/.nvm

ONBUILD COPY .nodejs-version $HOME/.nodejs-version
ONBUILD RUN . ~/.nvm/nvm.sh && \
	nvm install "$(cat $HOME/.nodejs-version)" && \
	nvm alias default stable && \
	yarn global add flip-table javascript-typescript-langserver && \
	yarn cache clean

VOLUME $HOME/.npm

VOLUME $HOME/.cache/yarn

CMD ["/bin/bash"]
