#!/usr/bin/env bash

# see:
# https://unix.stackexchange.com/questions/281736/changing-input-audio-source-and-setting-it-to-mono-on-debian-jessie-8-using-comm

# A "sink" is a playpack device (output)
# A "source" is a recording device (input)

# Set the default recording source to my stereo USB interface
pacmd set-default-source alsa_input.usb-Yamaha_Corporation_Steinberg_UR22C-00.analog-stereo

# Then remap it to a sink for playing back in mono
pacmd load-module module-remap-sink sink_name=mono master=alsa_input.usb-Yamaha_Corporation_Steinberg_UR22C-00.analog-stereo channels=2 channel_map=mono,mono

