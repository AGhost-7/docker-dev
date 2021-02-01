ARG BASE_TAG=focal

FROM aghost7/ubuntu-dev-base:$BASE_TAG

USER aghost-7

ENV XDG_CONFIG_HOME "$HOME/.config"

COPY ./powerline "$HOME/.config/powerline"

COPY ./tmux.conf "$HOME/.config/tmux/tmux.conf"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

ENV TMUX_VERSION 3.1

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/usr/local/bin/tmux", "new"]
