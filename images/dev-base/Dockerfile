ARG UBUNTU_RELEASE=jammy

FROM docker.io/library/ubuntu:${UBUNTU_RELEASE} as base

RUN apt-get update && \
	apt-get install sudo adduser -y && \
	adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# install man pages, etc
RUN yes | unminimize || true

# squash image due to unminimize re-installing a lot of packages
FROM scratch
COPY --from=base / /

LABEL MAINTAINER jonathan-boudreau@protonmail.com

ENV UBUNTU_RELEASE=${UBUNTU_RELEASE}

# {{{ lang stuff

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN apt-get update && \
	apt-get install -y language-pack-en-base && \
	rm -rf /var/lib/apt/lists/*

# }}}

# Required for `clear` command to work, etc.
ENV TERM screen-256color

ENV USER aghost-7

ENV HOME /home/aghost-7

WORKDIR /home/aghost-7

USER aghost-7

COPY build.sh /tmp/build.sh

COPY zshrc /tmp/zshrc

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

COPY ./inputrc "$HOME/.inputrc"

RUN sudo chown "$USER":"$USER" "$HOME/.inputrc"

CMD ["/usr/bin/zsh"]

ENV XDG_CONFIG_HOME "$HOME/.config"

ENV TMUX_VERSION 3.1

COPY ./tmux.conf "$HOME/.config/tmux/tmux.conf"
COPY ./tmux-setup.sh /tmp/tmux-setup.sh

RUN bash /tmp/tmux-setup.sh && sudo rm /tmp/tmux-setup.sh


COPY init.lua "$HOME/.config/nvim/init.lua"
COPY ./.editorconfig "$HOME/.editorconfig"

COPY ./setup-nvim.sh /tmp/setup-nvim.sh

RUN bash /tmp/setup-nvim.sh && sudo rm /tmp/setup-nvim.sh

ENV IMAGE_CLASS=base
