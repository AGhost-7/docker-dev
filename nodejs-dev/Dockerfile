FROM aghost7/nvim

USER aghost-7

COPY plugin.vim /tmp/plugin.vim
COPY post-plugin.vim /tmp/post-plugin.vim

RUN cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim && \
	cat /tmp/post-plugin.vim >> /home/aghost-7/.config/nvim/post-plugin.vim

RUN nvim +PlugInstall +qall

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash

# Set env variable so it installs locally (no need for sudo)
ENV NVM_DIR /home/aghost-7/.nvm

# TODO: Should be able to have different tags for different versions.
RUN . /home/aghost-7/.nvm/nvm.sh && \
	nvm install v0.10.38 && \
	nvm alias default v0.10.38 && \
	npm install -g jscs@1.13.1 nodemon jshint

RUN sudo rm /tmp/*.vim

CMD ["/bin/bash"]
