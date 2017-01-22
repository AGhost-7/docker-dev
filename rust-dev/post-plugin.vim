
" The location of the rust stdlib sources for completions.
let g:ycm_rust_src_path = '/home/aghost-7/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

" When using `gd`, this will jump to either the definition
" or declaration (depending on what the cursor is on).
nmap gd :YcmCompleter GoTo<CR>

" Fetch documentation when using `\gd`.
nmap <leader>gd :YcmCompleter GetDoc<CR>
