source ~/.zplug/init.zsh

# manage zplug by zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# make command auto suggestion based on history
zplug "zsh-users/zsh-autosuggestions"
# control space
bindkey '^@' autosuggest-accept 

# command line syntax highlight
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# interative git commands
zplug "wfxr/forgit", use:forgit.plugin.zsh

zplug load
