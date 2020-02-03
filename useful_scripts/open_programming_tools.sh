#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# 1. Note: this script opens up several tabs in a terminal, each tab with its own title and command, then it opens up
#    a bunch of programs I use daily for development work. See the Reference URL below for additional info.
# 2. Edit the titles and commands below. Ensure it opens up the programs you want, and in the right order, 
#    then to install, either:
# A) copy it to your Desktop: `cp -i open_programming_tools.sh ~/Desktop` OR 
# B) [My preference] create a symbolic link to it on your Desktop:
#		cd /path/to/here
#		ln -s "${PWD}/open_programming_tools.sh" ~/Desktop/open_programming_tools
# OR C) (Not shown in details) Create a .desktop file on your Desktop which calls this script.

# open_programming_tools.sh
# - a script to open up a terminal in the right location with multiple tabs, etc, so I can begin working
#   & programming quickly!
# - also have it open up other programs & things as necessary

# Gabriel Staples
# First Written: 19 Apr. 2018 
# Updated: 2020 & later--now git version-controlled 

# References & Additional Reading:
# - My own answer!: 
#   https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563

# TO VIEW DESKTOP LAUNCHERS TO SEE WHAT THE COMMANDS ARE FOR OPENING CERTAIN PROGRAMS:    
# `ls /usr/share/applications` OR
# `ls /usr/share/applications/my_launcher_name*`


# 1) Open up a terminal with multiple tabs
# - Note that the `$SHELL` cmd at the end holds the terminal open!

title1="git"
title2="bazel"
title3="Python"
title4="my project"

cmd1="cd ~/dev"
cmd2="${cmd1}"
cmd3="${cmd1}"
cmd4="cd ~/dev/my_project"

gnome-terminal --tab --title="$title1" --command="bash -c '$cmd1; $SHELL'"\
               --tab --title="$title2" --command="bash -c '$cmd2; $SHELL'"\
               --tab --title="$title3" --command="bash -c '$cmd3; $SHELL'"\
               --tab --title="$title4" --command="bash -c '$cmd4; $SHELL'"&

# 2) Open up programs:

nemo ~/dev& # Nemo file manager:
subl& # Sublime Text editor
# gnome-system-monitor& # nah, add to Ubuntu's system startup menu instead
libreoffice6.1 --writer&
google-chrome&
$HOME/Downloads/Install_Files/eclipse/eclipse&

# 3) Exit

exit 0
# $SHELL #keep terminal open when done


