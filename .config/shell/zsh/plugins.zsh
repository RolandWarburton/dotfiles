source "${HOME}/.zgen/zgen.zsh"

# make command auto suggestion based on history
zgen load "zsh-users/zsh-autosuggestions"
# control space
bindkey '^@' autosuggest-accept 

# command line syntax highlight
zgen load "zsh-users/zsh-syntax-highlighting"

# interative git commands
zgen load 'wfxr/forgit'

LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
  source "$LFCD"
fi
