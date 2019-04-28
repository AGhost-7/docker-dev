
ARG PG_VERSION=9.3

FROM postgres:$PG_VERSION

ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	rm /tmp/build.sh $PG_VERSION

COPY pgcliconfig /root/.config/pgcli/config

