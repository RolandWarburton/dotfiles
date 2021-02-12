source ~/.zplug/init.zsh

# manage zplug by zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

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

# powerline10k
zplug romkatv/powerlevel10k, as:theme, depth:1
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
