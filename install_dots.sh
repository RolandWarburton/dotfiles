#!/usr/bin/env bash

# Exit on any error returned by any command
# Disabled because dialog needs to capture returned 1 codes
#set -e

chmod 755 ./helper_scripts/modules/*

# sudo ./helper_scripts/modules/01.locale_conf.sh

sed 's/#.*//' ./helper_scripts/packages.txt | xargs sudo apt install -y

# ===================================================================
# prompt for installing CLI packages
dialog --title  "Install CLI packages" --nocancel --no-kill \
--yesno "Install CLI packages now?" 7 50

# Get exit status
RESPONSE=$?
case $RESPONSE in
   0) sed 's/#.*//' ./helper_scripts/packagesCLI.txt | xargs sudo apt install -y;;
   1) echo "Skipping CLI.";;
   255) echo "Skipping CLI.";;
   *) echo "Skipping CLI.";;
esac

# ===================================================================
# prompt for installing GUI packages
dialog --title  "Install GUI packages" --nocancel --no-kill \
--yesno "Install GUI packages now?" 7 50

# Get exit status
RESPONSE=$?
case $RESPONSE in
   0) sed 's/#.*//' ./helper_scripts/packagesGUI.txt | xargs sudo apt install -y;;
   1) echo "Skipping GUI.";;
   255) echo "Skipping GUI.";;
   *) echo "Skipping GUI.";;
esac

# ===================================================================
# prompt for installing software
selections=$(dialog --checklist "Choose the options you want:" 0 0 2 "1" "firefox" "on" "2" "example" "on" 3>&1 1>&2 2>&3 3>&- )

for sel in $selections; do
    case $sel in
       1) ./helper_scripts/software/firefox.sh;;
       2) echo "placeholder";;
    esac
done

# Then run dotbot
dotbot -c install.conf.yaml

# do some last config stuff
./helper_scripts/modules/02.install_zplug.zsh
./helper_scripts/modules/03.create_empty_gtk_theme.sh

