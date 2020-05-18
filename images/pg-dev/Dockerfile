
ARG PG_VERSION=9.6

FROM postgres:$PG_VERSION

ENV TERM screen-256color

# since this is for development, password protections are not needed.
ENV POSTGRES_HOST_AUTH_METHOD trust

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh $PG_VERSION && \
	rm /tmp/build.sh

COPY pgcliconfig /root/.config/pgcli/config

