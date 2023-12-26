alias testalias="echo alias loaded"
alias printfonts="fc-list | cut -d: -f2 | sort | uniq"
alias ll="ls -l"
alias p="sudo pacman"
alias grep="grep --color"
alias ls="ls -h --color" # (-h human readable): print things like 1mb, 2gb, 1tb...
alias gut="git" # muh smol hands
alias ss="sudo systemctl"
alias r="ranger"
alias s="sudo"
alias ssh="TERM=xterm-256color ssh"
alias c="xclip -selection clipboard"
alias df="df -h"
alias swinvpn="sudo openconnect vpn.swin.edu.au --user=102106751 --passwd-on-stdin < /home/roland/passwords/swinburne.txt"
alias pwdc="pwd | c"
alias nopass="cat ~/.ssh/id_nopass_rsa.pub"
alias mkhttp="python -m http.server"
alias pubip="curl ifconfig.me"
alias activate="source bin/activate"
alias d=docker
alias pspretty="docker ps --format '{{.ID}}\t\t{{.Names}}\t\t{{.Status}}\t\t{{.Networks}}'"
alias dockerclean="docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm"
alias passs="PASSWORD_STORE_ENABLE_EXTENSIONS=true pass fzf" # https://github.com/ficoos/pass-fzf
alias killport="fuser -k"
alias pwdc="pwd | c"
alias tmuxssh='f() {ssh $1 -t /usr/bin/tmux a -t $2};f' # tmuxssh 192.168.0.10  sessionName
alias ctop="docker run --rm -ti --name=ctop --volume /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop:latest"
alias volls='f() {docker run --rm -i -v=$1:/tmp/$1 busybox ls -l -R /tmp/$1};f' # volls testvol
alias fcd='f() {cd $(find . -maxdepth 1 -type d | fzf)};f'
alias pkill="pkill -i" # ignore case
alias dockerbuild='docker-compose build'
alias viviInspect='cat $(cat ~/.vivi_tools.json | jq -r ".tmp.inspectFile") | fx'
alias vim='nvim'
alias prunebranches='git remote prune origin'
alias hibernate='systemctl hibernate'
alias dbusps='ps -o pid,ppid,command -C dbus-daemon'
alias imv='imv-wayland'
alias wcall='count_lines'
alias weather=curl "wttr.in/melbourne"
alias weather='curl "wttr.in/melbourne"'

# If LSD is installed then use those
if which lsd >/dev/null
then
	alias ls=lsd
else
	ls="ls --color"
fi

# If bat is installed then use those
if which bat >/dev/null
then
	alias cat=bat
fi


# System clipboard commands
if which xclip >/dev/null
then
	alias c="xclip -selection clipboard"
	alias pwdc="pwd | c"
fi

# Quickfire editor commands
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc"

alias mv='nocorrect mv -i'      # prompt before overwriting files

# Make new alias ez
alias a=alias
alias ua=unalias

# Awk bois
alias -g A1="| awk '{print \$1}'"
alias -g A2="| awk '{print \$2}'"
alias -g A3="| awk '{print \$3}'"
alias -g A4="| awk '{print \$4}'"
alias -g A5="| awk '{print \$5}'"

# Directory hashes
hash -d log=/var/log
hash -d www=/var/www
hash -d nginx=/etc/nginx
hash -d nginx=/etc/nginx
hash -d downloads=$HOME/Downloads
hash -d systemd=/etc/systemd/system
hash -d swinburne=$HOME/Documents/Swinburne
hash -d projects=$HOME/Documents/Projects
hash -d knowledge=$HOME/Documents/knowledge

