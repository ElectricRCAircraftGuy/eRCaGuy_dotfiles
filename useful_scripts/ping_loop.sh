#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Ping continually until the device responds.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/ping_loop.sh" ~/bin/gs_ping_loop
#       ln -si "${PWD}/ping_loop.sh" ~/bin/ping_loop
# 2. Now you can use the `ping_loop` or `gs_ping_loop` command directly anywhere you like. This
# assumes `~/bin` is in your `PATH`. If using Ubuntu and this is the first time creating `~/bin`,
# you may need to log out and log back in for your `~/.profile` file to make this take effect
# because it will automatically add that dir to your path.

# References:
# 1. [my own answer with this very code]
#    https://unix.stackexchange.com/questions/678045/equivalent-of-ping-o-on-linux/678191#678191
# 1. [someone else's answer]
#    https://unix.stackexchange.com/questions/678045/equivalent-of-ping-o-on-linux/678144#678144

# See also:
# 1. The 3 answers here, my own included, on how to turn an IP address's "pingability" on and off.
# This allows you to test this `ping_loop` script:
# https://unix.stackexchange.com/questions/678162/how-to-create-ethernet-interface-at-a-specific-ip-address-that-i-can-ping-and-fo

# Example usage:
# Ping 10.0.0.1 forever until it responds (like MacOs's `ping -o 10.0.0.1`):
#       ping_loop 10.0.0.1


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1
RETURN_CODE_CTRL_C=2  # Ctrl + C was pressed

IP_ADDR="$1"
if [ -z $IP_ADDR ]; then
    echo "You must enter the IP Address as the first parameter!"
    exit $RETURN_CODE_ERROR
fi

# TODO: WRAP THE STUFF BELOW IN A FUNCTION!

# Capture the Ctrl + C command and specify what to do when it is pressed. This allows us to exit
# the otherwise unexitable infinite while loop by pressing Ctrl + C!
# See [see my comments under this answer too!]: https://serverfault.com/a/105390/357116
trap 'printf "%s\n" "Ctr + C"; exit $RETURN_CODE_CTRL_C' SIGINT

count=0
while true; do
    echo "Attempt: $count"
    ((count++))
    ping -c 1 -W 2 "$IP_ADDR"

    return_code=$?
    # Exit if the IP address is alive and responding to the ping, so the return code is 0,
    # indicating "no error"
    if [ $return_code -eq 0 ]; then
        echo "== DEVICE AT IP '$IP_ADDR' IS ALIVE! =="
        break;
    fi
done


# A MORE-SIMPLE FORM!

# IP_ADDR="$1"
# if [ -z $IP_ADDR ]; then
#     echo "You must enter the IP Address as the first parameter!"
#     exit 1
# fi

# # to enable Ctrl + C inside the infinite while loop
# trap 'printf "%s\n" "Ctr + C"; exit 2' SIGINT
# count=0
# while true; do
#     echo "Attempt: $count"
#     ((count++))
#     ping -c 1 -W 1 "$IP_ADDR"
#     return_code=$?
#     if [ $return_code -eq 0 ]; then
#         echo "== DEVICE AT IP '$IP_ADDR' IS ALIVE! =="
#         break;
#     fi
# done


# 1-LINE VERSION OF THE CMD ABOVE
# This only sort-of works! I can't figure out why, but `trap` doesn't seem to be working below, so
# Ctrl + C doesn't work during the loop!

# IP_ADDR="10.0.0.1"; trap 'printf "%s\n" "Ctr + C"; exit 2' SIGINT; count=0; while true; do echo "Attempt: $count"; ((count++)); \
# ping -c 1 -W 1 "$IP_ADDR"; return_code=$?; if [ $return_code -eq 0 ]; then echo "== DEVICE AT IP '$IP_ADDR' IS ALIVE! =="; break; fi done
