#!/bin/bash

# !!! ALERT !!!
# This status bar script is now no longer in use.
# The golang version replaced this zsh script (statusBar.go and the statusBar binary).
# If you would like to use this zsh one please edit .config/sway/config and look for `status_command`

# if a battery exists, then it will print the battery in the config bar
# else it will just print the time

if [ -d "/sys/class/power_supply/BAT0" ]; then
  while true; do
    echo "B $(cat /sys/class/power_supply/BAT0/capacity)% |" $(date +'%Y-%m-%d %I:%M:%S %p')
    sleep 1
  done
else
  while true; do
    echo "$(date +'%Y-%m-%d %I:%M:%S %p')"
    sleep 1
  done
fi
