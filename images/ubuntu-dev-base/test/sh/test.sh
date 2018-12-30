
run-tests() {
	image="aghost7-ubuntu-dev-base:$1"

	for cmd in ag docker netstat dig socat; do
		docker run --rm "$image" which "$cmd"
	done

	docker run --rm "$image" tldr man
	docker run --rm "$image" bash -c 'PAGER=cat man python' > /dev/null
}


run-tests "latest"
run-tests "bionic"
