FROM aghost-7:ubuntu-tmux

RUN apt-get update

RUN apt-get install python-pip python-dev software-properties-common curl -y

RUN add-apt-repository ppa:neovim-ppa/unstable && \
	apt-get update && \
	apt-get install neovim -y

ADD bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> /root/.bashrc

RUN echo 'export XDG_CONFIG_PATH="/root/.config"' >> /root/.bashrc

RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN pip install neovim

ADD init.vim /root/.config/nvim/init.vim

RUN nvim +PlugInstall +qall

RUN apt-get install cmake -y && \
	/root/.config/nvim/plugged/YouCompleteMe/install.py

RUN git clone https://github.com/powerline/fonts.git /tmp/fonts && \
 /tmp/fonts/install.sh


