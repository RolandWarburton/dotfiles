if [ -n "$DISPLAY" ]; then
	# full graphical environment
	sed 's/#.*//' ./packages.txt | xargs sudo apt install -y

	# CLI environment
	sed 's/#.*//' ./helper_scripts/packagesCLI.txt | xargs sudo apt install -y

	# Install firefox
	if [ ! -d "/opt/firefox" ]; then
		mkdir -p /tmp/firefox # create a temp location to store the downloaded binary
		wget -O /tmp/firefox/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
		sudo tar -xf /tmp/firefox/FirefoxSetup.tar.bz2 --directory /opt # extract firefox to /opt
		sudo cp applications/firefox.desktop /usr/share/applications # copy the desktop shortcut over for app launchers (like rofi) to read
		sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox # symlink the executable to the bin for CLI launching
		sudo rm -rf /tmp/firefox
	else
		echo "skipping: firefox is installed"
	fi

	# Install lsd (list files deluxe)
	if ! command -v lsd > /dev/null; then
		mkdir -p /tmp/lsd
		wget -O /tmp/lsd/lsd.deb "https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb"
		yes | sudo dpkg -i /tmp/lsd/lsd.deb
		rm -rf /tmp/lsd
	else
		echo "skipping: lsd is installed"
	fi

	# Install bat
	if ! command -v bat > /dev/null; then
		mkdir -p /tmp/bat
		wget -O /tmp/bat/bat.deb "wget https://github.com/sharkdp/bat/releases/download/v0.18.1/bat_0.18.1_amd64.deb"
		yes | sudo dpkg -i /tmp/bat/bat.deb
		rm -rf /tmp/bat
	else
		echo "skipping: bat is installed"
	fi


	# install jumpapp
	if ! command -v jumpapp > /dev/null; then
		sudo apt-get install build-essential debhelper git pandoc shunit2 -y
		mkdir /tmp/jumpapp
		cd /tmp/jumpapp
		git clone https://github.com/mkropat/jumpapp.git
		cd jumpapp
		make deb
		sudo dpkg -i jumpapp*all.deb
	else
		echo "skipping: jumpapp is installed"
	fi
fi
