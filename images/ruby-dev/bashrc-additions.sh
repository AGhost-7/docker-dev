envbind() {
	if [ "$1" == "-r" ]; then
		if [ -f ~/.envbinrc ]; then
			rvm gemset use "$(cat ~/.envbindrc)"
		fi
	else
		echo "$1" > ~/.envbindrc
	fi
}

envbind -r
