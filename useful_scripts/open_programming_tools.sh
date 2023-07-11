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
#
#       # Option 1 (recommended for most users): **copy** my file so you can customize it
#       cp -i open_programming_tools.sh ~/bin/gs_open_programming_tools
#
#       # OR Option 2 (only do this if this is really what you want; NOT
#       # recommended for most users): make a **symlink** to my file so you
#       # always have *exactly* what I have
#       ln -si "$PWD/open_programming_tools.sh" ~/bin/gs_open_programming_tools
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
# terminal windows and re-open them, OR log out of Ubuntu and then log back in, OR run this in all
# open terminals:
#
#       . ~/.profile
#
# 5. Now run the script. There are two ways:
#   1. Double-click on the "Open Programming Tools" icon on your desktop! OR:
#   2. Run `gs_open_programming_tools` from the terminal!
#
# DONE!

# NOTES:
#
# 1. **Use ampersands (&) after each command below to allow them to all open up in parallel to speed
# up the opening process!**
#
# 1. The following usage of the "~/temp/.open_default_tabs" inter-process communication (IPC) file
# below, in conjunction with calling `terminator&` or `gnome-terminal&` after that, to open the
# terminal, is what automagically opens up the terminal with your desired and customized tabs! For
# this to work, you must have already installed the necessary `~/.bash_aliases`, and
# `~/.bash_aliases_private` files from here:
#
#   1. "eRCaGuy_dotfiles/home/.bash_aliases" - this file is what opens all custom terminal tabs,
#   setting their custom titles and running custom commands in each tab.
#
#   1. "eRCaGuy_dotfiles/home/.bash_aliases_private" - this file is where **YOU CONFIGURE** all
#   custom tab titles and tab commands.
#
#   You, as the user, are expected to configure all customization of the terminal tab titles and tab
#   commands in the "~/.bash_aliases_private" file which you must install by reading the
#   instructions in the top of the ".bash_aliases_private" file mentioned just above.
#
#   See also the instructions in this "eRCaGuy_dotfiles/home/README.md" for more details:
#   https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home#1-installation

# -------------------------------------------------------
# 1. Open up your terminal with all custom tabs you want:
# -------------------------------------------------------

# inter-process communication is done here via the existence of the below temporary file!
mkdir -p ~/temp
if [ ! -f ~/temp/.open_default_tabs ]; then  # for meaning of `-f`, see `man test`
    touch ~/temp/.open_default_tabs
fi

# Choose your terminal application. Only ONE of these should be uncommented! I prefer `terminator`
# (install it with `sudo apt install terminator`), but the default terminal application that Ubuntu
# comes with is `gnome-terminal`.
# - For my full `terminator` installation instructions, see here:
#   https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/useful_apps#terminator
terminator&
# gnome-terminal&

# -------------------------------------------------------
# 2. Now open up all other programs you want:
# -------------------------------------------------------

# File managers
#
# Nemo file manager; start in this folder
# - See my full `nemo` installation instructions here: https://askubuntu.com/a/1446372/327339
nemo "$HOME/GS-w/dev-w"&
# nemo "$HOME/GS-p/dev-p"&
# nemo "$HOME/GS/dev"&

# Misc., including word processors or other apps
#
# gnome-system-monitor&   # nah, added to Ubuntu's system startup menu to open this at boot instead
libreoffice --writer&

# Web browsers
#
google-chrome&
# Microsoft Edge browser; see: "/usr/share/applications/microsoft-edge.desktop"
microsoft-edge-stable&

# Text editors and coding IDEs
#
$HOME/eclipse/embedcpp-2023-03/eclipse/eclipse&
# $HOME/eclipse/cpp-2022-12/eclipse/eclipse&
subl&                     # Sublime Text editor
code # Microsoft Visual Studio Code (MS VSCode)--no `&` needed!
# Microchip MPLAB X IDE
# - from: "/usr/share/applications/mplab_ide-v6.10.desktop"
# /opt/microchip/mplabx/v6.10/mplab_platform/bin/mplab_ide&

# Messengers and chat programs
#
/usr/bin/slack&

# Microsoft tools for Linux
#
# Microsoft Teams (PWA)
# - from: "~/.local/share/applications/msedge-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
/opt/microsoft/msedge/microsoft-edge --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo "--app-url=https://teams.microsoft.com/?clientType=pwa"
# Outlook (PWA)
# - from: "~/.local/share/applications/msedge-pkooggnaalmfkidjmlhoelhdllpphaga-Default.desktop"
/opt/microsoft/msedge/microsoft-edge --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga --app-url=https://outlook.office365.com/mail/ --app-launch-url-for-shortcuts-menu-item=https://outlook.office365.com/calendar
