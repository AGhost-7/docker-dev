" Buffer delete all others (delete all except current one)
command Bdo BufOnly

" Load colors! On the initial install this will error out, so make it silent 
" so it installs without issues.
silent! colorscheme monokai

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" Enable the powerline fonts.
let g:airline_powerline_fonts = 1

" Show the buffers at the top
let g:airline#extensions#tabline#enabled = 1

" Show the buffer numbers so I can `:b 1`, etc
let g:airline#extensions#tabline#buffer_nr_show = 1

" Aside from the buffer number, I literally just need the file name, so
" strip out extraneous info.
let g:airline#extensions#tabline#fnamemod = ':t'

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish

let g:NERDTreeMouseMode = 3

autocmd! BufEnter,BufWritePost * Neomake

" Use spaces instead just for yaml
autocmd Filetype yaml setl expandtab

" Force the emoji to show up in the completion dropdown
let g:github_complete_emoji_force_available = 1
