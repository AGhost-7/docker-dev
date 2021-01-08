
" The location of the rust stdlib sources for completions.
let g:ycm_rust_src_path = $HOME . '/.rustup/toolchains/' . $RUST_DEFAULT_TOOLCHAIN . '-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

" For some reason newer versions of ycm uses this variable instead. It appears
" to be a bug which will take a while to fix. In case it gets fixed, specify
" both variables for now.
let g:rust_src_path = g:ycm_rust_src_path

call g:YcmKeybindings('rust')
