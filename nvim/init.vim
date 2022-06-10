set nocompatible
syntax on

" soft tab 4 spaces
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
call plug#end()

let mapleader=','

nnoremap <C-s>% :Vexplore<cr>
nnoremap <C-s>" :Hexplore<cr>

" turn off regex highlighting
nnoremap <C-n> :noh<cr>

" go to function definition
nnoremap <C-\> gd

" comment with vim-commentary (ctrl+/)
nmap <C-_> gcc

