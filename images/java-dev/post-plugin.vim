
call g:YcmKeybindings('java')

" disable broken linter
let g:ale_linters_ignore = { "java": ["javac"] }

let s:checkstyle_config = glob('*checkstyle*.xml')
if len(s:checkstyle_config) > 0
    let g:ale_java_checkstyle_config = s:checkstyle_config
else
    call add(g:ale_linters_ignore["java"], "checkstyle")
end
