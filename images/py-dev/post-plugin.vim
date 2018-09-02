
" Use python3 for completions
let g:ycm_python_binary_path = '/usr/bin/python3'

au FileType python nmap <buffer> gd :YcmCompleter GoTo<cr>
au FileType python nmap <buffer> K :YcmCompleter GetDoc<cr>
