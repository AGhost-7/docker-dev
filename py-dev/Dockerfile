FROM aghost7/nvim

USER aghost-7

RUN sudo pip install flake8 jedi virtualenv ptpython && \
	sudo apt-get update && \
	sudo apt-get install python3-pip -y && \
	sudo rm -rf /var/lib/apt/lists/* && \
	sudo pip3 install neovim

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./ptpython.py "$HOME/.ptpython/config.py"

RUN sudo chown -R $USER:$USER "$HOME/.ptpython"

RUN cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim && \
	sudo rm /tmp/plugin.vim && \
	cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim && \
	sudo rm /tmp/post-plugin.vim && \
	nvim +PlugInstall +qall && \
	nvim +UpdateRemotePlugins +qall
