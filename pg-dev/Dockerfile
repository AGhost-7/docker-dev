FROM postgres:9.3

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	rm /tmp/build.sh

COPY pgcliconfig /root/.config/pgcli/config

