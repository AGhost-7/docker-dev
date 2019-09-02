
ARG PG_VERSION=9.6

FROM postgres:$PG_VERSION

ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh $PG_VERSION && \
	rm /tmp/build.sh

COPY pgcliconfig /root/.config/pgcli/config

