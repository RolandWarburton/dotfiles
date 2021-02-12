export PATH=/usr/bin/pip3:$PATH
export LC_ALL="en_US.UTF-8"
export EDITOR=vim

# run `zkbd` after booting to set your keybinds
autoload zkbd

# load the completions system on $fpath and ignore all insecure files and directories
# insecure = files that dont belong to root or you
autoload compinit -i

# I redefine the wordchars and exclude "/" from it.
# This causes `cd /first/second` C+W to return `cd /first/`
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

# Set the theme for p10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Use a history file to persist history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY

# Import all the things
source ~/.zsh/bindings.zsh
source ~/.zsh/autocomplete.zsh
source ~/.zsh/zsh_aliases
source ~/.zsh/plugins.zsh
source ~/.zsh/exports.zsh

# Load in the nvm environment to manage node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

