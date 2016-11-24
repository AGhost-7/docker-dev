
FROM aghost7/nvim

USER aghost-7

ENV NVM_DIR /home/aghost-7/.nvm

RUN export NODE_VERSION="v4.6.1" && \
	curl -o- https://raw.githubusercontent.com/AGhost-7/docker-dev/master/nodejs-dev/build.sh | bash

CMD ["/bin/bash"]
