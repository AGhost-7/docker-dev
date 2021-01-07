image="aghost7/devops:$1"

for cmd in kubectl terraform ansible; do
	podman run --rm "$image" which "$cmd"
done
