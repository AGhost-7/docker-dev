FROM ubuntu:trusty

# TODO: user name should be customisable?
RUN adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/aghost-7

USER aghost-7

# For some reason, this environment variable isn't set by docker.
ENV USER aghost-7

RUN sudo apt-get update && \
	sudo apt-get install curl python-pip -y

# For dockerception
RUN curl -sSL https://get.docker.com/ | sh && \
	sudo usermod -aG docker aghost-7 && \
	cat /etc/group

RUN sudo pip install docker-compose

# cache is useless to keep
RUN sudo apt-get autoremove -y && \
	sudo apt-get clean

CMD ["bin/bash"]

