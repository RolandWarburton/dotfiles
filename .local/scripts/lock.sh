#!/usr/bin/env bash

# https://www.andreafortuna.org/2020/04/09/i3-how-to-make-a-pretty-lock-screen-with-a-four-lines-of-bash-script/

# create a temp file
img=$(mktemp /tmp/XXXXXXXX.png)

# Take a screenshot of current desktop
import -window root $img

# Pixelate the screenshot
convert $img -blur 0x2.5 $img

# Run i3lock with custom background
i3lock -i $img

# Remove the tmp file
rm $img
