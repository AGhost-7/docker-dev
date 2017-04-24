FROM ubuntu:xenial

# TODO: user name should be customisable?
RUN apt-get update && \
	apt-get install sudo -y && \
	adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists

# Required for `clear` command to work, etc.
ENV TERM screen-256color

COPY build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	rm /tmp/build.sh

# For some reason, this environment variable isn't set by docker.
ENV USER aghost-7

ENV HOME /home/aghost-7

WORKDIR /home/aghost-7

USER aghost-7

COPY ./inputrc "$HOME/.inputrc"

RUN sudo chown "$USER":"$USER" "$HOME/.inputrc"

CMD ["/bin/bash"]
