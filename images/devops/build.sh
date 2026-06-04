#!/usr/bin/env bash

set -eo pipefail

. /etc/os-release

set -x

sudo apt-get update

# {{{ kubectl
if [ "$(uname -m)" = "x86_64" ]; then arch=amd64; else arch=arm64; fi
curl -L --create-dirs -o ~/.local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$arch/kubectl"
chmod +x ~/.local/bin/kubectl
# }}}

# {{{ install helm
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
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
url=https://github.com/warrensbox/terraform-switcher/releases/download/v1.18.0/terraform-switcher_v1.18.0_linux_arm64.tar.gz
if [ "$(uname -m)" = "x86_64" ]; then
	url=https://github.com/warrensbox/terraform-switcher/releases/download/v1.18.0/terraform-switcher_v1.18.0_linux_arm64.tar.gz
fi
curl -Lo /tmp/tfswitch/tfswitch.tar.gz "$url"
tar xvf /tmp/tfswitch/tfswitch.tar.gz -C /tmp/tfswitch
mv /tmp/tfswitch/tfswitch ~/.local/bin/tfswitch
rm -rf /tmp/tfswitch
# }}}

# {{{ azure cli
pipx install azure-cli
pipx inject azure-cli setuptools
# }}}

# {{{ azure aks authentication
url=https://github.com/Azure/kubelogin/releases/download/v0.2.17/kubelogin-linux-arm64.zip
if [ "$(uname -m)" = "x86_64" ]; then
	url=https://github.com/Azure/kubelogin/releases/download/v0.2.17/kubelogin-linux-amd64.zip
fi
curl -L -o /tmp/kubelogin.zip https://github.com/Azure/kubelogin/releases/download/v0.1.4/kubelogin-linux-amd64.zip
cd /tmp
unzip /tmp/kubelogin.zip
mv bin/linux_amd64/kubelogin ~/.local/bin
rm -rf /tmp/{bin,kubelogin.zip}
cd -
# }}}

# {{{ bash additions
cat /tmp/zshrc-additions.sh >> ~/.zshrc
sudo rm /tmp/zshrc-additions.sh
# }}}

# {{{ firewall tool
sudo apt-get install --no-install-recommends -y nmap
# }}}

sudo rm -rf /var/lib/apt/lists/*
