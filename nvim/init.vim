set nocompatible
syntax on

let mapleader=','

" soft tab 2 spaces
set shiftwidth=2
set softtabstop=2
set expandtab

" ctrl+s % and ctrl+s "
nnoremap <C-s>% :Vexplore<cr>
nnoremap <C-s>" :Hexplore<cr>

" turn off regex highlighting
nnoremap <C-n> :noh<cr>

"go to function definition
nnoremap <C-\> gd
