# Manually set up dual screens. xorg.conf.d currently handles this
# xrandr --output HDMI-0 --mode 1920x1080 --pos 1080x420 --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate left &

# Start the background. Not needed for XFCE4
# exec feh --bg-fill /home/roland/Media/Backgrounds/Catlesstail_portrait.png /home/roland/Media/Backgrounds/Catlesstail.png &

# For liquidctl ensure that you have copied over the udev rules for a non root user to have permission running the command

# Run this stuff
#export DESKTOP_SESSION=plasma &
#dbus-launch gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg &
#export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK &
#dbus-update-activation-environment --systemd DISPLAY &
#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
liquidctl initialize all &
liquidctl --match h150 set fan speed 20 50 30 80 40 100 &
/home/roland/.config/autostart/mouseConfig.sh &
/home/roland/.config/autostart/trackBall.sh &
xrdb -merge ~/.Xresources &
xbindkeys -f ~/.xbindkeysrc &
unclutter &
clipit -d &
flameshot &
#dunst &
#exec dbus-launch --exit-with-session startxfce4
exec startxfce4
