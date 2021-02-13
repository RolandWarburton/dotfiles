##──── Install packages ──────────────────────────────────────────────────────────────────
if [ -n "$DISPLAY" ]; then
	# full graphical environment
	sed 's/#.*//' ./helper_scripts/packages.txt | xargs sudo apt install -y
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

##──── configure locales ─────────────────────────────────────────────────────────────────
# ignore this for now
# sudo sed -n "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
# sudo locale-gen

##──── change shell to zsh ───────────────────────────────────────────────────────────────
if which zsh; then
	# Download and install zplug
	/usr/bin/curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

	# Set the shell
	sudo usermod --shell $(which zsh) $USER
fi

dotbot -c install.conf.yaml