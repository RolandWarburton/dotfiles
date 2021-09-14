#!/bin/bash

. /etc/X11/Xsession &

echo "starting log $script" > /home/roland/log

# Run all system xinitrc shell scripts.
xinitdir="/etc/X11/Xsession.d"
if [ -d "$xinitdir" ]; then
    for script in $xinitdir/*; do
        echo "Loading xinit script $script" >> /home/roland/log
        if [ -x "$script" -a ! -d "$script" ]; then
            . "$script"
        fi
    done
fi

#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK
#export GPG_AGENT_INFO
#export GNOME_KEYRING_CONTROL
#export GNOME_KEYRING_PID

#systemctl --user import-environment DISPLAY XAUTHORITY

#DISPLAY=":0.0"
#HOME="/home/roland"
#XAUTHORITY="$HOME/.Xauthority"
#export DISPLAY XAUTHORITY HOME

xbindkeys &
screenLayout.sh &
mosueConfig.sh &
dunst &

# xfwm4 --daemon &
#exec xfce4-session
#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session startxfce4
# exec dbus-launch --sh-syntax --exit-with-session startxfce4
# exec dbus-launch --sh-syntax --exit-with-session gnome-shell
# exec dbus-launch --exit-with-session gnome-shell

xfwm4 --daemon &
exec dbus-launch --exit-with-session xfce4-session

#exec dbus-launch --exit-with-session startxfce4
