#!/usr/bin/env bash

set -eo pipefail

sudo apt-get update

# {{{ kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
	sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
	sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
# }}}

# {{{ command line dashboard for kubernetes
curl -L -o /tmp/k9s.tar.gz \
	https://github.com/derailed/k9s/releases/download/v0.21.7/k9s_Linux_x86_64.tar.gz
mkdir -p /tmp/k9s
tar xvf /tmp/k9s.tar.gz -C /tmp/k9s
sudo mv /tmp/k9s/k9s /usr/local/bin
rm -rf /tmp/k9s
# }}}

# {{{ ansible
sudo pip3 install ansible ansible-lint
# some older dynamic inventory scripts reference `python`, they still work
# on python3 though.
sudo ln -s /usr/bin/python3 /usr/bin/python
# }}}

# {{{  terraform
curl -L -o /tmp/terraform.zip \
	"https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip /tmp/terraform.zip
sudo mv "$PWD/terraform" /usr/local/bin
rm /tmp/terraform.zip
# }}}

# {{{ azure cli
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
# }}}

# {{{ aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# }}}

# {{{ vim additions
for file in plugin.vim post-plugin.vim; do
	cat "/tmp/$file" >> "$HOME/.config/nvim/$file"
	sudo rm -f "$file"
done

nvim +PlugInstall +qall
# }}}

# {{{ firewall tool
sudo apt-get install --no-install-recommends -y nmap
# }}}

sudo rm -rf /var/lib/apt/lists/*
