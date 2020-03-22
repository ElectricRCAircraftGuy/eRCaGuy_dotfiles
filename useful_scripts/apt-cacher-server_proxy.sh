#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# Follow the instructions in "apt-cacher-server_proxy_status.sh".

# apt-cacher-server_proxy.sh
# - Toggle on/off, or obtain the status of the apt-cacher proxy server.
# - NB: this script requires `sudo` to toggle.

# USAGE:
#   ./apt-cacher-server_proxy.sh = toggle the apt-cacher proxy server usage ON or OFF
#   ./apt-cacher-server_proxy.sh status = obtain the current status only
#   ./apt-cacher-server_proxy.sh s = alias to the cmd above

# References
# 1. https://help.ubuntu.com/community/Apt-Cacher-Server

PROXYFILE="/etc/apt/apt.conf.d/01proxy"

get_proxy_status () {
    status="DISABLED"

    if [ -f  $PROXYFILE ]; then
        status="ENABLED"
    fi

    echo $status
}

proxystatus=$(get_proxy_status)
STATUS_STR="apt-cacher server proxy is currently $proxystatus"
TEST_STR="  Test with 'sudo apt update'."
# Exit early if the user just wants to obtain the proxy status
if [ "$1" = "status" ] || [ "$1" = "s" ]; then
    echo -e "${STATUS_STR}\n${TEST_STR}"
    exit
fi

# Toggle the apt-cacher proxy
if [ "$proxystatus" = "ENABLED" ]; then
    echo -e "${STATUS_STR}; DISABLING PROXY"
    sudo mv $PROXYFILE ${PROXYFILE}.bak
    echo -e "apt-cacher proxy DISABLED\n${TEST_STR}"
    proxystatus="DISABLED"
else 
    echo -e "${STATUS_STR}; ENABLING PROXY"
    sudo mv ${PROXYFILE}.bak $PROXYFILE
    echo -e "apt-cacher proxy ENABLED\n${TEST_STR}"
    proxystatus="ENABLED"
fi

# Optional pop-up GUI window which auto-closes in a couple seconds
# zenity --info --text "apt-cacher-server-proxy $proxystatus" --timeout=2


