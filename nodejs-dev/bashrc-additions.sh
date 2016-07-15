# Just want to ignore the node_modules directory. Rest is the same as stock.
export FZF_CTRL_T_COMMAND="command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
		-o -path '*/node_modules/*' -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /tmp/fzf.err | sed 1d | cut -b3-"

