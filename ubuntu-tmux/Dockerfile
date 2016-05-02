FROM ubuntu:trusty
RUN apt-get update && \
	apt-get install python-pip python-dev -y

RUN add-apt-repository -y ppa:pi-rho/dev && \
	apt-get update && \
	apt-get install tmux -y

RUN mkdir -p /root/.config/powerline

ENV XDG_CONFIG_HOME /root/.config

RUN pip install powerline-status

RUN git clone https://github.com/powerline/fonts.git /tmp/fonts && \
	/tmp/fonts/install.sh



