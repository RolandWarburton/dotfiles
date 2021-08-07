if [ -d "/opt/firefox" ]; then
	sudo mv /opt/firefox /opt/firefox.bak
fi

mkdir -p /tmp/firefox # create a temp location to store the downloaded binary
wget -O /tmp/firefox/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
sudo tar -xf /tmp/firefox/FirefoxSetup.tar.bz2 --directory /opt # extract firefox to /opt
sudo cp applications/firefox.desktop /usr/share/applications # copy the desktop shortcut over for app launchers (like rofi) to read
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox # symlink the executable to the bin for CLI launching
sudo rm -rf /tmp/firefox
