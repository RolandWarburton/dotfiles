set nocompatible              " be iMproved, required

"   ____  _             _           
"  |  _ \| |_   _  __ _(_)_ __  ___ 
"  | |_) | | | | |/ _` | | '_ \/ __|
"  |  __/| | |_| | (_| | | | | \__ \
"  |_|   |_|\__,_|\__, |_|_| |_|___/
"                 |___/             
" 
" Plugins with vim-plug
" https://github.com/junegunn/vim-plug
" For Neovim
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

call plug#begin('~/.config/nvim/plugged')

" #############
" #  Fuzzing  #
" #############
Plug 'cloudhead/neovim-fuzzy'
nnoremap <C-p> :FuzzyOpen<CR>
" Once in the fzy finder:
" <Esc>     close fzy pane
" <Enter>   open selected file with default open command
" <Ctrl-S>  open selected file in new horizontal split
" <Ctrl-V>  open selected file in new vertical split
" <Ctrl-T>  open selected file in new tab
" <Ctrl-N>  next entry
" <Ctrl-P>  previous entry

" #########
" # Ctags #
" #########
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

"                  __ _
"  ___ ___  _ __  / _(_) __ _
" / __/ _ \| '_ \| |_| |/ _` |
"| (_| (_) | | | |  _| | (_| |
" \___\___/|_| |_|_| |_|\__, |
"                        |___/
"
" Line Numbers
set relativenumber
set nu

" Tabs
"set tabstop=4 softtabstop=4

" Syntax highlighting
syntax on
" Color support
set t_Co=256

" Copy paste with X clipboard
vnoremap <C-c> "+y

" Highlighting text so i can actually see what im highlighting
hi Visual  guifg=#000000 guibg=#FFFFFF gui=none

" Window splits
set splitbelow splitright

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Ignore node_modules when finding files and such
set wildignore+=**/node_modules/**

" Display all matching files when tab completing
set wildmenu
filetype plugin on

"  _  __          _     _           _     
" | |/ /___ _   _| |__ (_)_ __   __| |___ 
" | ' // _ \ | | | '_ \| | '_ \ / _` / __|
" | . \  __/ |_| | |_) | | | | | (_| \__ \
" |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
"           |___/                         
"
" keybinds

" Remap split navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Adjust window sizes with keybind
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Go from horz to vert split
command TK wincmd K
" Go from vert horz to split
command TH wincmd H

" Remove the pipe char on vsplits
set fillchars+=vert:\ 
