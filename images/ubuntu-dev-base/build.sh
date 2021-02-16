#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -eo pipefail

# Print every line executed to the terminal.
set -x

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

apt-get update

if [ "$UBUNTU_RELEASE" = "focal" ]; then
	# fixes issue in newer releases:
	# https://github.com/sudo-project/sudo/issues/42#issuecomment-609079906
	echo "Set disable_coredump false" >> /etc/sudo.conf
fi

yes | unminimize || true

# Super essential tools
apt-install tree curl

# Going to need this a lot
apt-install python3-pip

pip3 install setuptools

# See readme for how to get the clipboard working.
apt-install xclip

# To cryptographically sign git commits
apt-install gpg gpg-agent

. /etc/os-release

# install podman / buildah on newer releases
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add -
apt-get update
apt-install podman
apt-install buildah

# Man pages on base debian image aren't installed...
apt-install man-db

# tldr for a short form man pages.
pip3 install tldr

# Just gitgud
pip3 install gitgud

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc. On ubuntu focal, tzdata is also getting installed, so gotta
# work around that.
export DEBIAN_FRONTEND=noninteractive
echo 'Etc/UTC' | sudo tee /etc/timezone
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# cheap reverse proxy
apt-install socat

# Packet sniffer for debugging.
apt-install tcpflow tcpdump

# Very usefull for finding issues coming from syscalls
apt-install strace

# Install bash tab completion.
apt-install bash-completion

# ssh
apt-install openssh-client

# get lines of code in a directory
apt-install cloc

# pager better than less...
apt-install less

# useful for querying json
apt-install jq

# ping servers
apt-install inetutils-ping

# for figuring out routing issues in the network
apt-install inetutils-traceroute

# replacement for ifconfig
apt-install iproute2

# used all the time
apt-install -y zip unzip

# magically detects file type without extension
apt-install file

# Expose local servers to the internet. Useful for testing webhooks, oauth,
# etc.
curl -o /tmp/ngrok.zip \
	https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
sudo unzip /tmp/ngrok.zip -d /usr/local/bin
rm /tmp/ngrok.zip

# Install latest git
apt-install git

# subcommand which opens the branch you're checked out on github.
git clone --depth 1 https://github.com/paulirish/git-open /tmp/git-open
sudo cp /tmp/git-open/git-open /usr/local/bin
rm -rf /tmp/git-open

# Required for so many languages this will simply be included by default.
apt-install build-essential pkgconf

# yes
git clone --depth 1 https://github.com/klange/nyancat /tmp/nyancat
cd /tmp/nyancat
make
sudo make install
cd /
rm -rf /tmp/nyancat

# Mail client for testing
apt-install swaks

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# Alias for tree view of commit history.
git config --system alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"

# silence new message from git
git config --system pull.rebase false

# set the hooks path to be global instead of local to a project
git config --system core.hooksPath '~/.config/git/hooks'
su aghost-7 -c 'mkdir -p ~/.config/git/hooks'

# cache is useless to keep
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

