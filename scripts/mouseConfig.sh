#!/bin/bash
# You would normally set these props though these commands
# xinput --set-prop "Razer Razer DeathAdder" "libinput Accel Speed" -0.85
# xinput --set-prop "Razer Razer DeathAdder" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
# xinput --set-prop "Razer Razer DeathAdder" "libinput Accel Profile Enabled" 0, 1

# If theres no display then set it to something reasonable
if [ -z $DISPLAY ]
then 
	export DISPLAY=:0.0
fi


dev[0]="Logitech MX Master 3"
dev[1]="Razer Razer DeathAdder"
#dev[2]="ELECOM TrackBall Mouse HUGE TrackBall"


for ((i = 0; i < ${#dev[@]}; i++)) 
do
	xinput --set-prop pointer:"${dev[i]}" "libinput Accel Speed" -0.6
	xinput --set-prop pointer:"${dev[i]}" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
	xinput --set-prop pointer:"${dev[i]}" "libinput Accel Profile Enabled" 0, 1
done

# Configure ELECOM TrackBall
# if true; then echo "This text will always appear."; fi;

