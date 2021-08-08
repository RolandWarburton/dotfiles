#!/bin/bash
# Move the window to the left or right of the monitor

VERSION=2.0

usage() {
	printf "%s\t\t%s\n" "-d, --direction" "USAGE: swapMonitor --direction left"
	printf "%s\t\t%s\n" "-h, --help" "Show help"
	exit 0
}

if [ "$1" != "-d" ] && [ "$1" != "--direction" ]; then
	usage
else
	direction=$2
fi

declare -a TRIGGERPOINTS
TRIGGERPOINTS=(0 1080 3000 4080)

declare -i monitor
declare -i numberOfMonitors=${#TRIGGERPOINTS[@]}/2

# get the window id
WINDOWID=$(xdotool getwindowfocus)
# get the state. eg. _NET_WM_STATE_MAXIMIZED_HORZ, _NET_WM_STATE_MAXIMIZED_VERT, _NET_WM_STATE_FOCUSED
# the window needs to be in _NET_WM_STATE_FOCUSED and not maximized or fullscreen
WINDOWSTATE=$(xprop -id $WINDOWID _NET_WM_STATE | awk -F '=' '{print $2}')
WINDOWPOS=$(xdotool getwindowfocus getwindowgeometry | egrep -o '[0-9]{1,4},[0-9]{1,4}')
declare -a WINGEO=($(xprop -id $WINDOWID _NET_WM_ICON_GEOMETRY | awk -F '=' '{print $2}' | tr ',' '\n'))
WINX=$(echo $WINDOWPOS | cut -d "," -f1)
WINY=$(echo $WINDOWPOS | cut -d "," -f2)

# pass 2 X positions and test if the WINX is between them
function testIfOnMonitor() {
	declare -i leftPoint=$1
	declare -i rightPoint=$2
	# echo ${leftPoint}
	# echo ${rightPoint}
	if [ $WINX -ge $leftPoint ] && [ $WINX -lt $rightPoint ]; then
		true
	else
		false
	fi
}

function unminimizeWindow() {
	# if the window is fullscreen take it out of fullscreen to move the window
	if [[ "$WINDOWSTATE" == *"_NET_WM_STATE_FULLSCREEN"* ]]; then
		wmctrl -s 0 -i -r $WINDOWID -b toggle,fullscreen
	fi

	# if the window is toggled to be max vertical and horz space then toggle it
	if [[ "$WINDOWSTATE" == *"_NET_WM_STATE_MAXIMIZED_HORZ"* || "$WINDOWSTATE" == *"_NET_WM_STATE_MAXIMIZED_VERT,"* ]]; then
		wmctrl -s 0 -i -r $WINDOWID -b toggle,maximized_vert,maximized_horz
	fi
}

# get the monitor number that the window is on
if testIfOnMonitor ${TRIGGERPOINTS[0]} ${TRIGGERPOINTS[1]}; then
	# echo "on monitor 0"
	if [ "$direction" == "right" ]; then
		unminimizeWindow
		wmctrl -s 0 -i -r $WINDOWID -e 0,${TRIGGERPOINTS[1]},0,1000,600
		wmctrl -s 0 -i -r $WINDOWID -b toggle,maximized_vert,maximized_horz
	fi
elif testIfOnMonitor ${TRIGGERPOINTS[1]} ${TRIGGERPOINTS[2]}; then
	# echo "on monitor 1"
	if [ "$direction" == "left" ]; then
		unminimizeWindow
		wmctrl -s 0 -i -r $WINDOWID -e 0,${TRIGGERPOINTS[0]},0,1000,600
		wmctrl -s 0 -i -r $WINDOWID -b toggle,maximized_vert,maximized_horz
	fi
	if [ "$direction" == "right" ]; then
		unminimizeWindow
		wmctrl -s 0 -i -r $WINDOWID -e 0,${TRIGGERPOINTS[2]},0,1000,600
		wmctrl -s 0 -i -r $WINDOWID -b toggle,maximized_vert,maximized_horz
	fi
else
	# echo "on monitor 2"
	if [ "$direction" == "left" ]; then
		unminimizeWindow
		wmctrl -s 0 -i -r $WINDOWID -e 0,${TRIGGERPOINTS[1]},0,1000,600
		wmctrl -s 0 -i -r $WINDOWID -b toggle,maximized_vert,maximized_horz
	fi
fi
