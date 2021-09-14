# https://wiki.archlinux.org/title/Xfce#SSH_agents
xfconf-query -c xfce4-session -p /startup/ssh-agent/type -n -t string -s ssh-agent
# start the keyring
# https://wiki.archlinux.org/title/GNOME/Keyring#--start_step
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

