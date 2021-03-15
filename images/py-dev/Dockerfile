ARG BASE_TAG=focal

FROM aghost7/nvim:$BASE_TAG

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

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> ~/.bashrc && \
	sudo rm /tmp/bashrc-additions.sh

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
