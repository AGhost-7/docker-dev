
image="aghost7/ubuntu-dev-base:$1"

container_cli=podman

podman run --rm "$image" which "$container_cli"

for cmd in netstat dig socat tree tcpflow ssh; do
	podman run --rm "$image" which "$cmd"
done

podman run --rm "$image" tldr man
podman run --rm "$image" bash -c 'PAGER=cat man python' > /dev/null
