xrandr --output HDMI-0 --mode 1920x1080 --pos 1080x420 --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate left &
sleep 1 && exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/home/roland/.config/autostart/mouseConfig.sh &
exec dbus-launch openbox-session
