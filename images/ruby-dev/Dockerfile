FROM aghost7/nvim

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

RUN cat /tmp/bashrc-additions.sh >> $HOME/.bashrc && sudo rm /tmp/bashrc-additions.sh

VOLUME $HOME/.rvm/rubies
VOLUME $HOME/.rvm/gems
