
image="aghost7/ubuntu-dev-base:$1"

container_cli=podman
if [ "$1" = "bionic" ]; then
	container_cli=docker
fi

docker run --rm "$image" which "$container_cli"

for cmd in netstat dig socat tree tcpflow ssh; do
	docker run --rm "$image" which "$cmd"
done

docker run --rm "$image" tldr man
docker run --rm "$image" bash -c 'PAGER=cat man python' > /dev/null
