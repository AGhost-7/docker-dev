#!/usr/bin/env bash

set -e

curl -o /tmp/go.tar.gz https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
cd /tmp
tar -xvf go.tar.gz
sudo mv go /usr/local
rm go.tar.gz

echo '
export PATH="$PATH:/usr/local/go/bin"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOBIN="$GOROOT/bin"
export PATH="$PATH:$GOROOT/bin"
' >> "$HOME/.bashrc"

ycm-install --gocode-completer
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

nvim +PlugInstall +qall


