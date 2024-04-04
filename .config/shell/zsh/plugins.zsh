source "${HOME}/.zgen/zgen.zsh"

# make command auto suggestion based on history
zgen load "zsh-users/zsh-autosuggestions"
# control space
bindkey '^@' autosuggest-accept 

# command line syntax highlight
zgen load "zsh-users/zsh-syntax-highlighting"

# interative git commands
zgen load 'wfxr/forgit'

export ZSH_SELECT_WITH_LF_DIR_BIND="^g"
export ZSH_SELECT_WITH_LF_FILE_BIND="^p"
LF_SELECT_PLUGIN_PATH="$HOME/.zsh/plugins/zsh-select-with-lf.plugin.zsh"
if [ -f "$LF_SELECT_PLUGIN_PATH" ]; then
  source "$LF_SELECT_PLUGIN_PATH"
fi

LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
  source "$LFCD"
fi
