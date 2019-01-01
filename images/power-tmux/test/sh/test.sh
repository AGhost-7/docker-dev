
docker run --rm aghost7/power-tmux:latest which powerline-daemon

files="$(docker run --rm aghost7/power-tmux:latest find /home/aghost-7 -group root)"

if [ "$files" != "" ]; then
	echo Bad file permissions...
	exit 1
fi

tmuxVersion="$(docker run --rm aghost7/power-tmux:latest tmux -V)"
if [[ "$tmuxVersion" != "tmux 2.7" ]]; then
	echo Version $tmuxVersion is not equal 2.7
	exit 1
fi

imgLocale="$(docker run --rm -t aghost7/power-tmux:latest locale -a)"

if [[ "$imgLocale" != *"en_US.utf8"* ]]; then
	echo Missing en_US locale
	exit 1
fi
