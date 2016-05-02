

" ~                                     ~ "
" ~ NodeJS-Focused Neovim Configuration ~ "
" ~ By: Jonathan Boudreau               ~ "
" ~                                     ~ "

"
"	~~ Plugin Load ~~
"

call plug#begin("~/.config/nvim/plugged")

" Download a better colorscheme
Plug 'crusoexia/vim-monokai'

" Better file system browser
Plug 'scrooloose/nerdtree'

" Better syntax support for js
Plug 'jelera/vim-javascript-syntax'

" Dust.js support
Plug 'jimmyhchan/dustjs.vim'

" Syntax support for editing markdown files.
Plug 'tpope/vim-markdown'

" Better javascript indentation
Plug 'pangloss/vim-javascript'

" Add HTML5 support, also enables web components support.
Plug 'othree/html5.vim'

" Fuzzy file name searcher
Plug 'kien/ctrlp.vim'

" Adds the ability to close all except the current buffer
Plug 'BufOnly.vim'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Unfortunately, neovim doesn't support bindeval, so I can't use powerline.
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" View man pages from inside vim
Plug 'vim-utils/vim-man'

" Now the tougher ones to set up

" Syntax checker.
" Requires: `npm install -g jshint` to install js support.
Plug 'scrooloose/syntastic'

" Add autocomplete support
" Requires:
" sudo apt-get install python-dev python-pip
" sudo pip install neovim
" sudo apt-get install cmake
" ~/.config/nvim/plugged/YouCompleteMe/install.py
Plug 'Valloric/YouCompleteMe'

" Install beautifier
Plug 'maksimr/vim-jsbeautify'

" Need to install the js-beautify module for the vim-jsbeautify module to
" work.
Plug 'einars/js-beautify'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

call plug#end()

"
"	~~ General Configurations ~~
"

" don't convert tabs to spaces!
set noexpandtab

" Set tabs to take two character spaces
set tabstop=2

" Set how many characters indentation should be. This will ensure that you're
" using tabs, not spaces.
set shiftwidth=2

" Add the column number
set ruler

" Display the row numbers (line number)
set relativenumber

" Add a bar on the side which delimits 100 characters. For personal use, its 80, but at work the
" guideline is 100.
set colorcolumn=100

" Will search the file as you type your query
set incsearch

" Load colors! On the initial install this will error out, so make it silent so it installs without
" issues.
silent! colorscheme monokai

set t_Co=256

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" This will close the current buffer without closing the window
command Bd bp|bd #

" Buffer delete all others (delete all except current one)
command Bdo BufOnly

" I don't want search results form node_modules in the fuzzy searcher
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](node_modules|\.git)$'
	\ }

" When running from a VM, the clipboard doesn't really quite work.
"set clipboard=unnamedplus
" This will enable both jscs and jshint at the same time
autocmd FileType javascript let b:syntastic_checkers = findfile('.jscsrc', '.;') != '' ? ['jscs', 'jshint'] : ['jshint']

" Depending on the file type, use a different formatter for :F, this is a
" range, so I can :%F, :<',>'F, etc.
autocmd Filetype javascript command! -range F <line1>,<line2>call RangeJsBeautify()
autocmd Filetype json command! -range F <line1>,<line2>call RangeJsonBeautify()
autocmd Filetype jsx command! -range F <line1>,<line2>call RangeJsxBeautify()
autocmd Filetype html command! -range F <line1>,<line2>call RangeHtmlBeautify()

" Enable the powerline fonts.
let g:airline_powerline_fonts = 1

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish
