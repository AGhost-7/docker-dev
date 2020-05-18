
au FileType ruby nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
au FileType ruby nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
au FileType ruby nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
au FileType ruby nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

let g:LanguageClient_serverCommands = {
	\ 'ruby': [ 'solargraph',  'stdio' ],
	\ }
