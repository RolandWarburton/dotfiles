#!/usr/bin/env bash

# Exit on any error returned by any command
set -e

# set the locale, make sure you are root for this as it doesn't seem to work with sudo.
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8