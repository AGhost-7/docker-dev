FROM aghost7/nvim:focal

ENV IMAGE_CLASS java

ENV JDTLS_HOME /usr/local/share/jdtls

COPY ./jdtls /usr/local/bin/jdtls

COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./plugin.vim /tmp/plugin.vim

RUN mkdir -p $HOME/.m2/repository
VOLUME $HOME/.m2/repository
COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh
COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> ~/.bashrc && sudo rm /tmp/bashrc-additions.sh
