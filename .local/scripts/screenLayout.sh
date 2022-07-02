#!/bin/sh
xrandr \
--output HDMI-1 --mode 1920x1080 --pos 0x240 --rotate left \
--output HDMI-0 --primary --mode 1920x1080 --pos 1080x1080 --rotate normal \
--output DP-1 --mode 1920x1080 --pos 1080x0 --rotate inverted \
--output DVI-D-0 --mode 1920x1080 --pos 3000x240 --rotate left
