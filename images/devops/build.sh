#!/usr/bin/env bash

set -eo pipefail

# {{{ kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
	sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
	sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
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
sudo apt-get install -y unzip
unzip /tmp/terraform.zip
sudo mv "$PWD/terraform" /usr/local/bin
sudo apt-get remove -y unzip
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
