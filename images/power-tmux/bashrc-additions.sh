export PATH="$PATH:$HOME/.local/bin"
export TERM=screen-256color

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1 \
POWERLINE_BASH_SELECT=1 \
	. /usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh

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

alias nyan='nc -v nyancat.dakko.us 23'
alias parrot='curl parrot.live'
alias tmate='tmate -f ~/.tmate.conf'
