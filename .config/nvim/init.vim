set nocompatible              " be iMproved, required
 
"   ____
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
Plug 'kien/ctrlp.vim'
nnoremap <C-p> :CtrlP<CR>

" #########
" # Ctags #
" #########
Plug 'ludovicchabant/vim-gutentags'
" ctrl+]	go to definition
" ctrl+t	go back

" ###############################
" #    vim-javascript syntax    #
" ###############################
Plug 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1
let g:javascript_conceal_arrow_function = "⇒"
" fix better comments not working with JS files
let g:bettercomments_language_aliases = { 'javascript': 'js' }

" And yet some more plugins
" syntax highlighting
Plug 'yuezk/vim-js'
" react highlighting / highlighting for lots of other languages too
Plug 'sheerun/vim-polyglot'

" #############
" #  vim-jsx  #
" #############
Plug 'mxw/vim-jsx'
test asdas
" #######################
" #    Quote strings    #
" #######################
Plug 'tpope/vim-surround'

" ##########################
" #    commenter script    #
" ##########################
Plug 'preservim/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 0
let g:NERDCommentEmptyLines = 1
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
" ? Instructions
" <leader>c<space>
" Toggles the comment state of the selected line(s). If the topmost selected line is commented, all selected lines are uncommented and vice versa.

" ##########################
" #    Rainbow brackets    #
" ##########################
Plug 'luochen1990/rainbow'

" ##########################
" #    Multiple cursors    #
" ##########################
Plug 'mg979/vim-visual-multi'

" ####################################
" #    Better comments (VSC port)    #
" ####################################
Plug 'jbgutierrez/vim-better-comments'
hi ErrorBetterComments guifg=#ff0000 ctermfg=196 gui=italic cterm=italic
hi HighlightBetterComments guifg=#afff00 ctermfg=154 gui=italic cterm=italic
hi QuestionBetterComments guifg=#005fff ctermfg=27 gui=italic cterm=italic
hi TodoBetterComments guifg=#af8700 ctermfg=136 gui=italic cterm=italic
hi StrikeoutBetterComments guifg=#5fafd7 ctermfg=74 gui=italic cterm=italic

Plug 'dikiaap/minimalist'
call plug#end()

"                  __ _
"  ___ ___  _ __  / _(_) __ _
" / __/ _ \| '_ \| |_| |/ _` |
"| (_| (_) | | | |  _| | (_| |
" \___\___/|_| |_|_| |_|\__, |
"                        |___/
"
set timeout timeoutlen=1000 ttimeoutlen=100

" Set , to the leader key
let mapleader = ","

" Line Numbers
set relativenumber
set nu

" Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

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

" Create a new tab
noremap <silent> <Leader>c :tabnew<CR>

" remove highlighting after greppting
nnoremap <Leader><space> :noh<cr>

" Go from horz to vert split
command TK wincmd K

" Go from vert horz to split
command TH wincmd H

" Remove the pipe char on vsplits
set fillchars+=vert:\ 

" ____            _       _       
"/ ___|  ___ _ __(_)_ __ | |_ ___ 
"\___ \ / __| '__| | '_ \| __/ __|
" ___) | (__| |  | | |_) | |_\__ \
"|____/ \___|_|  |_| .__/ \__|___/
"                  |_|           
"

" #####################
" #    Rename File    #
" #####################
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" #############################
" #    Insert Current Time    #
" #############################
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

function! Banner()
    let bannerContent = input('Banner says: ', expand(''))
    let variable = system('banner -w "bbb"')
    exec ':echon "aaa\nbbb"'
    " call append(line('$'), '' . variable)
endfunction
map <Leader>b :call Banner()<CR>

