#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# touchpad_toggle.sh
# - toggle the touchpad & touchscreen on and off, and enable/disable imwheel to fix scroll speed when using a mouse
#   instead of the touchpad
# - I recommend attaching this script to an Ubuntu ***keyboard shortcut such as Ctrl + Alt + P*** to toggle the touchpad
#   and other devices on and off

# INSTALLATION INSTRUCTIONS:
# First, familiarize yourself with my instructions here: 
# [Permanently fix Chrome scroll speed](https://askubuntu.com/a/991680/327339)
#
# 1. Ensure ~/bin dir exists:
#           mkdir -p ~/bin
#
# 2. Install `imwheel` and symlink over the "~/.imwheelrc" file, following the instructions in 
#    "eRCaGuy_dotfiles/home/.imwheelrc".
#
# 3. Symlink this script to ~/bin with a name that you like. Ex:
#           cd path/to/here
#           ln -si "$PWD/touchpad_toggle.sh" ~/bin/gs_touchpad_toggle
#
# 4. Adjust the USER INPUTS section below, as required. If you are running the X11 window server,
# this will require running `xinput` once from the command line to ensure that the strings the
# program is searching for to identify your touchpad and touchscreen will work. See the 
# "USER INPUTS SECTION" below and follow any instrutions there. 
#
# 5. Create a custom keyboard shortcut to associate Ctrl + Alt + P with this script. In Ubuntu
# 18.04, for instance, adding custom keyboard shortcuts is found in Settings --> Devices -->
# Keyboard --> scroll to very bottom and click the "+" button to add a custom shortcut. Name
# it "Touchpad Toggle", give it the command "gs_touchpad_toggle", and associate it with the Ctrl +
# Alt + P keyboard shortcut. Test this shortcut now to ensure it works!
#
# 6. Edit the Startup Applications GUI tool to add a startup call to toggle the touchpad OFF with
# every boot: press Windows (Super) key --> search for "Startup Applications", and open it -->
# click "Add" to create a new entry --> Name it "disable touchpad (Ctrl + Alt + P)",
# enter "gs_touchpad_toggle --off" for the "Command", and "found in ~/bin" for the "Comment."
# Click "Save", then "Close".
#
# 7. Done! Your Touchpad and Touchscreen will automatically become DISABLED at every boot! To toggle
# it on/off manually, use the Ctrl + Alt + P shortcut you set up. This is very useful to quickly
# swap between using an external mouse vs the built-in touchpad or touchscreen.


# Author: Gabriel Staples
# Started: 2 Apr. 2018
# Update History (newest on TOP):
#   every date thereafter - refer to the eRCaGuy_dotfiles project referenced above; see git commits
#   28 Jan. 2020 - added in lines to disable Touchscreen too, as well as show ID numbers of
#                  Touchscreen & Touchpad
#   22 June 2019 - added in the imwheel stuff to not mess up track pad scrolling when
#                  track pad is in use

# New references (in order of importance: most important first):
# 1. my answer on touchpad toggle and imwheel: https://askubuntu.com/a/991680/327339
# 1. my answer on enabling/disabling touchpad in Ubuntu 22.04: 
#    https://askubuntu.com/a/1446479/327339

# Original References (in order of progression):
# 1. negusp described xinput: https://askubuntu.com/questions/844151/enable-disable-touchpad/844218#844218
# 2. Almas Dusal does some fancy sed stuff & turns negusp's answer into a script:
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/874865#874865
# 3. I turn it into a beter script, attach it to a Ctrl + Alt + P shortcut, & do a zenity GUI popup window as well:
#    https://askubuntu.com/questions/844151/enable-disable-touchpad/1109515#1109515
# 4. ***** I add imwheel to my script to also fix Chrome mouse scroll wheel speed problem at the same time:
#    https://askubuntu.com/a/991680/327339
# 5. I put this script on Github, and posted a snapshot of it on this answer here:
#    https://askubuntu.com/questions/198572/how-do-i-disable-the-touchscreen-drivers/1206493#1206493
# 6. I put this script into my eRCaGuy_dotfiles, and continued to improve upon it here:
#    https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# ------------------------------------- USER INPUTS SECTION ----------------------------------------
# USER INPUTS--ADJUST THESE!: <==========

# For the X11 window server only (not Wayland):
# `xinput` search strings for these devices
# - Manually run `xinput` on your PC, look at the output, and adjust these search strings as 
#   necessary for your particular hardware and machine! Example output of `xinput`:
#
#       $ xinput
#       ⎡ Virtual core pointer                      id=2    [master pointer  (3)]
#       ⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
#       ⎜   ↳ Logitech MX Vertical                      id=11   [slave  pointer  (2)]
#       ⎜   ↳ Logitech MX Anywhere 3                    id=12   [slave  pointer  (2)]
#       ⎜   ↳ SynPS/2 Synaptics TouchPad                id=14   [slave  pointer  (2)]
#       ⎜   ↳ TPPS/2 Elan TrackPoint                    id=15   [slave  pointer  (2)]
#       ⎣ Virtual core keyboard                     id=3    [master keyboard (2)]
#           ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
#           ↳ Power Button                              id=6    [slave  keyboard (3)]
#           ↳ Video Bus                                 id=7    [slave  keyboard (3)]
#           ↳ Sleep Button                              id=8    [slave  keyboard (3)]
#           ↳ Integrated Camera: Integrated C           id=9    [slave  keyboard (3)]
#           ↳ Integrated Camera: Integrated I           id=10   [slave  keyboard (3)]
#           ↳ AT Translated Set 2 keyboard              id=13   [slave  keyboard (3)]
#           ↳ ThinkPad Extra Buttons                    id=16   [slave  keyboard (3)]
#           ↳ Logitech MX Vertical                      id=17   [slave  keyboard (3)]
#
# UPDATE THESE AS NECESSARY to override the default search strings for your touchpads and
# touchscreens.
# - NB: some computers need "touchpad" spelled like this with a capital 'P' in "TouchPad", and
#   others spell it simply as "Touchpad" with a lowercase 'p'. 
TOUCHPAD_STR="Touchpad|TouchPad"
TOUCHSCREEN_STR="Touchscreen|TouchScreen"

# For X11 or Wayland:
# Optionally disable toggling the touchpad or touchscreen, or both, if desired, by uncommenting
# these corresponding lines:
#
# TOUCHPAD_STR="NONE"
TOUCHSCREEN_STR="NONE"
# --------------------------------------------------------------------------------------------------

HELP_STR=\
"Usage: touchpad_toggle [positional_params]\n"\
"  Positional Parameters:\n"\
"  -h OR --help = print this help menu/usage string\n"\
"  --on         = turn touchpad & touchscreen ON\n"\
"  --off        = turn touchpad & touchscreen OFF\n"

# Determine if we are using Wayland. Ubuntu 22.04 is the first long-term support Ubuntu release to
# have Wayland in use, rather than x11, by default.
# See: https://unix.stackexchange.com/a/355476/114401
WINDOW_MANAGER="wayland"
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "Using x11 window manager server."
    WINDOW_MANAGER="x11"
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Using Wayland window manager server."
else
    echo "*Probably* using Wayland window manager server."
fi

# For X11 only, obtain the xinput IDs for the Touchpad & Touchscreen so we can disable/enable them
if [ "$WINDOW_MANAGER" = "x11" ]; then
    if [ "$TOUCHPAD_STR" =  "NONE" ]; then
        TouchpadId="$TOUCHPAD_STR"
    else
        # See: https://askubuntu.com/a/874865/327339
        read TouchpadId <<< "$(xinput | sed -nre "/${TOUCHPAD_STR}/s/.*id=([0-9]*).*/\1/p")"
    fi

    if [ "$TOUCHSCREEN_STR" =  "NONE" ]; then
        TouchscreenId="$TOUCHSCREEN_STR"
    else
        # See: https://askubuntu.com/a/874865/327339
        read TouchscreenId <<< "$(xinput | sed -nre "/${TOUCHSCREEN_STR}/s/.*id=([0-9]*).*/\1/p")"
    fi

    # echo "TouchpadId = $TouchpadId; see output from 'xinput'" # Debug print
    # echo "TouchscreenId = $TouchscreenId; see output from 'xinput'" # Debug print
else
    TouchpadId="(NA)"
    TouchscreenId="(NA)"
fi

PRINT_TEXT="Touchpad ID $TouchpadId &amp; Touchscreen ID $TouchscreenId"
if [ "$WINDOW_MANAGER" = "x11" ]; then
    PRINT_TEXT="${PRINT_TEXT} (in X11)"
else
    PRINT_TEXT="${PRINT_TEXT} (in Wayland)"
fi

# Read the current toggle state ("ON" = touch devices on, "OFF" = touch devices off)
get_current_state() {
    state="OFF"

    if [ "$WINDOW_MANAGER" = "x11" ]; then
        state="$(xinput list-props "$TouchpadId" | grep "Device Enabled" | grep -o "[01]$")"
        if [ "$state" -eq "1" ]; then
            state="ON"
        fi 
    else
        # for wayland
        # See my answer here: https://askubuntu.com/a/1446479/327339
        #       gsettings get org.gnome.desktop.peripherals.touchpad send-events
        state="$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)"
        if [ "$state" = "'enabled'" ]; then
            state="ON"
        fi 
    fi

    echo "$state"
}

disable_devices() {
    # Note: it looks like `xinput` no longer does the job for Ubuntu 22.04, even for the X11 Window
    # server, so do the `gsettings` calls too!

    if [ "$WINDOW_MANAGER" = "x11" ]; then
        if [ "$TouchpadId" != "NONE" ]; then
            echo "Disabling touchpad ID $TouchpadId."
            xinput --disable "$TouchpadId"
            gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
        fi
        if [ "$TouchscreenId" != "NONE" ]; then
            echo "Disabling touchscreen ID $TouchscreenId."
            xinput --disable "$TouchscreenId"
            echo "  TODO: learn to disable the touchscreen using GNOME's gsettings."
        fi
    else 
        # for wayland
        # See my answer here: https://askubuntu.com/a/1446479/327339
        if [ "$TouchpadId" != "NONE" ]; then
            echo "Disabling touchpad."
            gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
        fi
        if [ "$TouchscreenId" != "NONE" ]; then
            echo "Disabling touchscreen."
            echo "  TODO: learn to disable the touchscreen using GNOME's gsettings."
        fi
    fi
}

enable_devices() {
    # Note: it looks like `xinput` no longer does the job for Ubuntu 22.04, even for the X11 Window
    # server, so do the `gsettings` calls too!

    if [ "$WINDOW_MANAGER" = "x11" ]; then
        if [ "$TouchpadId" != "NONE" ]; then
            echo "Enabling touchpad ID $TouchpadId."
            xinput --enable "$TouchpadId"
            gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
        fi
        if [ "$TouchscreenId" != "NONE" ]; then
            echo "Enabling touchscreen ID $TouchscreenId."
            xinput --enable "$TouchscreenId"
            echo "  TODO: learn to enable the touchscreen using GNOME's gsettings."
        fi
    else
        # for wayland
        # See my answer here: https://askubuntu.com/a/1446479/327339
        if [ "$TouchpadId" != "NONE" ]; then
            echo "Enabling touchpad."
            gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
        fi
        if [ "$TouchscreenId" != "NONE" ]; then
            echo "Enabling touchscreen."
            echo "  TODO: learn to enable the touchscreen using GNOME's gsettings."
        fi
    fi
}

newstate=""
if [ "$#" -eq "0" ];  then
    # No positional parameters, so determine the actual current state so we can toggle it
    state="$(get_current_state)"
    if [ "$state" = 'ON' ];then
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

if [ "$newstate" = "OFF" ]; then
    # Turn touchpad & touchscreen OFF, and turn imwheel ON to improve mouse wheel scroll speed since
    # user must be using an external mouse
    echo "Turning TouchpadId $TouchpadId & TouchscreenId $TouchscreenId OFF."

    imwheel -b "4 5" # turn on imwheel to help external mouse wheel scroll speed be better
    disable_devices
    zenity --info --text "${PRINT_TEXT} DISABLED" --timeout=2
elif [ "$newstate" = "ON" ]; then
    # Turn touchpad & touchscreen ON, & turn imwheel OFF so it doesn't interfere w/trackpad
    # scrolling, since user must be using the touchpad and/or touchscreen
    echo "Turning TouchpadId $TouchpadId & TouchscreenId $TouchscreenId ON."

    killall imwheel # turn OFF imwheel to keep imwheel from interfering with proper track pad 
                    # scrolling
    enable_devices
    zenity --info --text "${PRINT_TEXT} ENABLED" --timeout=2
else
    echo "ERROR: Invalid newstate value of \"$newstate\"; must use only \"OFF\" or \"ON\"."
fi


