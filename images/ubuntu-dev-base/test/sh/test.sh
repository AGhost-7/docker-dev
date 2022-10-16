
container_cli=podman

podman run --rm "$IMAGE" which "$container_cli"

for cmd in netstat dig socat tree tcpflow ssh; do
	podman run --rm -i "$IMAGE" which "$cmd"
done

podman run --rm "$IMAGE" tldr man
podman run --rm "$IMAGE" bash -c 'PAGER=cat man python' > /dev/null
