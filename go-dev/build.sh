#!/usr/bin/env bash

curl -o /tmp/go.tar.gz https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
cd /tmp
tar -xvf go.tar.gz
sudo mv go /usr/local
rm go.tar.gz

echo '
export PATH="$PATH:/usr/local/go/bin"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOROOT/bin"
' >> $HOME/.bashrc

nvim +PlugInstall +qall
