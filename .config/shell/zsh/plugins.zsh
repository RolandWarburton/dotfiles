source "${HOME}/.zgen/zgen.zsh"

# make command auto suggestion based on history
zgen load "zsh-users/zsh-autosuggestions"
# control space
bindkey '^@' autosuggest-accept 

# command line syntax highlight
zgen load "zsh-users/zsh-syntax-highlighting"

if [[ -f ~/.theme-current && $(cat ~/.theme-current) == "light" ]]; then
  echo "light theme"
  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
  export "ZSH_HIGHLIGHT_STYLES[bracket-level-1]"='fg=black,bold'
  export "ZSH_HIGHLIGHT_STYLES[bracket-level-2]"='fg=black,bold'
  export "ZSH_HIGHLIGHT_STYLES[bracket-level-3]"='fg=black,bold'
  export "ZSH_HIGHLIGHT_STYLES[bracket-level-4]"='fg=black,bold'
  export ZSH_HIGHLIGHT_STYLES[path]='fg=black'
  export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=black'
  export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=black'
  export ZSH_HIGHLIGHT_STYLES[command]='fg=black'
  export ZSH_HIGHLIGHT_STYLES[builtin]='fg=#034b03'
fi


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
