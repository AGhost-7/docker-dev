ARG BASE_TAG=jammy

FROM docker.io/aghost7/dev-base:$BASE_TAG

USER aghost-7

ENV IMAGE_CLASS python

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./ale-poetry-shim $HOME/.local/bin/ale-poetry-shim

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

COPY ./global.py $HOME/.config/ycm/global.py
RUN sudo chown $USER:$USER $HOME/.config/ycm/global.py
