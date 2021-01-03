set nocompatible              " be iMproved, required

"                        _ _
" __   ___   _ _ __   __| | | ___
" \ \ / / | | | '_ \ / _` | |/ _ \
"  \ V /| |_| | | | | (_| | |  __/
"   \_/  \__,_|_| |_|\__,_|_|\___|
"
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin('/home/roland/.config/vim')

" alternatively, pass a path where Vundle should install plugins
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular'
" Plugin 'plasticboy/vim-markdown'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on " Used for triggering plugins for different filetypes

" Install plugins with
" :PluginInstall - installs plugins; append `!` to update or just :PluginUpdate
" :PluginList    - lists configured plugins
" :PluginClean   - confirms removal of unused plugins; append `!` to auto-approve removal

"                  __ _
"  ___ ___  _ __  / _(_) __ _
" / __/ _ \| '_ \| |_| |/ _` |
"| (_| (_) | | | |  _| | (_| |
" \___\___/|_| |_|_| |_|\__, |
"                        |___/
"

" Fix block and line cursors inside tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

" on debian 10, when inside tmux, it likes to set $TERM to screen-256color
" Adding this fixes ctrl+arrow keys from not working by emulating the xterm keys
" see //superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Line Numbers
set relativenumber
set nu

" Tabs
set tabstop=4 softtabstop=4

" Syntax highlighting
syntax on
" Color support
set t_Co=256

" Copy paste with X clipboard
vnoremap <C-c> "+y
