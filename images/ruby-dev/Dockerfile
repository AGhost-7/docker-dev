FROM aghost7/nvim

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh

VOLUME $HOME/.rvm/rubies
VOLUME $HOME/.rvm/gems
