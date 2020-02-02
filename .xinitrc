sleep 1 && exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/home/roland/.config/autostart/mouseConfig.sh &
exec dbus-launch openbox-session
