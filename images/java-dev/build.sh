#!/usr/bin/env bash

set -exo pipefail

sudo apt-get update
sudo apt-get install -y openjdk-17-jdk-headless

# {{{ maven
curl -L -o /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo mkdir /opt/maven
sudo tar xvf /tmp/maven.tar.gz -C /opt/maven/ --strip-component=1
# }}}

# {{{ gradle
curl -L -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-7.4.2-all.zip
sudo unzip -d /opt /tmp/gradle.zip
sudo mv /opt/gradle* /opt/gradle/
# }}}

# {{{ java completer
curl -L -o /tmp/jdtls.tar.gz https://download.eclipse.org/jdtls/milestones/1.11.0/jdt-language-server-1.11.0-202205051421.tar.gz
mkdir /tmp/jdtls
tar xvf /tmp/jdtls.tar.gz -C /tmp/jdtls
sudo mv /tmp/jdtls $JDTLS_HOME
sudo chown -R 0:0 $JDTLS_HOME
rm /tmp/jdtls.tar.gz
cp -r $JDTLS_HOME/config_linux $HOME/.config/jdtls
# }}}

# {{{ checkstyle
curl -L --create-dirs \
	-o $HOME/.local/share/checkstyle/checkstyle.jar \
	https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.2/checkstyle-10.2-all.jar
mkdir -p ~/.local/bin
cat > ~/.local/bin/checkstyle <<SCRIPT
#!/usr/bin/env bash

exec java -jar ~/.local/share/checkstyle/checkstyle.jar "\$@"
SCRIPT
chmod +x ~/.local/bin/checkstyle
# }}}

ycm-install --java-completer

for file in post-plugin.vim plugin.vim; do
	cat "/tmp/$file" >> "$HOME/.config/nvim/$file";
	sudo rm "/tmp/$file";
done

nvim +PlugInstall +qall

sudo rm -rf /var/lib/apt/lists/*
