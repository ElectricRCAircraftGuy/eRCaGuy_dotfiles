#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# toggle_touchpad.sh
# - toggle the touchpad & touchscreen on and off, and enable/disable imwheel to fix scroll speed when using a mouse
#   instead of the touchpad
# - I recommend attaching this script to an Ubuntu ***keyboard shortcut such as Ctrl + Alt + P*** to toggle the touchpad
#   and other devices on and off

# Gabriel Staples
# Started: 2 Apr. 2018 
# Update History (newest on TOP): 
#   28 Jan. 2020 - added in lines to disable Touchscreen too, as well as show ID numbers of 
#                  Touchscreen & Touchpad
#   22 June 2019 - added in the imwheel stuff to not mess up track pad scrolling when
#                  track pad is in use

# References (in order of progression):
# 1. negusp described xinput: https://askubuntu.com/questions/844151/enable-disable-touchpad/844218#844218
# 2. Almas Dusal does some fancy sed stuff & turns negusp's answer into a script: https://askubuntu.com/questions/844151/enable-disable-touchpad/874865#874865
# 3. I turn it into a beter script, attach it to a Ctrl + Alt + P shortcut, & do a zenity GUI popup window as well:
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/1109515#1109515
# 4. I add imwheel to my script to also fix Chrome mouse scroll wheel speed problem at the same time:
#    https://askubuntu.com/questions/254367/permanently-fix-chrome-scroll-speed/991680#991680
# 5. I put this script on Github, and posted a snapshot of it on this answer here: 
#    https://askubuntu.com/questions/198572/how-do-i-disable-the-touchscreen-drivers/1206493#1206493 

# `xinput` search strings for these devices
# - Manually run `xinput` on your PC, look at the output, and adjust these search strings as necessary for your 
#   particular hardware and machine!
TOUCHPAD_STR="TouchPad"
TOUCHSCREEN_STR="Touchscreen"

read TouchpadId <<< $( xinput | sed -nre "/${TOUCHPAD_STR}/s/.*id=([0-9]*).*/\1/p" )
read TouchscreenId <<< $( xinput | sed -nre "/${TOUCHSCREEN_STR}/s/.*id=([0-9]*).*/\1/p" )
echo "TouchpadId = $TouchpadId" # Debug print
echo "TouchscreenId = $TouchscreenId" # Debug print

state=$( xinput list-props "$TouchpadId" | grep "Device Enabled" | grep -o "[01]$" )

PRINT_TEXT="Touchpad (ID $TouchpadId) &amp; Touchscreen (ID $TouchscreenId) "
if [ "$state" -eq '1' ];then
    imwheel -b "4 5" # helps mouse wheel scroll speed be better
    xinput --disable "$TouchpadId"
    xinput --disable "$TouchscreenId"
    zenity --info --text "${PRINT_TEXT} DISABLED" --timeout=2
else
    killall imwheel # helps track pad scrolling not be messed up by imwheel
    xinput --enable "$TouchpadId"
    xinput --enable "$TouchscreenId"
    zenity --info --text "${PRINT_TEXT} ENABLED" --timeout=2
fi


