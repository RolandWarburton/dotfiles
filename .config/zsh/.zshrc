#
#  _____                       _
# | ____|_  ___ __   ___  _ __| |_ ___
# |  _| \ \/ / '_ \ / _ \| '__| __/ __|
# | |___ >  <| |_) | (_) | |  | |_\__ \
# |_____/_/\_\ .__/ \___/|_|   \__|___/
#           |_|
#

# Locale
export LC_ALL=C
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Language
export LANG=en_US.UTF-8

# Where user-specific configurations should be written (analogous to /etc)
export XDG_DATA_HOME="$HOME/.local"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# move the .nv folder for OpenGL cache to better location. may not need due to above XDG_BASE dir fix
export __GL_SHADER_DISK_CACHE_PATH="${ZDOTDIR:-$HOME}/.cache"

# Theme GTK to Q
# export QT_QPA_PLATFORMTHEME="qt5ct"

# Pylint for python
export PYLINTHOME="${ZDOTDIR:-$HOME}/.local"

#
# __  __
# \ \/ /___  _ __ __ _
#  \  // _ \| '__/ _` |
#  /  \ (_) | | | (_| |
# /_/\_\___/|_|  \__, |
#                |___/
#

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

HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"    # The path to the history file.
HISTSIZE=100000                           # The maximum number of events to save in the internal history.
SAVEHIST=100000                           # The maximum number of events to save in the history file.

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

# stop r from redoing the last command
disable r

# Change directory without cd
setopt AUTO_CD

# Interactive comments (like bash)
setopt INTERACTIVE_COMMENTS

# Correct commands
setopt CORRECT

# Make forward-word, backward-word etc. stop at path delimiter
export WORDCHARS=${WORDCHARS/\/}

# Print message if reboot is required
[[ -o interactive && -f "/var/run/reboot-required" ]] && print "reboot required"

# Local configuration
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#
#     _         _                                  _      _
#    / \  _   _| |_ ___   ___ ___  _ __ ___  _ __ | | ___| |_ ___
#   / _ \| | | | __/ _ \ / __/ _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \
#  / ___ \ |_| | || (_) | (_| (_) | | | | | | |_) | |  __/ ||  __/
# /_/   \_\__,_|\__\___/ \___\___/|_| |_| |_| .__/|_|\___|\__\___|
#                                           |_|
# Mostly the defaults here

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

#  _  __          _     _           _
# | |/ /___ _   _| |__ (_)_ __   __| |___
# | ' // _ \ | | | '_ \| | '_ \ / _` / __|
# | . \  __/ |_| | |_) | | | | | (_| \__ \
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
#           |___/
#

# Fix ctrl+left and ctrl+right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Fix the del key
bindkey "\e[3~" delete-char

# Fix home and end key
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

# Push command A into buffer to type command B then get A back
bindkey "^q" push-line-or-edit

# selection
# shift-arrow() {
#   ((REGION_ACTIVE)) || zle set-mark-command
#   zle $1
#   echo "hello"
# }
# shift-left() shift-arrow backward-char
# shift-right() shift-arrow forward-char
# zle -N shift-left
# zle -N shift-right

# bindkey $terminfo[kLFT] shift-left
# bindkey $terminfo[kRIT] shift-right


#  _____      _                        _   _____    _ _ _
# | ____|_  _| |_ ___ _ __ _ __   __ _| | | ____|__| (_) |_ ___  _ __
# |  _| \ \/ / __/ _ \ '__| '_ \ / _` | | |  _| / _` | | __/ _ \| '__|
# | |___ >  <| ||  __/ |  | | | | (_| | | | |__| (_| | | || (_) | |
# |_____/_/\_\\__\___|_|  |_| |_|\__,_|_| |_____\__,_|_|\__\___/|_|
#
# Allow command line editing in an external editor.

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

#  ____                            _   
# |  _ \ _ __ ___  _ __ ___  _ __ | |_ 
# | |_) | '__/ _ \| '_ ` _ \| '_ \| __|
# |  __/| | | (_) | | | | | | |_) | |_ 
# |_|   |_|  \___/|_| |_| |_| .__/ \__|
#                           |_|        
# Custom prompt. May be overwritten if im using powerline10k

# Enable the prompt string (specifically allow ${} in the prompt)
setopt prompt_subst

# vcs_info is a function that populates a variable for you. 
# This variable can then be used inside your prompt to print information.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
	vcs_info
}

# * Style git information string
# * formats = git when its not doing anything
# * actionformats = when git is doing something (eg a merge or rebase)
# %s The current version control system, like git or svn
# %r The name of the root directory of the repository
# %SThe current path relative to the repository root directory
# %b Branch information, like master
# %m In case of Git, show information about stashes
# %u Show unstaged changes in the repository
# %c Show staged changes in the repository 
zstyle ':vcs_info:git*' formats "%b"

# * Actual prompt is defined here
# %n $USERNAME
# %M Full hostname
# %m Partial hostname
# %# Privilege mode
# %2d Last 2 directories
PROMPT='%n@%M %1d ${vcs_info_msg_0_}%# '
# PROMPT="${SSH_TTY:+$ssh_prefix}"'%{$fg_bold[blue]%}%~${vcs_info_msg_0_}%{$reset_color%}$_prompt_symbol '
# PROMPT="${SSH_TTY:+$ssh_prefix}"'%B%F{255}%n@%m%f %F{blue}%2~${vcs_info_msg_0_}%f%b$_prompt_symbol '

#
#  ____ ____  _   _ 
# / ___/ ___|| | | |
# \___ \___ \| |_| |
#  ___) |__) |  _  |
# |____/____/|_| |_|
#                 


# Start ssh-agent if not started.
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    # Set the path to the environment file if not set by another module.
    _ssh_agent_env="${_ssh_agent_env:-${TMPDIR:-/tmp}/ssh-agent.env.$UID}"

    # Export environment variables.
    source "$_ssh_agent_env" 2> /dev/null

    # Start ssh-agent if not started.
    if ! ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "${SSH_AGENT_PID:--1} ssh-agent"; then
        eval "$(ssh-agent | sed '/^echo /d' | tee "$_ssh_agent_env")"
    fi

    unset _ssh_agent_env
fi

# Start the ssh-agent (above is zsh stock and doesnt work)
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
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

# Sets the tab and window titles with a given command.
function _terminal-set-titles-with-command {
    emulate -L zsh
    setopt EXTENDED_GLOB

    # Get the command name that is under job control.
    if [[ "${2[(w)1]}" == (fg|%*)(\;|) ]]; then
        # Get the job name, and, if missing, set it to the default %+.
        local job_name="${${2[(wr)%*(\;|)]}:-%+}"

        # Make a local copy for use in the subshell.
        local -A jobtexts_from_parent_shell
        jobtexts_from_parent_shell=(${(kv)jobtexts})

        jobs "$job_name" 2> /dev/null > >(
            read index discarded
            # The index is already surrounded by brackets: [1].
            _terminal-set-titles-with-command "${(e):-\$jobtexts_from_parent_shell$index}"
        )
    else
        # Set the command name, or in the case of sudo or ssh, the next command.
        local cmd="${${2[(wr)^(*=*|sudo|ssh|-*)]}:t}"
        local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
        unset MATCH

        if [[ "$TERM" == screen* ]]; then
            set-multiplexer-title "$truncated_cmd"
        fi
        set-tab-title "$truncated_cmd"
        set-window-title "$cmd"
    fi
}

# Sets the tab and window titles with a given path.
function _terminal-set-titles-with-path {
    emulate -L zsh
    setopt EXTENDED_GLOB

    local absolute_path="${${1:a}:-$PWD}"
    local abbreviated_path="${absolute_path/#$HOME/~}"
    local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[-12,-1]}}"
    local base_path="${abbreviated_path##*/}/"
    unset MATCH

    if [[ "$TERM" == screen* ]]; then
        set-multiplexer-title "$base_path"
    fi
    set-tab-title "$truncated_path"
    set-window-title "$abbreviated_path"
}

# Only set titles for regular terminals
case "$TERM" in
    dumb|eterm*)
        # Ignore these terminals
        ;;
    *)
        autoload -Uz add-zsh-hook

        # Sets titles before the prompt is displayed.
        add-zsh-hook precmd _terminal-set-titles-with-path

        # Sets titles before command execution.
        add-zsh-hook preexec _terminal-set-titles-with-command
        ;;
esac


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


#     _    _ _                     
#    / \  | (_) __ _ ___  ___  ___ 
#   / _ \ | | |/ _` / __|/ _ \/ __|
#  / ___ \| | | (_| \__ \  __/\__ \
# /_/   \_\_|_|\__,_|___/\___||___/
#                                 

# Load Aliases from config file
[[ -s "$ZDOTDIR/.zsh_aliases" ]] && source "${ZDOTDIR}/.zsh_aliases"
[[ -s "$ZDOTDIR/.zsh_aliases.local" ]] && source "${ZDOTDIR}/.zsh_aliases.local"

#  _____      _                 _                 
# | ____|_  _| |_ ___ _ __  ___(_) ___  _ __  ___ 
# |  _| \ \/ / __/ _ \ '_ \/ __| |/ _ \| '_ \/ __|
# | |___ >  <| ||  __/ | | \__ \ | (_) | | | \__ \
# |_____/_/\_\\__\___|_| |_|___/_|\___/|_| |_|___/
#
# ZSH brand extensions

function fpath-prepend {
    [[ -d "$1" ]] && fpath=($1 $fpath)
}

# Load ZSH function path modules
fpath-prepend "/usr/local/share/zsh-completions"
fpath-prepend "$HOME/.local/share/zsh-completions/src"
fpath-prepend "$HOME/.config/zsh/userFunctions" # Load my own functions

# * Autoload userFunctions
autoload clip

# * ZSH default extensions
function load-extension {
    for extension in "$@"; do
        if [[ -s "$extension" ]]; then
            source "$extension"
            return 0
        fi
    done
    return 1
}

function load-syntax-highlighting {
    load-extension "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
                   "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" || return
    # Set highlight colors
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=white'
}

function load-history-substring-search {
    load-extension "/usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh" \
                   "$HOME/.local/share/zsh-history-substring-search/zsh-history-substring-search.zsh" || return
    # Bind C-P/C-N in Emacs mode
    bindkey -M emacs "\C-P" history-substring-search-up
    bindkey -M emacs "\C-N" history-substring-search-down
    # Bind arrow keys in all modes
    case "$TERM" in
        screen*)
            bindkey "^[OA" history-substring-search-up
            bindkey "^[OB" history-substring-search-down
            ;;
        xterm*)
            bindkey "^[[A" history-substring-search-up
            bindkey "^[[B" history-substring-search-down
            ;;
    esac
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=magenta"
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red"
    # Case-sensitive search
    HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS="${HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS//i}"
}

# zsh-syntax-highlighting should be initialized as late as possible because it
# wraps ZLE widgets.
load-syntax-highlighting

# When using both zsh-history-substring-search and zsh-syntax-highlighting, the
# former should be initialized last.
load-history-substring-search

# Ensure fpath does not contain duplicates
typeset -gU fpath

# Clean up functions
unfunction load-extension \
           load-syntax-highlighting \
           load-history-substring-search \
           fpath-prepend \

#  ____  _             _           
# |  _ \| |_   _  __ _(_)_ __  ___ 
# | |_) | | | | |/ _` | | '_ \/ __|
# |  __/| | |_| | (_| | | | | \__ \
# |_|   |_|\__,_|\__, |_|_| |_|___/
#                |___/          
#    
# Extensions that dont come with ZSH

# * ===== suggestion highlighting ============================================
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^@' autosuggest-accept # control space
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#fafafa,bg=#586e75,bold"

# * ===== Powerline10k =======================================================
source ${ZDOTDIR}/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# * ===== NVM ================================================================
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
