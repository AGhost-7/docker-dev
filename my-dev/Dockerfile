FROM mysql:5.6

ENV MYSQL_ROOT_PASSWORD=root

ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

COPY ./myclirc /root/.myclirc

RUN /tmp/build.sh && \
	rm /tmp/build.sh
