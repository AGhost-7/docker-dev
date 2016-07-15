" This file contains configurations which are specific to the plugins
" loaded. Its in a seperate file since these need to be places after the 
" plug#end call.

" Download a better colorscheme
Plug 'crusoexia/vim-monokai'

" Better file system browser
Plug 'scrooloose/nerdtree'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

" Fuzzy file name searcher
Plug 'kien/ctrlp.vim'

" Adds the ability to close all except the current buffer
Plug 'BufOnly.vim'

" Unfortunately, neovim doesn't support bindeval, so I can't use powerline.
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" View man pages from inside vim
Plug 'vim-utils/vim-man'

" Async linter!
Plug 'neomake/neomake'

" Add autocomplete support
" Requires:
" sudo apt-get install python-dev python-pip
" sudo pip install neovim
" sudo apt-get install cmake
" ~/.config/nvim/plugged/YouCompleteMe/install.py
Plug 'Valloric/YouCompleteMe'

" Minimalist mode.
Plug 'junegunn/goyo.vim'

" Required for sql completion
Plug 'vim-scripts/dbext.vim'
