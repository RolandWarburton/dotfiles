#!/usr/bin/env sh

FILELIST=""

for var in "$@"; do
	FILELIST+="\n$(basename "$var")"
done

# Check the first path to see if its on the home path
if [ "$1" == *"$HOME"* ]; then
	# Its a file we can delete by promting
	if zenity --question --width 250 --text="Trash:$FILELIST?"; then
		for var in "$@"; do
			trash-put "$var"
		done
	fi
else
	if zenity --question --width 250 --text="Delete PERMANENTLY:$FILELIST?"; then
		for var in "$@"; do
			rm -rf "$var"
		done
	fi
fi
