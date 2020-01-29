#!/bin/bash

# GS_toggle_touchpad.sh
# - toggle the touchpad on and off

# Gabriel Staples
# Written: 2 Apr. 2018 
# Updated: 22 June 2019 - added in the imwheel stuff to not mess up track pad scrolling when
#                         track pad is in use

# References:
# - https://askubuntu.com/a/874865/327339

read TPdevice <<< $( xinput | sed -nre '/TouchPad/s/.*id=([0-9]*).*/\1/p' )
state=$( xinput list-props "$TPdevice" | grep "Device Enabled" | grep -o "[01]$" )

if [ "$state" -eq '1' ];then
	# https://askubuntu.com/questions/254367/permanently-fix-chrome-scroll-speed/991680#991680
	imwheel -b "4 5" # helps mouse wheel scroll speed
    xinput --disable "$TPdevice"
    zenity --info --text "Touchpad DISABLED" --timeout=2
else
	# https://askubuntu.com/questions/254367/permanently-fix-chrome-scroll-speed/991680#991680
	killall imwheel # helps track pad scrolling not be messed up
    xinput --enable "$TPdevice"
    zenity --info --text "Touchpad ENABLED" --timeout=2
fi


