set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin('/home/roland/.config/vim')
" alternatively, pass a path where Vundle should install plugins
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on " Used for triggering plugins for different filetypes

" Install plugins with
" :PluginInstall - installs plugins; append `!` to update or just :PluginUpdate
" :PluginList    - lists configured plugins
" :PluginClean   - confirms removal of unused plugins; append `!` to auto-approve removal

set relativenumber
syntax on
set t_Co=16

" copy and paste in vim
" visual non recursive remap ctrl-c to yank to + register (xorg)
vnoremap <C-c> "+y
" Map ctrl-p to paste
map <C-v> "+p
