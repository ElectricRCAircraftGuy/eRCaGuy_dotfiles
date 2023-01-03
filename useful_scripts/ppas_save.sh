#!/usr/bin/env sh

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Originally By @stwissel: https://askubuntu.com/a/148968/327339
#
# Script to get all the PPA (Ubuntu packages) installed on a system, so you can install them on
# another system.
#
#       # 1. Back up your ppas from your source computer.
#       mkdir -p temp
#       ./ppas_save.sh > temp/ppas_to_install.sh
#
#       # 2. Manually inspect the temp/ppas_to_install.sh file you just created. 
#
#       # 3. On the destination computer, run the commands from that file to install those PPAs.

for APT in `find /etc/apt/ -name \*.list`; do
    grep -Po "(?<=^deb\s).*?(?=#|$)" $APT | while read ENTRY ; do
        HOST=`echo $ENTRY | cut -d/ -f3`
        USER=`echo $ENTRY | cut -d/ -f4`
        PPA=`echo $ENTRY | cut -d/ -f5`
        #echo sudo apt-add-repository ppa:$USER/$PPA
        if [ "ppa.launchpad.net" = "$HOST" ]; then
            echo sudo apt-add-repository ppa:$USER/$PPA
        else
            echo sudo apt-add-repository \'${ENTRY}\'
        fi
    done
done


# Example contents of temp/ppas_to_install.sh:
#       
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy main restricted'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy-updates main restricted'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy universe'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy-updates universe'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy multiverse'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy-updates multiverse'
#       sudo apt-add-repository 'http://us.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse'
#       sudo apt-add-repository 'http://security.ubuntu.com/ubuntu jammy-security main restricted'
#       sudo apt-add-repository 'http://security.ubuntu.com/ubuntu jammy-security universe'
#       sudo apt-add-repository 'http://security.ubuntu.com/ubuntu jammy-security multiverse'
#       sudo apt-add-repository '[arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main'
#       sudo apt-add-repository 'https://download.sublimetext.com/ apt/stable/'
#
# etc.