#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# 1. Create symlinks in ~/bin to these scripts so you can run them from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -s "${PWD}/apt-cacher-server_proxy_status.sh" ~/bin/apt-cacher-status
#       ln -s "${PWD}/apt-cacher-server_proxy_toggle.sh" ~/bin/apt-cacher-toggle
# 2. Now check to see if you're using the apt-cacher server with `apt-cacher-status`, and toggle its usage ON/OFF
#    with `sudo apt-cacher-toggle`
#    - NB: this requires that your user's "~/bin" dir ($HOME/bin) be in your PATH variable! If it is not, 
#      and you are running Ubuntu or similar, simply copy this project's .profile file to your home dir and 
#      reboot. Your $HOME/bin directory will now be at the start of your PATH variable!

# References
# 1. https://help.ubuntu.com/community/Apt-Cacher-Server

./apt-cacher-server_proxy.sh status

