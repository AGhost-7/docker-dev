FROM aghost7/nvim:latest

COPY ./build.sh /tmp/build.sh
COPY ./plugin.vim /tmp/plugin.vim
COPY ./post-plugin.vim /tmp/post-plugin.vim

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh
