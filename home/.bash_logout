# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
#
# COPIED FROM UBUNTU'S DEFAULT VERSION OF THIS FILE AT "/etc/skel/.bash_logout".
# To "install" it, copy it to your home dir:
#
#       # Option 1: copy it from this repo
#       cd path/to/this/dir
#       cp .bash_logout ~
#
#       # Option 2: copy it from your own /etc/skel directory directly
#       cp /etc/skel/.bash_logout ~

# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
