
arch=amd64
if [ "$(uname -m)" = "aarch64" ]; then
  arch=arm64
fi

export JAVA_HOME="/usr/lib/jvm/temurin-21-jdk-$arch"
