FROM aghost7/nvim:bionic

ENV JDTLS_HOME /usr/local/share/jdtls

RUN sudo apt-get update && \
	sudo apt-get install -y openjdk-11-jdk-headless maven gradle && \
	sudo rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/jdtls.tar.gz http://download.eclipse.org/jdtls/snapshots/jdt-language-server-0.9.0-201711302113.tar.gz && \
	sudo mkdir $JDTLS_HOME && \
	sudo tar xvf /tmp/jdtls.tar.gz -C $JDTLS_HOME && \
	rm /tmp/jdtls.tar.gz && \
	cp -r $JDTLS_HOME/config_linux $HOME/.config/jdtls

COPY ./jdtls /usr/local/bin/jdtls

RUN sudo chmod +x /usr/local/bin/jdtls

COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./plugin.vim /tmp/plugin.vim

RUN set -e; \
	for file in post-plugin.vim plugin.vim; do \
		cat "/tmp/$file" >> "$HOME/.config/nvim/$file"; \
		sudo rm "/tmp/$file"; \
	done

RUN nvim +PlugInstall +qall
