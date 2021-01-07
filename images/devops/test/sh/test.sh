
for cmd in kubectl terraform ansible; do
	podman run --rm "$IMAGE" which "$cmd"
done
