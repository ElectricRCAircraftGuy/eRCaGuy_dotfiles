#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# 1. Note: this script opens up several tabs in a terminal, each tab with its own title and command, then it opens up
#    a bunch of programs I use daily for development work. See the Reference URL below for additional info.
# 2. Edit the titles and commands below. Ensure it opens up the programs you want, and in the right order, 
#    then to install, either:
# A) copy it to your Desktop: `cp -i open_programming_tools.sh ~/Desktop` OR 
# B) create a symbolic link to it on your Desktop:
#		cd /path/to/here
#		ln -s "${PWD}/open_programming_tools.sh" ~/Desktop/open_programming_tools
# OR
# C) (My Preference) Create a .desktop file on your Desktop which calls this script. Use the .desktop file
#    provided in "eRCaGuy_dotfiles/Desktop_launchers/open_programming_tools.desktop" for this purpose.

# open_programming_tools.sh
# - a script to open up a terminal in the right location with multiple tabs, etc, so I can begin working
#   & programming quickly!
# - also have it open up other programs & things as necessary

# Gabriel Staples
# First Written: 19 Apr. 2018 
# Updated: 2020 & later--now git version-controlled in the above dotfiles project

# References & Additional Reading:
# - My own answer!: 
#   https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563

# TO VIEW DESKTOP LAUNCHERS TO SEE WHAT THE COMMANDS ARE FOR OPENING CERTAIN PROGRAMS:    
# `ls /usr/share/applications`, then:
# `cat /usr/share/applications/launcher_of_interest.desktop`


# **Use ampersands (&) after each command below to allow them to all open up in parallel to speed up 
# the opening process!**

# 1) Open up a terminal with multiple tabs
# - Set all tab titles & cmds in ~/.bashrc

# Export this variable so your ~/.bashrc file will see it and do the magic.
export OPEN_DEFAULT_TABS=true
# Open a new terminal window, which by default also sources your ~/.bashrc file again, 
# thereby kicking off the process since you set the `OPEN_DEFAULT_TABS` variable just above.
# gnome-terminal&
terminator& ### TODO: MAKE A WAY TO EASILY CHOOSE WHICH TERMINAL YOU WANT, BY SETTING A VARIABLE
            # INSIDE ~/.bashrc or something. gnome-terminal or terminator
# Now reset and unexport the above variable so it will no longer be in force; note that it's possible only 
# one of the below lines is *required*, but let's do both for good measure
# - This solves the bug where right-clicking in the nemo file manager (which is opened below) and 
#   going to "Open in Terminal" opens up a new terminal with all the default tabs (bug!), rather 
#   than a terminal with only a new tab in the currently-opened directory.
sleep 1 ######## necessary????
OPEN_DEFAULT_TABS=      # set this variable back to an empty string so it's no longer in force
unset OPEN_DEFAULT_TABS # unexport it

# 2) Open up other programs:

nemo "$HOME/GS/dev"& # Nemo file manager; start in this folder
subl& # Sublime Text editor
# gnome-system-monitor& # nah, add to Ubuntu's system startup menu to open this at boot instead
libreoffice --writer&
google-chrome&
$HOME/eclipse/cpp-2019-12/eclipse/eclipse&
/usr/bin/slack&


