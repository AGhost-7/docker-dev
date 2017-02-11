# vim: set ft=dockerfile

FROM aghost7/nvim

USER aghost-7

ENV NVM_DIR /home/aghost-7/.nvm

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./repl /usr/local/bin/repl

RUN /tmp/build.sh && sudo rm /tmp/build.sh

CMD ["/bin/bash"]

