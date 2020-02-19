set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin('/home/roland/.config/vim')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

set relativenumber
syntax on
set t_Co=16
