FROM aghost7/rust-dev-base

USER aghost-7

COPY post-plugin.vim /tmp/post-plugin.vim
COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]

