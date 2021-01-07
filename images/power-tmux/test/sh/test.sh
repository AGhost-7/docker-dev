
podman run --rm "$IMAGE" which powerline-daemon

files="$(podman run --rm "$IMAGE" find /home/aghost-7 -group root)"

if [ "$files" != "" ]; then
	echo Bad file permissions...
	exit 1
fi

tmuxVersion="$(podman run --rm "$IMAGE" tmux -V)"
if [[ "$tmuxVersion" != "tmux 3.0a" ]]; then
	echo Version $tmuxVersion is not equal 3.0a
	exit 1
fi

imgLocale="$(podman run --rm -t "$IMAGE" locale -a)"

if [[ "$imgLocale" != *"en_US.utf8"* ]]; then
	echo Missing en_US locale
	exit 1
fi
