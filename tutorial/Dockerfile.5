FROM tutorial:4

# get the nvm install script and run it
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# set the environment variable
ENV NVM_DIR /home/$DOCKER_USER/.nvm

# source nvm, install the version we want, alias that version so it always loads
RUN . "$NVM_DIR/nvm.sh" && \
	nvm install --lts && \
	nvm alias default stable

# cmake needed for YMC
RUN sudo apt-get install -y cmake

# we also need python neovim, so we need to get and update pip3
RUN sudo apt-get install -y python3-pip && \
	sudo pip3 install --upgrade pip && \
	sudo pip3 install neovim

# source nvm and run the python youcompleteme installer with JS
RUN . "$NVM_DIR/nvm.sh" && \
    python3 "$HOME/.config/nvim/plugged/YouCompleteMe/install.py" \
    --js-completer

# turn on tern
RUN echo '{"plugins": {"node": {}}}' > ~/.tern-config


# vim: set ft=dockerfile:
