FROM aghost7/ubuntu-dev-base:latest

USER aghost-7

ENV XDG_CONFIG_HOME /home/aghost-7/.config

COPY ./powerline /home/aghost-7/.config/powerline

COPY ./.tmux.conf /home/aghost-7/.tmux.conf

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

CMD ["bin/bash"]

