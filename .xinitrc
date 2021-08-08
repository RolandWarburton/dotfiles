# Manually set up dual screens. xorg.conf.d currently handles this
# xrandr --output HDMI-0 --mode 1920x1080 --pos 1080x420 --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate left &

# Start the background. Not needed for XFCE4
# exec feh --bg-fill /home/roland/Media/Backgrounds/Catlesstail_portrait.png /home/roland/Media/Backgrounds/Catlesstail.png &

# Run this stuff
/home/roland/.config/autostart/mouseConfig.sh &
/home/roland/.config/autostart/trackBall.sh &
xrdb -merge ~/.Xresources &
xbindkeys -f ~/.xbindkeysrc &
unclutter &
clipit -d &
flameshot &
dunst &
exec startxfce4
