FROM aghost7/nvim

USER aghost-7

RUN sudo apt-get update && \
	sudo apt-get install openjdk-7-jdk -y

RUN mkdir -p /home/aghost-7/.ivy2/cache

VOLUME /home/aghost-7/.ivy2/cache

RUN curl -L -o /tmp/sbt.deb https://dl.bintray.com/sbt/debian/sbt-0.13.11.deb && \
	sudo dpkg -i /tmp/sbt.deb

COPY plugins.sbt /home/aghost-7/.sbt/0.13/plugins.sbt

COPY plugin.vim /tmp/plugin.vim

RUN cat /tmp/plugin.vim >> /home/aghost-7/.config/nvim/plugin.vim

RUN nvim +PlugInstall +qall

RUN sudo pip install websocket-client sexpdata

RUN sudo chown -R aghost-7:aghost-7 ~/.sbt && \
	sudo chown -R aghost-7:aghost-7 ~/.ivy2

