set -e

rebuild-img() {
	docker build -t aghost7/${1}:${2} "$1"
	docker push aghost7/${1}:$2
}

rebuild-node() {
	docker build -t aghost7/nodejs-dev:${1} --build-arg NODE_VERSION="$1" nodejs-dev
	docker push aghost7/nodejs-dev:${1}
}

rebuild-img ubuntu-dev-base latest
rebuild-img power-tmux latest
rebuild-img nvim latest
rebuild-node v0.10.38
rebuild-node v4.4.4
rebuild-img rust-dev stable
