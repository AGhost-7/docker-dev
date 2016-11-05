# vim: set ft=dockerfile

FROM aghost7/nvim

USER aghost-7

ARG NODE_VERSION

ENV NVM_DIR /home/aghost-7/.nvm

COPY ./build.sh /tmp/build.sh

RUN NODE_VERSION="$NODE_VERSION" /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]

