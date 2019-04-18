ARG BASE_TAG=bionic

FROM aghost7/ubuntu-dev-base:$BASE_TAG

USER aghost-7

ENV XDG_CONFIG_HOME "$HOME/.config"

COPY ./powerline "$HOME/.config/powerline"

COPY ./.tmux.conf "$HOME/.tmux.conf"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./.tmate.conf "$HOME/.tmate.conf"

ENV TMUX_VERSION 2.7

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["bin/bash"]

