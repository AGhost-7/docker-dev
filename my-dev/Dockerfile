FROM mysql:5.6

ENV MYSQL_ALLOW_EMPTY_PASSWORD 1

COPY ./build.sh /tmp/build.sh

COPY ./mycliconfig /root/.myclirc

RUN /tmp/build.sh && \
	rm /tmp/build.sh
