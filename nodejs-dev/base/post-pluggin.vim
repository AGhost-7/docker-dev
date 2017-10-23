
" Simple debugger integration.

fu! g:SendDBBreak()
	call system("tmux send-keys -t right 'sb(" . line('.') . ")\n'")
endfu

fu! g:SendDBCmd(cmd)
	call system("tmux send-keys -t right '" . a:cmd . "\n'")
endfu

nnoremap ,b :call g:SendDBBreak()<cr>
nnoremap ,s :call g:SendDBCmd('s')<cr>
nnoremap ,n :call g:SendDBCmd('n')<cr>
nnoremap ,c :call g:SendDBCmd('c')<cr>
nnoremap ,r :call g:SendDBCmd('r')<cr>
nnoremap ,R :call g:SendDBCmd('restart')<cr>
