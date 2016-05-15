FROM aghost7/power-tmux:latest

USER aghost-7

RUN sudo apt-get update

RUN sudo apt-get install python-pip python-dev software-properties-common -y

RUN sudo add-apt-repository ppa:neovim-ppa/unstable && \
	sudo apt-get update && \
	sudo apt-get install neovim -y

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> /home/aghost-7/.bashrc

RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN sudo pip install neovim

COPY init.vim /home/aghost-7/.config/nvim/init.vim
COPY plugin.vim /home/aghost-7/.config/nvim/plugin.vim
COPY post-plugin.vim /home/aghost-7/.config/nvim/post-plugin.vim
RUN sudo chown -R aghost-7:aghost-7 /home/aghost-7/.config/nvim

RUN nvim +PlugInstall +qall

RUN sudo apt-get install cmake -y && \
	echo $HOME && \
	/home/aghost-7/.config/nvim/plugged/YouCompleteMe/install.py

RUN sudo apt-get purge python-dev software-properties-common cmake -y && \
	sudo apt-get autoremove -y && \
	sudo apt-get clean && \
	sudo rm /tmp/bashrc-additions.sh

CMD ["bin/bash"]

