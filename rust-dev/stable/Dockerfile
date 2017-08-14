FROM aghost7/rust-dev-base

ENV RUST_DEFAULT_TOOLCHAIN=stable

USER aghost-7

COPY post-plugin.vim /tmp/post-plugin.vim
COPY build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]

