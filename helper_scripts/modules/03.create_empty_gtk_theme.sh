#!/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

##──── Create empty xfce theme ───────────────────────────────────────────────────────────
# Within xfce4/xfconf/xfce-perchanel-xml/xfwm4.xml there is a line that looks like this:
# <property name="theme" type="string" value="empty"/>
# value="empty" is reffering to the theme name in /usr/share/themes

# Check we are in an xfce session
if ps -e | grep -E '^.* xfce4-session$' > /dev/null; then
	sudo mkdir -p /usr/share/themes/empty/xfwm4/
	sudo touch /usr/share/themes/empty/xfwm4/themerc # create an empty theme file
fi