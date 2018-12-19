DAY_OF_WEEK="$(date %A)"
if [ "$DAY_OF_WEEK" == "Friday" ]; then
	export PS1='🍺 \W > '
else
	case "$(date +%m-%d)" in
		10-31)
			export PS1='🎃 \W >'
			;;
		12-25)
			export PS1='🎅  \W >'
			;;
		*)
			export PS1='\W > '
			;;
	esac
fi
