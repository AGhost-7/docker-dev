

FROM docker.io/library/postgres:16

ENV TERM screen-256color

# since this is for development, password protections are not needed.
ENV POSTGRES_HOST_AUTH_METHOD trust

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh $PG_VERSION && \
	rm /tmp/build.sh

COPY pgcliconfig /root/.config/pgcli/config
