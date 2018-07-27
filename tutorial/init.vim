
" Start the list of vim plugins
call plug#begin("~/.config/nvim/plugged")

" Download a better colorscheme
Plug 'crusoexia/vim-monokai'

" Better file system browser
Plug 'scrooloose/nerdtree'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

" Github integration
Plug 'tpope/vim-rhubarb'

" Fuzzy file name searcher
Plug 'kien/ctrlp.vim'

" plugin for the tab and status bar
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" Git commit browser
Plug 'junegunn/gv.vim'

" AutoComplete
Plug 'Valloric/YouCompleteMe'

" End the list of vim plugins
call plug#end()

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

" For some reason the mouse isn't enabled by default anymore...
set mouse=a

" Enable folds that are for the most part placed in the comments.
set foldmethod=marker

" Add a mapping for the NERDTree command, so you can just type :T to open
command T NERDTree

" set global theme
silent! colorscheme monokai

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish
