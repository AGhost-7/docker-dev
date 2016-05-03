FROM aghost7/ubuntu-dev-base:latest

USER aghost-7

RUN sudo apt-get update && \
	sudo apt-get install python-pip software-properties-common fontconfig -y

ENV XDG_CONFIG_HOME $HOME/.config

ENV LANG en_US.UTF-8

ADD powerline $HOME/.config/powerline

ADD .tmux.conf $HOME/.tmux.conf

ADD bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> $HOME/.bashrc

RUN sudo add-apt-repository -y ppa:pi-rho/dev && \
	sudo apt-get update && \
	sudo apt-get install tmux -y

RUN mkdir -p $HOME/.config/powerline

RUN sudo pip install powerline-status

RUN git clone https://github.com/powerline/fonts.git /tmp/fonts && \
	/tmp/fonts/install.sh

RUN sudo apt-get clean && \
	sudo apt-get remove python-dev python-pip software-properties-common fontconfig -y

CMD ["tmux", "new", "-A", "aghost-7"]

