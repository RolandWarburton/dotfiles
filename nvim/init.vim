set nocompatible
syntax on

" soft tab 4 spaces
let mapleader=','

" soft tab 2 spaces
set shiftwidth=2
set softtabstop=2
set expandtab

set relativenumber

call plug#begin()
  " NERD tree will be loaded on the first invocation of NERDTreeToggle command
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'tpope/vim-commentary'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-fugitive'
call plug#end()

let mapleader=','

" ctrl+s % and ctrl+s "
nnoremap <C-s>% :vsplit<cr>
nnoremap <C-s>" :split<cr>

" turn off regex highlighting
nnoremap <C-n> :noh<cr>

" go to function definition
nnoremap <C-\> gd

" comment with vim-commentary (ctrl+/)
nmap <C-_> gcc

"go to function definition
nnoremap <C-\> gd

" comment with vim-commentary (ctrl+/)
nmap <C-_> gcc

" show the file name in the status bar
set statusline+=%F
