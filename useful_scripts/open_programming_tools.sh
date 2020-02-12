#!/bin/bash

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
gnome-terminal&

# 2) Open up other programs:

nemo "$HOME/dev"& # Nemo file manager
subl& # Sublime Text editor
# gnome-system-monitor& # nah, add to Ubuntu's system startup menu to open this at boot instead
libreoffice --writer&
google-chrome&
$HOME/eclipse/cpp-2019-12/eclipse/eclipse&
/usr/bin/slack&


