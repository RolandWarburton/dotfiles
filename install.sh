#!/usr/bin/zsh
############
#  README  #
############

# 1. Make sure you have set the shbang correctly
# sed -i "1s/.*/$(which zsh)/" install.sh
#
# 2. Install zplug
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

############
#  Script  #
############

# Loop through arguments and process them
for arg in "$@"; do
	case $arg in
	-h | --help)
		echo "Verify zsh shell location"
		echo 'sed -i "1s/.*/$(which zsh)/" install.sh'
		echo " Install zplug"
		echo curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
		shift # Remove argument name from processing
		;;
	*) ;;
	esac
done

# Check zsh is being used
if [[ "$SHELL" == *"zsh"* ]]; then
	echo "zsh in use"
else
	echo "zsh NOT in use"
	exit 1
fi

# check dependencies
if which git >/dev/null && which curl >/dev/null; then
	echo "dependencies check good"
else
	echo "didnt meet dependencies"
	exit 1
fi

echo "setting ZDOTDIR to $HOME"
export ZDOTDIR=$HOME

echo "(skipping) installing zplug"
# TODO this doesnt work but ill just do it manually for now
# eval "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh"
# if [ $? != 0 ]; then
# echo "failed to install zplug"
# exit 0
# fi

echo "Retrieving zsh config files"
OUTPUT_DIR=$HOME
mkdir OUTPUT_DIR 2>/dev/null
curl "https://raw.githubusercontent.com/RolandWarburton/dotfiles/master/.zshrc" >$OUTPUT_DIR.zshrc &&
	curl "https://raw.githubusercontent.com/RolandWarburton/dotfiles/master/.zsh_aliases" >$OUTPUT_DIR/.zsh_aliases &&
	curl "https://raw.githubusercontent.com/RolandWarburton/dotfiles/master/.p10k.zsh" >$OUTPUT_DIR/.p10k.zsh || echo "error downloading a zsh file"

echo "Retrieving other conf files"
mkdir OUTPUT_DIR 2>/dev/null
echo "Downloading vimrc" && curl "https://raw.githubusercontent.com/RolandWarburton/dotfiles/master/.vimrc" >$OUTPUT_DIR/.vimrc &&
	echo "Downloading tmux conf" && curl "https://raw.githubusercontent.com/RolandWarburton/dotfiles/master/.tmux.conf" >$OUTPUT_DIR/.tmux.conf || echo "error downloading"
