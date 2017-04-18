alias vim='nvim'
export EDITOR=nvim
export PATH=$PATH:/root/.local/bin

gc() {
	local commit='EDITOR=nvim git commit || bash' 
	local diff='GIT_PAGER="less -+F" git diff --staged' 

	tmux new-window "$commit" \; split-window -dh "$diff"
}
