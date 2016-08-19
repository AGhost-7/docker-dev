FROM postgres:9.3

RUN apt-get update && \
	apt-get install python-pip python-dev postgresql-server-dev-9.3 -y && \
	pip install pgcli

RUN apt-get purge python-dev postgresql-server-dev-9.3 -y && \
	apt-get autoremove -y && \
	apt-get clean


