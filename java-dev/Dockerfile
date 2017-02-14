FROM aghost7/nvim

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-plugin.vim /tmp/post-plugin.vim

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && sudo rm /tmp/build.sh
