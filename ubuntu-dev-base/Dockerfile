FROM ubuntu:trusty

# TODO: user name should be customisable?
RUN adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/aghost-7

USER aghost-7

RUN sudo apt-get update && sudo apt-get install curl -y

# For dockerception
RUN curl -sSL https://get.docker.com/ | sh

# cache is useless to keep
RUN sudo apt-get clean

CMD ["bash"]

