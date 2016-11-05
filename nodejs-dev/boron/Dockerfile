
FROM aghost7/nvim

USER aghost-7

# Set env variable so it installs locally (no need for sudo)
ENV NVM_DIR /home/aghost-7/.nvm

RUN NODE_VERSION=v6.9.1 curl -o- https://raw.githubusercontent.com/AGhost-7/docker-dev/master/nodejs-dev/build.sh | bash

CMD ["/bin/bash"]
