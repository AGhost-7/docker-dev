# vim: set ft=dockerfile

ARG BASE_TAG=latest

FROM aghost7/nvim:$BASE_TAG

USER aghost-7

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

ONBUILD COPY .deno-version $HOME/.deno-version

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV DENO_INSTALL="/$HOME/.deno"

ENV PATH="$DENO_INSTALL/bin:$PATH"

CMD ["/bin/bash"]

