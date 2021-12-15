alias vim='nvim'
export EDITOR=nvim

gc() {
	local commit='EDITOR=nvim git commit || bash' 
	local diff='GIT_PAGER="less -+F" git diff --staged' 

	tmux new-window "$commit" \; split-window -dh "$diff"
}
