
let g:LanguageClient_serverCommands = {
    \ 'java': ['/usr/local/bin/jdtls'],
    \ }

let g:deoplete#enable_at_startup = 1

call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
