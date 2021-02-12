#!/bin/bash

# If lightdm is in use and enabled (IE. will start on next reboot, then disable it)
# I want to use ~/.xinitrc and the startx command instead
if $(systemctl is-enabled --quiet lightdm) && $(grep -q "/usr/sbin/lightdm" /etc/X11/default-display-manager); then
	sudo systemctl disable lightdm
else
	echo skipping: lightdm was not enabled
fi
