FROM aghost7/py-dev:bionic

COPY ./build.sh /tmp/build.sh

ENV TERRAFORM_VERSION=0.11.13

RUN /tmp/build.sh && sudo rm /tmp/build.sh

