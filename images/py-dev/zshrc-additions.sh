
# Utility function which automatically load the virtualenv on new tmux
# panes.
envbind() {
	if [ "$1" == "-r" ]; then
		if [ -f ~/.envbindrc ]; then
			source "$(cat ~/.envbindrc)/bin/activate"
		fi
	elif [ -f "$1/bin/activate" ] && [[ "$1/bin/activate" == /* ]]; then
		echo "$1" > ~/.envbindrc
	elif [ -f "$PWD/$1/bin/activate" ]; then
		echo "$PWD/$1" > ~/.envbindrc
	fi

}

envbind -r
