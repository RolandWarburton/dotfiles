#!/bin/sh

# Taken while docked on laptop station
xrandr \
--output LVDS-1 --primary --mode 1366x768 --pos 0x1152 --rotate normal \
--output HDMI-2 --mode 1920x1080 --pos 1366x0 --rotate left \
--output DP-2 --off \
--output DP-3 --off \
--output HDMI-3 --off \
--output VGA-1 --off \
--output HDMI-1 --off \
--output DP-1 --off

