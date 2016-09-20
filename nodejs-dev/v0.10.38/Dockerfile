FROM aghost7/nvim

USER aghost-7

RUN export NODE_VERSION="v0.10.38" && \
	curl -o- https://raw.githubusercontent.com/AGhost-7/docker-dev/master/nodejs-dev/build.sh | bash

CMD ["/bin/bash"]
