export PATH=/usr/bin/pip3:$PATH
export LC_ALL="en_US.UTF-8"
export EDITOR=vim

# https://wiki.archlinux.org/title/Xfce#SSH_agents
xfconf-query -c xfce4-session -p /startup/ssh-agent/type -n -t string -s ssh-agent
# start the keyring
# https://wiki.archlinux.org/title/GNOME/Keyring#--start_step
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi


# when using the mv command include hidden .files
setopt glob_dots

# share zsh command history between terminal sessions/windows
setopt share_history

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

# keyring stuff idk
#eval $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
#export SSH_AUTH_SOCK

# Import all the things
source ~/environment.zsh
source ~/.zsh/bindings.zsh
source ~/.zsh/autocomplete.zsh
source ~/.zsh/zsh_aliases
source ~/.zsh/plugins.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/ssh.zsh

# Load in the nvm environment to manage node versions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If we are runnign graphically then run startx
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# Every time we cd log it to a file for fun
#chpwd()
  #echo "$(pwd)" >> "$HOME/.dirhist" && cat "$HOME/.dirhist" | tail -n 10 > "$HOME/.dirhist"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

-e 
alias luamake=/home/roland/.local/lsp/lua-language-server/3rd/luamake/luamake
