FROM ubuntu:trusty

# Sometimes, running on root permissions causes programs to freak out.
# So get outa there.
ADD entrypoint.sh /entrypoint.sh

# TODO: user name should be customisable?
RUN adduser --disabled-password --gecos '' aghost-7 && \
	adduser aghost-7 sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENTRYPOINT ["/entrypoint.sh"]

RUN apt-get update && apt-get install curl -y

# For dockerception
RUN curl -sSL https://get.docker.com/ | sh

CMD ["bash"]

