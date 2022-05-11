
call g:YcmKeybindings('java')

" disable broken linter
let g:ale_linters_ignore = { "java": ["javac"] }
