FROM aghost7/nvim:focal

ENV IMAGE_CLASS java

ENV JDTLS_HOME /usr/local/share/jdtls

RUN sudo apt-get update && \
	sudo apt-get install -y openjdk-11-jdk-headless maven gradle && \
	sudo rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/jdtls.tar.gz https://download.eclipse.org/jdtls/snapshots/jdt-language-server-1.5.0-202109201721.tar.gz && \
	sudo mkdir $JDTLS_HOME && \
	sudo tar xvf /tmp/jdtls.tar.gz -C $JDTLS_HOME && \
	rm /tmp/jdtls.tar.gz && \
	cp -r $JDTLS_HOME/config_linux $HOME/.config/jdtls

COPY ./jdtls /usr/local/bin/jdtls

RUN sudo chmod +x /usr/local/bin/jdtls

COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./plugin.vim /tmp/plugin.vim

RUN mkdir -p $HOME/.m2/repository
VOLUME $HOME/.m2/repository

RUN set -e; \
	for file in post-plugin.vim plugin.vim; do \
		cat "/tmp/$file" >> "$HOME/.config/nvim/$file"; \
		sudo rm "/tmp/$file"; \
	done

RUN nvim +PlugInstall +qall
