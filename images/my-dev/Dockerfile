ARG MYSQL_VERSION=5.6

FROM mysql:$MYSQL_VERSION

ENV MYSQL_ROOT_PASSWORD=root

ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

COPY ./myclirc /root/.myclirc

RUN /tmp/build.sh && \
	rm /tmp/build.sh
