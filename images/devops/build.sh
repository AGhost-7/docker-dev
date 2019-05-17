#!/usr/bin/env bash

# {{{ kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
	sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
	sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
# }}}

# {{{ ansible
sudo pip3 install ansible
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
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
# }}}

sudo rm -rf /var/lib/apt/lists/*
