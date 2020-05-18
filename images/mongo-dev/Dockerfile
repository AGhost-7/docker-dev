ARG BASE_TAG

FROM mongo:$BASE_TAG

# Install autocomplete enhancement
RUN apt-get update && \
	apt-get install -y --no-install-recommends nodejs && \
	apt-get install -y git build-essential && \
	git clone --depth 1 https://github.com/TylerBrock/mongo-hacker.git /mongo-hacker && \
	cd /mongo-hacker && \
	make install && \
	apt-get purge -y git build-essential && \
	rm -rf /var/lib/apt/lists/*
