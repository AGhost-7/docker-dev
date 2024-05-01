FROM docker.io/library/redis:6

COPY ./build.sh /tmp/build.sh

RUN /tmp/build.sh && rm /tmp/build.sh
