ARG UBUNTU_RELEASE=focal

FROM ubuntu:${UBUNTU_RELEASE}

LABEL MAINTAINER jonathan-boudreau@protonmail.com

ARG UBUNTU_RELEASE

ENV UBUNTU_RELEASE=${UBUNTU_RELEASE}

# TODO: user name should be customisable?
RUN apt-get update && \
	apt-get install sudo -y && \
	adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

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

ENV DOCKER_CLI_VERSION "20.10.9"

COPY build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	rm /tmp/build.sh

ENV USER aghost-7

ENV HOME /home/aghost-7

WORKDIR /home/aghost-7

USER aghost-7

COPY ./inputrc "$HOME/.inputrc"

RUN sudo chown "$USER":"$USER" "$HOME/.inputrc"

CMD ["/bin/bash"]
