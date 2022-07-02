#!/bin/bash

if [ $1 = "left" ]; then
    # left monitor
    xdotool mousemove 540 1200
fi

if [ $1 = "right" ]; then
    # right monitor
    xdotool mousemove 3540 1200
fi

if [ $1 = "top" ]; then
    # top center monitor
    xdotool mousemove 2040 540
fi

if [ $1 = "bottom" ]; then
    # top bottom monitor
    xdotool mousemove 2040 1620
fi
