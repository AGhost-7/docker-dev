FROM aghost7/ubuntu-dev-base:bionic

RUN sudo apt-get update && \
	sudo apt-get install python3-pip -y --no-install-recommends && \
	sudo python3 -m pip install virtualenv pytest flake8 && \
	sudo rm -rf /var/lib/apt/lists/*
