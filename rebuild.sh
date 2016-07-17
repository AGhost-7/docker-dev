set -e

push=1
case "$1" in
	"--no-push")
		push=0
		;;
esac

if [[ "$push" == "0" ]]; then
	echo Skipping pushing to dockerhub
fi

rebuild-img() {
	docker build -t aghost7/${1}:${2} "$1"
	if [[ "$push" == "1" ]]; then
		docker push aghost7/${1}:$2
	fi
}

rebuild-node() {
	docker build -t aghost7/nodejs-dev:${1} --build-arg NODE_VERSION="$1" nodejs-dev
	if [[ "$push" == "1" ]]; then
		docker push aghost7/nodejs-dev:${1}
	fi
}

rebuild-img ubuntu-dev-base latest
rebuild-img power-tmux latest
rebuild-img nvim latest
rebuild-node v0.10.38
rebuild-node v4.4.4
rebuild-img rust-dev stable
rebuild-img py-dev 2.7
rebuild-img scala-dev latest
