#!/usr/bin/env zsh

# Exit on any error returned by any command
set -e

##──── change shell to zsh ───────────────────────────────────────────────────────────────
if which zsh &> /dev/null; then
	# Check curl is installed
	if ! command -v curl &> /dev/null
	then
		echo "CURL NEEDS TO BE INSTALLED TO INSTALL ZPLUG"
		sudo apt install curl
	fi


	# Download and install zplug if its not installed
	if [ ! -d "$HOME/.zplug" ]; then
		/usr/bin/curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	fi

	# Set the shell
	echo "Enter password to change shell to zsh:"
	sudo usermod --shell $(which zsh) $USER
fi
