FROM aghost7/nvim

USER aghost-7

# Set env variable so it installs locally (no need for sudo)
ENV NVM_DIR /home/aghost-7/.nvm

RUN NODE_VERSION=v0.10.38 curl -o- https://github.com/AGhost-7/docker-dev/blob/master/nodejs-dev | bash

CMD ["/bin/bash"]
