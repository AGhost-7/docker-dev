ARG BASE_TAG=noble

FROM docker.io/aghost7/dev-base:$BASE_TAG

USER aghost-7

ENV IMAGE_CLASS python

COPY ./python.lua $HOME/.config/nvim/lua/plugins/python.lua

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh

COPY ./ptpython.py "$HOME/.ptpython/config.py"

RUN sudo chown -R $USER:$USER "$HOME/.ptpython"

COPY ./zshrc-additions.sh /tmp/zshrc-additions.sh

RUN cat /tmp/zshrc-additions.sh >> ~/.zshrc && \
	sudo rm /tmp/zshrc-additions.sh

# directory is used by pipenv
RUN mkdir -p $HOME/.local/share/virtualenvs
VOLUME $HOME/.local/share/virtualenvs

# directory is used by poetry
RUN mkdir -p $HOME/.cache/pypoetry
VOLUME $HOME/.cache/pypoetry

# pre-commit directory for installing plugins
RUN mkdir -p $HOME/.cache/pre-commit
VOLUME $HOME/.cache/pre-commit

COPY ./pre-commit $HOME/.config/git/hooks/pre-commit

RUN sudo chown -R $USER:$USER $HOME/.config/git
