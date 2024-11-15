#!/usr/bin/env bash

set -eo pipefail

. /etc/os-release

set -x

sudo apt-get update

# {{{ kubectl
curl -L --create-dirs -o ~/.local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ~/.local/bin/kubectl
# }}}

# {{{ install helm
curl -L -o /tmp/helm.tar.gz https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz
tar xvf /tmp/helm.tar.gz -C /tmp
mv /tmp/linux-amd64/helm ~/.local/bin/helm
rm -rf /tmp/{helm.tar.gz,linux-amd64}
export PATH="$PATH:$HOME/.local/bin"
# }}}

# {{{ install helm diff
helm plugin install https://github.com/databus23/helm-diff
# }}}

# {{{ ansible
if [ "$UBUNTU_RELEASE" = "jammy"]; then
	sudo pip3 install ansible ansible-lint
else
	sudo pip3 install --break-system-packages ansible ansible-lint
fi
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

# {{{ install terraform switcher
echo 'bin = "/home/aghost-7/.local/bin/terraform"' > ~/.tfswitch.toml
mkdir -p ~/.terraform.versions /tmp/tfswitch
curl -Lo /tmp/tfswitch/tfswitch.tar.gz https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1288/terraform-switcher_0.13.1288_linux_amd64.tar.gz
tar xvf /tmp/tfswitch/tfswitch.tar.gz -C /tmp/tfswitch
mv /tmp/tfswitch/tfswitch ~/.local/bin/tfswitch
rm -rf /tmp/tfswitch
# }}}

# {{{ azure cli
pipx install azure-cli
pipx inject azure-cli setuptools
# }}}

# {{{ azure aks authentication
curl -L -o /tmp/kubelogin.zip https://github.com/Azure/kubelogin/releases/download/v0.1.4/kubelogin-linux-amd64.zip
cd /tmp
unzip /tmp/kubelogin.zip
mv bin/linux_amd64/kubelogin ~/.local/bin
rm -rf /tmp/{bin,kubelogin.zip}
cd -
# }}}

# {{{ aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf ~/{awscliv2.zip,aws}
# }}}

# {{{ bash additions
cat /tmp/zshrc-additions.sh >> ~/.zshrc
sudo rm /tmp/zshrc-additions.sh
# }}}

# {{{ firewall tool
sudo apt-get install --no-install-recommends -y nmap
# }}}

sudo rm -rf /var/lib/apt/lists/*
