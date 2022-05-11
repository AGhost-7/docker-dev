#!/usr/bin/env bash

set -exo pipefail

sudo apt-get update
sudo apt-get install -y openjdk-17-jdk-headless gradle

# {{{ maven
curl -L -o /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
sudo mkdir /opt/maven
sudo tar xvf /tmp/maven.tar.gz -C /opt/maven/ --strip-component=1
# }}}

# {{{ java completer
curl -L -o /tmp/jdtls.tar.gz https://download.eclipse.org/jdtls/milestones/1.11.0/jdt-language-server-1.11.0-202205051421.tar.gz
sudo mkdir $JDTLS_HOME
sudo tar xvf /tmp/jdtls.tar.gz -C $JDTLS_HOME
rm /tmp/jdtls.tar.gz
cp -r $JDTLS_HOME/config_linux $HOME/.config/jdtls
# }}}

ycm-install --java-completer

for file in post-plugin.vim plugin.vim; do
	cat "/tmp/$file" >> "$HOME/.config/nvim/$file";
	sudo rm "/tmp/$file";
done

nvim +PlugInstall +qall

sudo rm -rf /var/lib/apt/lists/*
