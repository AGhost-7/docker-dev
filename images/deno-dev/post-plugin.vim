" Enable jsx by default as many projects use .js extension for jsx files.
let g:jsx_ext_required = 0

au Filetype typescript nnoremap <buffer> gd :YcmCompleter GoTo<CR>
au FileType typescript nnoremap <buffer> gD :YcmCompleter GoToReferences<cr>
au Filetype typescript nnoremap <buffer> K :YcmCompleter GetDoc<CR>
