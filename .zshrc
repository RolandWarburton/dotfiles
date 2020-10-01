#  ____  _____    _    ____  __  __ _____ 
# |  _ \| ____|  / \  |  _ \|  \/  | ____|
# | |_) |  _|   / _ \ | | | | |\/| |  _|  
# |  _ <| |___ / ___ \| |_| | |  | | |___ 
# |_| \_\_____/_/   \_\____/|_|  |_|_____|
# 
# README

# ? Install zplug to get all the plugins working
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# ? Copy the ~/.p10k.zsh file in for powerline10k
# curl ...

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export LC_ALL=C
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=$HOME/bin:$PATH

#  _  __          _     _           _
# | |/ /___ _   _| |__ (_)_ __   __| |___
# | ' // _ \ | | | '_ \| | '_ \ / _` / __|
# | . \  __/ |_| | |_) | | | | | (_| \__ \
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
#           |___/
# Keybinds

bindkey "$terminfo[kcuu1]" up-line-or-history # Up
bindkey "$terminfo[kcud1]" down-line-or-history # Down

if [[ "$TERM" != emacs ]]; then
    [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
fi

# Fix ctrl+left and ctrl+right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Fix the del key
bindkey "\e[3~" delete-char

# selection
shift-arrow() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle $1
}
for key  kcap seq        widget (
    left  LFT $'\e[1;2D' backward-char
    right RIT $'\e[1;2C' forward-char
    up    ri  $'\e[1;2A' up-line-or-history
    down  ind $'\e[1;2B' down-line-or-history
  ) {
  functions[shift-$key]="shift-arrow $widget"
  zle -N shift-$key
  bindkey ${terminfo[k$kcap]-$seq} shift-$key
}
#
#  _____                       _
# | ____|_  ___ __   ___  _ __| |_ ___
# |  _| \ \/ / '_ \ / _ \| '__| __/ __|
# | |___ >  <| |_) | (_) | |  | |_\__ \
# |_____/_/\_\ .__/ \___/|_|   \__|___/
#           |_|
#
# Exports

# Where user-specific configurations should be written (analogous to /etc)
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# Pylint for python
export PYLINTHOME="${ZDOTDIR:-$HOME}/.local"

# export the editor
export EDITOR=$(which vim)

#
# __  __
# \ \/ /___  _ __ __ _
#  \  // _ \| '__/ _` |
#  /  \ (_) | | | (_| |
# /_/\_\___/|_|  \__, |
#                |___/
#
# Xorg

# Start Xorg
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx # startx wraps xinit, use startx in 99% of cases
fi

#
#  _________  _   _   ____       _   _   _
# |__  / ___|| | | | / ___|  ___| |_| |_(_)_ __   __ _ ___
#   / /\___ \| |_| | \___ \ / _ \ __| __| | '_ \ / _` / __|
#  / /_ ___) |  _  |  ___) |  __/ |_| |_| | | | | (_| \__ \
# /____|____/|_| |_| |____/ \___|\__|\__|_|_| |_|\__, |___/
#                                                |___/
#

HISTFILE="${ZDOTDIR:-$HOME}/.zhistory" # The path to the history file.
HISTSIZE=100000                        # The maximum number of events to save in the internal history.
SAVEHIST=100000                        # The maximum number of events to save in the history file.

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.

# stop r from redoing the last command
disable r

# Change directory without cd
setopt AUTO_CD

# Interactive comments (like bash)
# setopt INTERACTIVE_COMMENTS

# Correct commands
setopt CORRECT

# Make forward-word, backward-word etc. stop at path delimiter
export WORDCHARS=${WORDCHARS/\//}

# Print message if reboot is required
[[ -o interactive && -f "/var/run/reboot-required" ]] && print "reboot required"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#  ____  _             _
# |  _ \| |_   _  __ _(_)_ __  ___
# | |_) | | | | |/ _` | | '_ \/ __|
# |  __/| | |_| | (_| | | | | \__ \
# |_|   |_|\__,_|\__, |_|_| |_|___/
#                |___/
#
# Extensions that dont come with ZSH

#########################
#      Zplug init       #
#########################
source ~/.zplug/init.zsh

#########################
#     Zplug plugins     #
#########################
autoload colors && colors
setopt prompt_subst

# manage zplug by zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# make command completion stronger
zplug "zsh-users/zsh-completions"
# make command auto suggestion based on history
zplug "zsh-users/zsh-autosuggestions"
# command line syntax highlight
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# interative git commands
zplug "wfxr/forgit", use:forgit.plugin.zsh
# useful change directory
zplug "b4b4r07/enhancd", use:init.sh
# powerline10k
zplug romkatv/powerlevel10k, as:theme, depth:1

# install check and then load
zplug check || zplug install
zplug load

#########################
#     Autocomplete      #
#########################
bindkey '^@' autosuggest-accept # control space
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#fafafa,bg=#586e75,bold"

#########################
#      Powerline        #
#########################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#     _    _ _
#    / \  | (_) __ _ ___  ___  ___
#   / _ \ | | |/ _` / __|/ _ \/ __|
#  / ___ \| | | (_| \__ \  __/\__ \
# /_/   \_\_|_|\__,_|___/\___||___/
#

# Load Aliases from config file
[[ -s "$ZDOTDIR/.zsh_aliases" ]] && source "${ZDOTDIR}/.zsh_aliases"
[[ -s "$ZDOTDIR/.zsh_aliases.local" ]] && source "${ZDOTDIR}/.zsh_aliases.local"

# #
# #     _         _                                  _      _
# #    / \  _   _| |_ ___   ___ ___  _ __ ___  _ __ | | ___| |_ ___
# #   / _ \| | | | __/ _ \ / __/ _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \
# #  / ___ \ |_| | || (_) | (_| (_) | | | | | | |_) | |  __/ ||  __/
# # /_/   \_\__,_|\__\___/ \___\___/|_| |_| |_| .__/|_|\___|\__\___|
# #                                           |_|
# # Mostly the defaults here

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
unsetopt AUTO_REMOVE_SLASH # Never remove trailing slash when completing.

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -C
else
  compinit
fi
unset _comp_files

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-sensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion when you are connecting to ssh
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

#
#  ____ ____  _   _
# / ___/ ___|| | | |
# \___ \___ \| |_| |
#  ___) |__) |  _  |
# |____/____/|_| |_|
#

# Add my nopass ssh key to the agent
# idk if this even works but whatever
if [ -n "$SSH_AUTH_SOCK" ] ; then
	# eval `ssh-agent -s`
	eval `ssh-add -q $HOME/.ssh/id_nopass_rsa`>/dev/null
fi

#
# __        ___           _
# \ \      / (_)_ __   __| | _____      __
#  \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / /
#   \ V  V / | | | | | (_| | (_) \ V  V /
#    \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/
#
# Terminal window. Mostly defaults

# Sets the terminal window title.
function set-window-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\e]2;%s\a' "${(V%)title_formatted}"
}

# Sets the terminal tab title.
function set-tab-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\e]1;%s\a' "${(V%)title_formatted}"
}

# Sets the terminal multiplexer tab title.
function set-multiplexer-title {
    local title_format{,ted}
    title_format="%s"
    zformat -f title_formatted "$title_format" "s:$argv"
    printf '\ek%s\e\\' "${(V%)title_formatted}"
}

#  _____
# | ____|_ __ ___   __ _  ___ ___
# |  _| | '_ ` _ \ / _` |/ __/ __|
# | |___| | | | | | (_| | (__\__ \
# |_____|_| |_| |_|\__,_|\___|___/
#
# I dont use Emacs but its part of the default config so..

# Tell Emacs about the current directory
if [[ -n "$INSIDE_EMACS" ]]; then
    function chpwd {
        print -P "\033AnSiTc %d"
    }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi


#  _   ___     ____  __ 
# | \ | \ \   / /  \/  |
# |  \| |\ \ / /| |\/| |
# | |\  | \ V / | |  | |
# |_| \_|  \_/  |_|  |_|
# 
# NVM - Node Version Manager

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"


# #  _____      _                        _   _____    _ _ _
# # | ____|_  _| |_ ___ _ __ _ __   __ _| | | ____|__| (_) |_ ___  _ __
# # |  _| \ \/ / __/ _ \ '__| '_ \ / _` | | |  _| / _` | | __/ _ \| '__|
# # | |___ >  <| ||  __/ |  | | | | (_| | | | |__| (_| | | || (_) | |
# # |_____/_/\_\\__\___|_|  |_| |_|\__,_|_| |_____\__,_|_|\__\___/|_|
# #
# # Allow command line editing in an external editor.

# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey "^E" edit-command-line

# #  ____                            _
# # |  _ \ _ __ ___  _ __ ___  _ __ | |_
# # | |_) | '__/ _ \| '_ ` _ \| '_ \| __|
# # |  __/| | | (_) | | | | | | |_) | |_
# # |_|   |_|  \___/|_| |_| |_| .__/ \__|
# #                           |_|
# # Custom prompt. May be overwritten if im using powerline10k

# # Enable the prompt string (specifically allow ${} in the prompt)
# setopt prompt_subst

# # vcs_info is a function that populates a variable for you.
# # This variable can then be used inside your prompt to print information.
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git svn
# precmd() {
# 	vcs_info
# }

# # * Style git information string
# # * formats = git when its not doing anything
# # * actionformats = when git is doing something (eg a merge or rebase)
# # %s The current version control system, like git or svn
# # %r The name of the root directory of the repository
# # %SThe current path relative to the repository root directory
# # %b Branch information, like master
# # %m In case of Git, show information about stashes
# # %u Show unstaged changes in the repository
# # %c Show staged changes in the repository
# zstyle ':vcs_info:git*' formats "%b"

# # * Actual prompt is defined here
# # %n $USERNAME
# # %M Full hostname
# # %m Partial hostname
# # %# Privilege mode
# # %2d Last 2 directories
# #PROMPT='%n@%M %1d ${vcs_info_msg_0_}%# '
# # PROMPT="${SSH_TTY:+$ssh_prefix}"'%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}$_prompt_symbol '
# # PROMPT="${SSH_TTY:+$ssh_prefix}"'%B%F{255}%n@%m%f %F{blue}%2~${vcs_info_msg_0_}%f%b$_prompt_symbol '


#  __  __ ___ ____   ____ 
# |  \/  |_ _/ ___| / ___|
# | |\/| || |\___ \| |    
# | |  | || | ___) | |___ 
# |_|  |_|___|____/ \____|
# 
# MISC

# Check if $LANG is badly set as it causes issues
if [[ $LANG == "C"  || $LANG == "" ]]; then
	>&2 echo "$fg[red]The \$LANG variable is not set. This can cause a lot of problems.$reset_color"
fi