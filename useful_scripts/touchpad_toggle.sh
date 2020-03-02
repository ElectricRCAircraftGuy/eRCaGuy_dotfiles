#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# touchpad_toggle.sh
# - toggle the touchpad & touchscreen on and off, and enable/disable imwheel to fix scroll speed when using a mouse
#   instead of the touchpad
# - I recommend attaching this script to an Ubuntu ***keyboard shortcut such as Ctrl + Alt + P*** to toggle the touchpad
#   and other devices on and off

# INSTALLATION INSTRUCTIONS:
# 1. Ensure ~/bin dir exists:
#		mkdir -p ~/bin
# 2. Copy this script to ~/bin with a name that you like. Ex:
#		cp -i touchpad_toggle.sh ~/bin/gs_touchpad_toggle
# 3. Adjust the USER INPUTS section below, as required. This will require running `xinput` once from
#    the command line to ensure that TouchPad/Touchpad is spelled right, for instance. See below for details.
# 4. Create a keyboard shortcut to associate Ctrl + Alt + P with this script via (on Ubuntu 18.04)
#    Settings --> Devices --> Keyboard --> scroll to very bottom and click the "+" button to add a custom
#    shortcut, then name it "Touchpad Toggle", give it the command "gs_touchpad_toggle", and associate it
#    with the Ctrl + Alt + P keyboard shortcut. Test this shortcut now to ensure it works!
# 5. Add a startup call to toggle touchpad OFF with every boot: press Windows (Super) key --> search for 
#    "Startup Applications", and open it --> click "Add" to create a new entry --> Name it
#    "disable touchpad (Ctrl + Alt + P)", enter "gs_touchpad_toggle --off" for the "Command", and 
#    "found in ~/bin" for the "Comment." Click "Save", then "Close".
# 6. Done! Your Touchpad and Touchscreen will automatically become DISABLED at every boot! To toggle it on/off
#    use the Ctrl + Alt + P shortcut you set up. This is very useful to quickly swap between using an external
#    mouse vs the built-in touchpad or touchscreen.

# Author: Gabriel Staples
# Started: 2 Apr. 2018 
# Update History (newest on TOP): 
#   every date thereafter - refer to the eRCaGuy_dotfiles project referenced above; see git commits
#   28 Jan. 2020 - added in lines to disable Touchscreen too, as well as show ID numbers of 
#                  Touchscreen & Touchpad
#   22 June 2019 - added in the imwheel stuff to not mess up track pad scrolling when
#                  track pad is in use

# References (in order of progression):
# 1. negusp described xinput: https://askubuntu.com/questions/844151/enable-disable-touchpad/844218#844218
# 2. Almas Dusal does some fancy sed stuff & turns negusp's answer into a script: 
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/874865#874865
# 3. I turn it into a beter script, attach it to a Ctrl + Alt + P shortcut, & do a zenity GUI popup window as well:
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/1109515#1109515
# 4. I add imwheel to my script to also fix Chrome mouse scroll wheel speed problem at the same time:
#    https://askubuntu.com/questions/254367/permanently-fix-chrome-scroll-speed/991680#991680
# 5. I put this script on Github, and posted a snapshot of it on this answer here: 
#    https://askubuntu.com/questions/198572/how-do-i-disable-the-touchscreen-drivers/1206493#1206493 
# 6. I put this script into my eRCaGuy_dotfiles, and continued to improve upon it here:
#	 https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# ----------------------------------------------------------------------------------------------------------------------
# USER INPUTS--ADJUST THESE!:

# `xinput` search strings for these devices
# - Manually run `xinput` on your PC, look at the output, and adjust these search strings as necessary for your 
#   particular hardware and machine!
# TOUCHPAD_STR="TouchPad" # some computers need it spelled like this with a capital 'P' in TouchPad
TOUCHPAD_STR="Touchpad" # other computers need it spelled like this with a lower-case 'p' in Touchpad
TOUCHSCREEN_STR="Touchscreen"
# ----------------------------------------------------------------------------------------------------------------------

HELP_STR=\
"Usage: touchpad_toggle [positional_params]\n"\
"  Positional Parameters:\n"\
"  -h OR --help = print this help menu/usage string\n"\
"  --on         = turn touchpad & touchscreen ON\n"\
"  --off        = turn touchpad & touchscreen OFF\n"

# Obtain the xinput IDs for the Touchpad & Touchscreen so we can disable/enable them
read TouchpadId <<< $( xinput | sed -nre "/${TOUCHPAD_STR}/s/.*id=([0-9]*).*/\1/p" )
read TouchscreenId <<< $( xinput | sed -nre "/${TOUCHSCREEN_STR}/s/.*id=([0-9]*).*/\1/p" )
# echo "TouchpadId = $TouchpadId; see output from 'xinput'" # Debug print
# echo "TouchscreenId = $TouchscreenId; see output from 'xinput'" # Debug print

PRINT_TEXT="Touchpad (ID $TouchpadId) &amp; Touchscreen (ID $TouchscreenId) "

newstate=
if [ "$#" -eq "0" ];  then
	# No positional parameters, so determine the actual current state so we can toggle it
	state=$( xinput list-props "$TouchpadId" | grep "Device Enabled" | grep -o "[01]$" )
	if [ "$state" -eq '1' ];then
		# state is ON, so toggle it to OFF
		newstate="OFF"
	else
		# state is OFF, so toggle it to ON
		newstate="ON"
	fi
elif [ "$#" -eq "1" ] && [ "$1" = "--on" ];  then
    newstate="ON"
elif [ "$#" -eq "1" ] && [ "$1" = "--off" ];  then
    newstate="OFF"
elif [ "$#" -eq "1" ] && ([ "$1" = "--help" ] || [ "$1" = "-h" ]);  then
    echo -e "$HELP_STR"
    exit
else
	echo "ERROR: Invalid input parameters."
	echo -e "$HELP_STR"
	exit
fi

if [ "$newstate" = "OFF" ];then
	# Turn touchpad & touchscreen OFF, and turn imwheel ON to improve mouse wheel scroll speed since user must be using
	# an external mouse
	echo "Turning TouchpadId $TouchpadId & TouchscreenId $TouchscreenId OFF."
    imwheel -b "4 5" # turn on imwheel to help external mouse wheel scroll speed be better
    xinput --disable "$TouchpadId"
    xinput --disable "$TouchscreenId"
    zenity --info --text "${PRINT_TEXT} DISABLED" --timeout=2
elif [ "$newstate" = "ON" ];then
	# Turn touchpad & touchscreen ON, & turn imwheel OFF so it doesn't interfere w/trackpad scrolling, since user must
	# be using the touchpad and/or touchscreen 
	echo "Turning TouchpadId $TouchpadId & TouchscreenId $TouchscreenId ON."
    killall imwheel # turn OFF imwheel to keep imwheel from interfering with proper track pad scrolling
    xinput --enable "$TouchpadId"
    xinput --enable "$TouchscreenId"
    zenity --info --text "${PRINT_TEXT} ENABLED" --timeout=2
else
	echo "ERROR: Invalid newstate value of \"$newstate\"; must use only \"OFF\" or \"ON\"."
fi


