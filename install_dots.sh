##──── Install packages ──────────────────────────────────────────────────────────────────
if [ -n "$DISPLAY" ]; then
	# full graphical environment
	sed 's/#.*//' ./helper_scripts/packages.txt | xargs sudo apt install -y

	# Install firefox
	if [ ! -d "/opt/firefox" ]; then
		mkdir -p /tmp/firefox # create a temp location to store the downloaded binary
		wget -O /tmp/firefox/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
		sudo tar -xf /tmp/firefox/FirefoxSetup.tar.bz2 --directory /opt # extract firefox to /opt
		sudo cp applications/firefox.desktop /usr/share/applications # copy the desktop shortcut over for app launchers (like rofi) to read
		sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox # symlink the executable to the bin for CLI launching
	fi
else
	# CLI environment
	sed 's/#.*//' ./helper_scripts/packagesCLI.txt | xargs sudo apt install -y
fi

##──── Create empty xfce theme ───────────────────────────────────────────────────────────
# Within xfce4/xfconf/xfce-perchanel-xml/xfwm4.xml there is a line that looks like this:
# <property name="theme" type="string" value="empty"/>
# value="empty" is reffering to the theme name in /usr/share/themes

# Check we are in an xfce session
if ps -e | grep -E '^.* xfce4-session$' > /dev/null; then
	sudo mkdir -p /usr/share/themes/empty/xfwm4/
	sudo touch /usr/share/themes/empty/xfwm4/themerc # create an empty theme file
fi

##──── change shell to zsh ───────────────────────────────────────────────────────────────
if which zsh; then
	# Download and install zplug if its not installed
	if [ ! -d "$HOME/.zplug" ]; then
		/usr/bin/curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	fi

	# Set the shell
	sudo usermod --shell $(which zsh) $USER
fi

# Then run dotbot
dotbot -c install.conf.yaml

