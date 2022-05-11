#!/usr/bin/env bash

set -eo pipefail

. /etc/os-release

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
rm /tmp/k9s.tar.gz
# }}}

# {{{ install helm
curl -L -o /tmp/helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar xvf /tmp/helm.tar.gz -C /tmp
mv /tmp/linux-amd64/helm ~/.local/bin/helm
rm -rf /tmp/{helm.tar.gz,linux-amd64}
# }}}

# {{{ ansible
sudo pip3 install ansible ansible-lint
# some older dynamic inventory scripts reference `python`, they still work
# on python3 though.
sudo ln -s /usr/bin/python3 /usr/bin/python
# }}}

# {{{ install hashicorp vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://apt.releases.hashicorp.com $VERSION_CODENAME main" | \
	sudo tee /etc/apt/sources.list.d/vault.list
sudo apt-get update
sudo apt-get install -y --no-install-recommends vault
# https://github.com/hashicorp/vault/issues/10048#issuecomment-706315167
sudo setcap cap_ipc_lock= /usr/bin/vault
# }}}

# {{{ lsp server
sudo apt-get install -y --no-install-recommends terraform-ls
# }}}

# {{{ install terraform switcher
echo 'bin = "/home/aghost-7/.local/bin/terraform"' > ~/.tfswitch.toml
mkdir -p ~/.terraform.versions /tmp/tfswitch
curl -Lo /tmp/tfswitch/tfswitch.tar.gz https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1201/terraform-switcher_0.13.1201_linux_amd64.tar.gz
tar xvf /tmp/tfswitch/tfswitch.tar.gz -C /tmp/tfswitch
mv /tmp/tfswitch/tfswitch ~/.local/bin/tfswitch
rm -rf /tmp/tfswitch
# }}}

# {{{ azure cli
pip install azure-cli==2.29
# }}}

# {{{ aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf ~/{awscliv2.zip,aws}
# }}}

# {{{ vim additions
for file in plugin.vim post-plugin.vim; do
	cat "/tmp/$file" >> "$HOME/.config/nvim/$file"
	sudo rm -f "/tmp/$file"
done

nvim +PlugInstall +qall
# }}}

# {{{ bash additions
cat /tmp/bashrc-additions.sh >> ~/.bashrc
sudo rm /tmp/bashrc-additions.sh
# }}}

# {{{ firewall tool
sudo apt-get install --no-install-recommends -y nmap
# }}}

sudo rm -rf /var/lib/apt/lists/*
