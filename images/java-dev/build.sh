#!/usr/bin/env bash

set -exo pipefail


curl -o- https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
. /etc/os-release
echo "deb https://packages.adoptium.net/artifactory/deb $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt-get update
sudo apt-get install -y temurin-21-jdk

# {{{ maven
curl -L -o /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo mkdir /opt/maven
sudo tar xvf /tmp/maven.tar.gz -C /opt/maven/ --strip-component=1
# }}}

# {{{ gradle
curl -L -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-8.11.1-all.zip
sudo unzip -d /opt /tmp/gradle.zip
sudo mv /opt/gradle* /opt/gradle/
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

nvim -c 'lua require("lazy").sync(); vim.cmd("qall")'

sudo rm -rf /var/lib/apt/lists/*
