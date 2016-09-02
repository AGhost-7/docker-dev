FROM ubuntu:trusty

# TODO: user name should be customisable?
RUN adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/aghost-7

USER aghost-7

# For some reason, this environment variable isn't set by docker.
ENV USER aghost-7

ENV HOME /home/aghost-7

# Required for `clear` command to work, etc.
ENV TERM screen-256color

COPY build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]

