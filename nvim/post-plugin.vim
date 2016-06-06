" Buffer delete all others (delete all except current one)
command Bdo BufOnly

" Load colors! On the initial install this will error out, so make it silent so it installs without
" issues.
silent! colorscheme monokai

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" Enable the powerline fonts.
let g:airline_powerline_fonts = 1

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish

" Enable mouse mode, just don't want to have the single click so I can split
" the panel when I feel like it.
let g:NERDTreeMouseMode = 2
