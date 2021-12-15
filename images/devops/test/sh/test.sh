
for cmd in kubectl tfswitch ansible; do
	podman run -ti --rm "$IMAGE" bash -i -c "which $cmd"
done
