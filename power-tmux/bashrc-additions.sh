export PATH="$PATH:$HOME/.local/bin"
export TERM=screen-256color

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh

# If the tmux session doesn't exist then start it up
if [[ "$TMUX" == "" ]]; then
	exec tmux new -A -s root
fi

# detach instead if in tmux session...
exit () {
	if [[ "$TMUX" == "" ]]; then
		builtin exit
	else
		tmux detach
	fi
}

export FZF_DEFAULT_OPTS='--color=light,hl:12,hl+:15,info:10,bg+:4'

# Utility to set "current working directory". For each new tab or window
# you won't need to cd to the project config every time.

fbind () {
	case "$1" in
		-u)
			rm ~/.bindrc
			;;
		-c)
			if [ -f ~/.bindrc ]; then
				cd `cat ~/.bindrc`
			fi
			;;
		*)
			echo `readlink -f "$1"` > ~/.bindrc
			;;
	esac
}

fbind -c
