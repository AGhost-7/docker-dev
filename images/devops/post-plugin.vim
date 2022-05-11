
" get documentation functionality when using ctrl+k
function! g:AnsibleDocs() abort
	let word = expand('<cword>')
	new
	setlocal buftype=nofile
	setlocal noswapfile
	nnoremap <buffer> q :bd<cr>
	exe 'read ! ansible-doc' word
	set ft=man
	setlocal nomodifiable
endfunction

autocmd Filetype yaml.ansible nmap <buffer> <C-K> :call g:AnsibleDocs()<CR>

let g:ycm_language_server = [
    \   {
    \     'name': 'terraform',
    \     'cmdline': [ 'terraform-ls', 'serve' ],
    \     'filetypes': [ 'tf' ]
    \   },
    \ ]
