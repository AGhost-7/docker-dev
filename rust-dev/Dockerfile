FROM aghost7/nvim

USER aghost-7

RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh

COPY plugin.vim /tmp/plugin.vim

# Add new plugins.
RUN cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim && \
	nvim +PlugInstall +qall

# Install racer completer/recompile ycmd
RUN sudo apt-get update && \
	sudo apt-get install cmake -y && \
	/home/aghost-7/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer

# I need the header files in this one so I can compile against it for hyper.
RUN sudo apt-=get install libssl-dev -y

RUN sudo apt-get remove cmake -y && \
	sudo apt-get clean && \
	sudo apt-get autoremove -y

CMD ["/bin/bash"]

