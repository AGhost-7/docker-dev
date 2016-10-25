FROM postgres:9.3

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && \
	rm /tmp/build.sh

#COPY ./pgweb-init.sh /docker-entrypoint-initdb.d/pgweb-init.sh

COPY pgcliconfig /root/.config/pgcli/config

EXPOSE 8081

