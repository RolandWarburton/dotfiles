#!/bin/bash

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
