#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# 23 June 2023

# DESCRIPTION:
# Toggle showing the desktop / hiding/showing all windows.

# INSTALLATION INSTRUCTIONS:
#
# 1. Install dependencies:
#
#       sudo apt update
#       sudo apt install wmctrl
#
# 2. Create a symlink in ~/bin to this script so you can run it from anywhere.
#
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/show_desktop.sh" ~/bin/show_desktop     # required
#       ln -si "${PWD}/show_desktop.sh" ~/bin/gs_show_desktop  # optional; replace "gs" with your initials
#
# 3. Re-source your ~/.profile file in Ubuntu.
#
#       . ~/.profile
#
# 4. Now you can use this command directly anywhere you like in any of these ways:
#
#       show_desktop
#       gs_show_desktop

# REFERENCES:
# 1. *****+ this answer here: https://askubuntu.com/a/905480/327339
# 1. and my answer here too: https://askubuntu.com/a/1109490/327339
# 1. show_desktop_with_wmctrl.sh -
#    https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/show_desktop_with_wmctrl.sh

# Toggle showing the desktop vs windows
toggle_windows() {
    status="$(wmctrl -m | grep "showing the desktop" | grep -Eo "ON|OFF")"
    if [ $status == "ON" ]; then
        wmctrl -k off
    else
        wmctrl -k on
    fi
}

toggle_windows

# Note: the user can press Windows + D to toggle back
