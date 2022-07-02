if [ -d "/opt/firefox" ]; then
	sudo mv /opt/firefox /opt/firefox.bak
fi

# Remove FF tmp donwload location if it exists
if [ -d "/tmp/firefox" ]
then
	echo "Removing old FF tmp directory. This wont impact your FF data"
	sudo rm -rf /tmp/firefox
fi

# Back up the existing FF install
if [ -d "/opt/firefox" ]
then
	echo "Backing up original FF install"
	sudo rm -rf /opt/firefox.bak
	sudo cp -p /opt/firefox /opt/firefox.bak
fi

# Create a temp location to store the downloaded binary
mkdir -p /tmp/firefox

# Download
wget -O /tmp/firefox/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"

# Extract firefox to /opt
sudo tar -xf /tmp/firefox/FirefoxSetup.tar.bz2 --directory /opt

# copy the desktop shortcut over for app launchers (like rofi) to read
sudo cp applications/firefox.desktop /usr/share/applications

# symlink the executable to the bin for CLI launching
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
sudo rm -rf /tmp/firefox

# set up firefox as the default URL handler
xdg-settings set default-web-browser firefox.desktop
