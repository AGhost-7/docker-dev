ARG BASE_TAG=bionic

FROM aghost7/power-tmux:$BASE_TAG

USER aghost-7

COPY ./build.sh /tmp/build.sh

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY init.vim "$HOME/.config/nvim/init.vim"
COPY plugin.vim "$HOME/.config/nvim/plugin.vim"
COPY post-plugin.vim "$HOME/.config/nvim/post-plugin.vim"

COPY ./ycm-install /usr/local/bin/ycm-install

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["bin/bash"]

