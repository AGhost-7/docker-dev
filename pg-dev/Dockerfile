FROM postgres:9.3

ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	rm /tmp/build.sh

COPY pgcliconfig /root/.config/pgcli/config

