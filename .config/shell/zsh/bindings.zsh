# This function is for debugging purposes
function hello_function { echo "hello" }
zle -N hello_widget hello_function
#bindkey '^E' hello_widget

# edit the current command in the default $EDITOR
# use alt+v to enter visual mode
bindkey -v

# Bind "control + arrow" to fwd and back word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Bind "control + delete" to kill word (in non tmux mode)
#bindkey "^[[3~" kill-word
bindkey "^[[3^" kill-word

# Bind "control + delete" to kill word (in tmux mode)
bindkey "^[[3;5~" kill-word

# bind "control + r"
bindkey '^R'    history-incremental-search-backward

# Press alt+v to go into full line editor
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Bind pgup and pgdown to search up and down history
# For example i run 3 commands: echo a, echo b, whoami
# Then i type "echo " and press pgup, i will be given "echo b"
bindkey "^[[5~" history-beginning-search-backward     # PgUp for history search
bindkey '^[[6~' history-beginning-search-forward      # PgDown for history search

# Source the zkbd term file to get many common keys working
if [[ -a ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]]; then
  source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
  [[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
  [[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
  [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
  [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
  [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
  [[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
  [[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
  [[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
  [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
  [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
fi
