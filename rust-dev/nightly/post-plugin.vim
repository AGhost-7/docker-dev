
let g:LanguageClient_serverCommands = {
	\ 'rust': ['rustup', 'run', 'nightly', 'rls']
	\ }

let g:LanguageClient_autoStart = 1
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
