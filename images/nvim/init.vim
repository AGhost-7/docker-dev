

" ~                                     ~ "
" ~ NodeJS-Focused Neovim Configuration ~ "
" ~ By: Jonathan Boudreau               ~ "
" ~                                     ~ "

"
"	~~ Plugin Load ~~
"

call plug#begin("~/.config/nvim/plugged")

source ~/.config/nvim/plugin.vim

call plug#end()

"
"	~~ General Configurations ~~
"

" don't convert tabs to spaces
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

" Make the line number show up in the gutter instead of just '0'.
set number

" Add a bar on the side which delimits 80 characters.
set colorcolumn=80

" 72 characters makes it easier to read git log output.
autocmd Filetype gitcommit setl colorcolumn=72

" Will search the file as you type your query
set incsearch

set termguicolors

" This will close the current buffer without closing the window
command Bd bp|bd #

" Enable clipboard. Can use x11 forwarding or socket mounting to
" make host clipboard accessible by the container.
set clipboard+=unnamedplus

" Using the blazing fast ag search tool for lgrep calls instead.
set grepprg=ag\ --nogroup\ --nocolor

" For some reason the mouse isn't enabled by default anymore...
set mouse=a

" Annnd, load the plugin-specific configurations.
source ~/.config/nvim/post-plugin.vim

" Folds start as opened instead of closed
set foldlevelstart=99

" Enable folds that are for the most part placed in the comments.
set foldmethod=marker

" Let the linter / formatter take care of additional line breaks and the end
" of the file.
set nofixendofline
