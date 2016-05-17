set -e

rebuild-img() {
	docker build -t aghost7/${1}:${2} "$1"
	docker push aghost7/${1}:$2
}

rebuild-img ubuntu-dev-base latest
rebuild-img power-tmux latest
rebuild-img nvim latest
rebuild-img nodejs-dev v0.10.38

