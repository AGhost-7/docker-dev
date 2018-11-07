
let g:LanguageClient_serverCommands = {
\ 'c': ['/usr/local/bin/cquery',
\ '--log-file=/tmp/cq.log',
\ '--init={"cacheDirectory":"' . $HOME . '/.cache/cquery"}']
\ }

au FileType c nnoremap <silent> <buffer> K :call LanguageClient#textDocument_hover()<CR>
au FileType c nnoremap <silent> <buffer> gd :call LanguageClient#textDocument_definition()<CR>

call deoplete#custom#source('LanguageClient',
	\ 'min_pattern_length',
	\ 2)

let g:deoplete#enable_at_startup = 1
