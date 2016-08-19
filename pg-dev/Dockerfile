FROM postgres:9.3

RUN apt-get update && \
	apt-get install --no-install-recommends build-essential python-pip python-dev postgresql-server-dev-9.3 -y && \
	pip install pgcli && \
	apt-get purge python-dev postgresql-server-dev-9.3 build-essential -y && \
	apt-get autoremove -y && \
	apt-get clean

COPY pgcliconfig /root/.config/pgcli/config

