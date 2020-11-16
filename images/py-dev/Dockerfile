ARG BASE_TAG=latest

FROM aghost7/nvim:$BASE_TAG

USER aghost-7

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh

COPY ./ptpython.py "$HOME/.ptpython/config.py"

RUN sudo chown -R $USER:$USER "$HOME/.ptpython"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> ~/.bashrc && \
	sudo rm /tmp/bashrc-additions.sh

# directory is used by pipenv
RUN mkdir -p $HOME/.local/share/virtualenvs
VOLUME $HOME/.local/share/virtualenvs

# directory is used by poetry
RUN mkdir -p $HOME/.cache/pypoetry
VOLUME $HOME/.cache/pypoetry
