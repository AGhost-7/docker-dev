FROM aghost7/ubuntu-dev-base:latest

USER aghost-7

ENV LANG en_US.UTF-8

ENV XDG_CONFIG_HOME /home/aghost-7/.config

RUN sudo apt-get update && \
	sudo apt-get install python-pip software-properties-common fontconfig -y

RUN sudo apt-get install language-pack-en-base -y && \
	sudo dpkg-reconfigure locales && \
	sudo apt-get purge language-pack-en-base -y

COPY ./powerline /home/aghost-7/.config/powerline

COPY ./.tmux.conf /home/aghost-7/.tmux.conf

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN sudo chown -R aghost-7:aghost-7 /home/aghost-7/.config && \
	sudo chown aghost-7:aghost-7 /home/aghost-7/.tmux.conf

RUN cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc

RUN sudo add-apt-repository -y ppa:pi-rho/dev && \
	sudo apt-get update && \
	sudo apt-get install tmux -y

RUN sudo pip install powerline-status

RUN git clone https://github.com/powerline/fonts.git /tmp/fonts && \
	/tmp/fonts/install.sh

# Add fzf fuzzy finder
RUN git clone https://github.com/junegunn/fzf.git ~/.fzf && \
	~/.fzf/install --all

RUN sudo apt-get clean && \
	sudo apt-get remove software-properties-common fontconfig -y && \
	sudo rm -r /tmp/fonts && \
	sudo rm /tmp/bashrc-additions.sh

CMD ["bin/bash"]

