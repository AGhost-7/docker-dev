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

RUN sudo apt-get update

# Super essential tools
RUN sudo apt-get install tree curl -y

RUN sudo apt-get install python-pip -y

# See readme for how to get the clipboard working.
RUN sudo apt-get install xclip -y

# For dockerception
RUN curl -sSL https://get.docker.com/ | sh && \
	sudo usermod -aG docker aghost-7 && \
	cat /etc/group

RUN sudo pip install docker-compose

# Install misc help tools
RUN sudo pip install tldr && \
	sudo apt-get install man-db -y

# System info. Nethogs has a bug on trusty so just going to use iftop.
RUN sudo apt-get install htop iotop iftop -y

# cache is useless to keep
RUN sudo apt-get autoremove -y && \
	sudo apt-get clean

CMD ["bin/bash"]

