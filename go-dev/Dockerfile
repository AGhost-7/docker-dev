FROM aghost7/nvim:latest

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	sudo rm /tmp/build.sh
