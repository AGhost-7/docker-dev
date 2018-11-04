FROM aghost7/nvim:bionic

COPY /build.sh /tmp/build.sh

COPY /post-plugin.vim /tmp/post-plugin.vim
COPY /plugin.vim /tmp/plugin.vim

RUN /tmp/build.sh && sudo rm /tmp/build.sh

# Used to cache completions
VOLUME $HOME/.cache/cquery
