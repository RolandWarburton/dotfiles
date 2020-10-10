#!/usr/bin/sh

FILELIST=""

for var in "$@"; do
	FILELIST+="\n$(basename "$var")"
done

if zenity --question --width 250 --text="Delete:$FILELIST?"; then
	for var in "$@"; do
		trash-put "$var"
	done
fi
