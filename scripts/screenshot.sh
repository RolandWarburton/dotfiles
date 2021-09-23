#!/bin/bash

# check dunst is installed and in the $PATH
if ! [ -x "$(command -v dunst)" ]; then
    echo "dunst is not installed"
    return 1
fi

# ensure dunst is running
if ! pgrep -x "dunst"; then
    echo "starting dunst"
    dunst &
fi

# Ensure flameshot is running in background as daemon
# If it isnt then it crashes as well
if ! pgrep -x "flameshot"; then
    echo "starting flameshot daemon"
    flameshot & 
fi

flameshot gui

