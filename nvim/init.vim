set nocompatible
" Fix the cursor not going from block to line (works most of the time)
"if exists('$TMUX')
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
"else
"    " it appears that this breaks neovim, however leave it for regular vim
"    let &t_SI = "\e[5 q"
"    let &t_EI = "\e[2 q"
"endif
syntax on

" soft tab 2 spaces
set shiftwidth=2
set softtabstop=2
set expandtab

" Fix home/end key in all modes (or at least works in uxrvt/zsh/tmux)
map <esc>OH <home>
cmap <esc>OH <home>
imap <esc>OH <home>
map <esc>OF <end>
cmap <esc>OF <end>
imap <esc>OF <end>

" Fix ctrl+arrow keys not working (or at least in urxvt/zsh/tmux)
map <esc>[1;5D <C-Left>
map <esc>[1;5C <C-Right>
imap <esc>[1;5D <C-Left>
imap <esc>[1;5C <C-Right>

