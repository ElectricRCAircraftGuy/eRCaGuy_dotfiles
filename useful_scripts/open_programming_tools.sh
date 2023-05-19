#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# open_programming_tools.sh
# - a script to open up a terminal in the right location with multiple tabs, etc, so I can begin
#   working & programming quickly!
# - also have it open up other programs & things as necessary

# Gabriel Staples
# First Written: 19 Apr. 2018

# PURPOSE & USAGE:
# This script opens up several tabs in a terminal--each tab with its own title and command, then it
# opens up a bunch of programs I use for daily development work. I run this script once after each
# reboot by simply clicking on the corresponding desktop file shortcut on my desktop in order to get
# my computer ready-to-go again.
# See my answer here for additional info:
# https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563

# INSTALLATION INSTRUCTIONS:
#
# 1. Copy this file to "~/bin" to 1) add it to your PATH, and 2) give you a copy to customize and
# edit.
#       cd /path/to/here
#       mkdir -p ~/bin
#       cp -i open_programming_tools.sh ~/bin/gs_open_programming_tools
#
# 2. **In the copy in ~/bin**, edit the list of programs to open below. Ensure each program you want
# opened is called, and in the order you want. TO VIEW DESKTOP LAUNCHERS TO SEE WHAT THE COMMANDS
# ARE FOR OPENING CERTAIN PROGRAMS you already have installed, you can consult the various *.desktop
# files in your "/usr/share/applications" directory:
#       ls /usr/share/applications
#       # then
#       cat /usr/share/applications/launcher_of_interest.desktop
#
# 3. Add a symlink to the corresponding desktop file to your Desktop so you can run this script
# by double-clicking on the icon on your Desktop:
#       cd /path/to/eRCaGuy_dotfiles/home/Desktop_launchers
#       ln -si "${PWD}/open_programming_tools.desktop" ~/Desktop
#
# 4. If you just created the "~/bin" dir for the first time ever in the first step above, close all
# terminal windows and re-open them (or log out of Ubuntu and then log back in).
#
# 5. Now run the script. There are two ways:
#   1. Double-click on the "Open Programming Tools" icon on your desktop! OR:
#   2. Run `gs_open_programming_tools` from the terminal!
#
# DONE!

# **Use ampersands (&) after each command below to allow them to all open up in parallel to speed up
# the opening process!**

# 1) Open up a terminal with multiple tabs. For this to work, this assumes you've already installed
# the necessary `~/.bash_aliases`, and `~/.bash_aliases_private` files from this directory. Set
# all your tabs to open in `~/.bash_aliases_private`??? <==========
# See this readme for details:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home#1-installation

# inter-process communication is done here via the existence of the below temporary file!
mkdir -p ~/temp
if [ ! -f ~/temp/.open_default_tabs ]; then  # for meaning of `-f`, see `man test`
    touch ~/temp/.open_default_tabs
fi

# Choose your terminal application. Only ONE of these should be uncommented! I prefer `terminator`
# (install it with `sudo apt install terminator`), but the default terminal application that Ubuntu
# comes with is `gnome-terminal`.
terminator&
# gnome-terminal&

# 2) Open up all other programs you want:

nemo "$HOME/GS/dev"&  # Nemo file manager; start in this folder
subl&                 # Sublime Text editor
# gnome-system-monitor&  # nah, added to Ubuntu's system startup menu to open this at boot instead
libreoffice --writer&
google-chrome&
$HOME/eclipse/cpp-2022-12/eclipse/eclipse&
code # Microsoft Visual Studio Code (MS VSCode)--no `&` needed!
/usr/bin/slack&


