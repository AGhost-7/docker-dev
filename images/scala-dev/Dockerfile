FROM aghost7/nvim

USER aghost-7

RUN sudo apt-get update && \
	sudo apt-get install openjdk-8-jdk-headless -y

RUN mkdir -p ~/.ivy2/cache

VOLUME "$HOME/.ivy2/cache"

RUN curl -L -o /tmp/sbt.deb https://dl.bintray.com/sbt/debian/sbt-0.13.11.deb && \
	sudo dpkg -i /tmp/sbt.deb

COPY plugins.sbt /home/aghost-7/.sbt/0.13/plugins/plugins.sbt

RUN sudo chown -R aghost-7:aghost-7 ~/.sbt && \
	sudo chown -R aghost-7:aghost-7 ~/.ivy2

COPY plugin.vim /tmp/plugin.vim

COPY post-plugin.vim /tmp/post-plugin.vim

RUN cat /tmp/plugin.vim >> ~/.config/nvim/plugin.vim && \
	cat /tmp/post-plugin.vim >> ~/.config/nvim/post-plugin.vim

RUN sudo pip3 install websocket-client sexpdata

RUN nvim +PlugInstall +qall && \
	nvim +UpdateRemotePlugins +qall



