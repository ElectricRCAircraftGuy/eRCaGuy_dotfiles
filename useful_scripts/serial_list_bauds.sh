#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# gabrielstaples.com
# 10 Oct. 2022

# I copied and then modified "@F. Hauri - Give Up GitHub's" code
# [here](https://superuser.com/a/1482079/425838)

# List all baud rates of a particular serial device, or of all serial devices.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/serial_list_bauds.sh" ~/bin/serial_list_bauds     # required
#       ln -si "${PWD}/serial_list_bauds.sh" ~/bin/gs_serial_list_bauds  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these ways:
#   1. `serial_list_bauds`
#   1. `gs_serial_list_bauds`


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

SCRIPT_NAME="$(basename "$0")"

HELP_STR="\
List all baud rates for a specified serial device, OR for all serial devices.

Usage:
    $SCRIPT_NAME [/dev/<some_device>]
Examples
    $SCRIPT_NAME
        List all baud rates for ALL serial devices
    $SCRIPT_NAME /dev/ttyUSB0
        List all baud rates just for device \"/dev/ttyUSB0\"

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
By Gabriel Staples
Borrowed and modified from: \"@F. Hauri - Give Up GitHub's\" code here:
https://superuser.com/a/1482079/425838
"

print_help() {
    echo "$HELP_STR"
}

# For one serial device TODO: clean up this code to be `shellcheck` compliant and to be readable and
# understandable by myself as well.
print_bauds() {
    serial_device="$1"
    echo -e "Listing all baud rates of serial device \"$serial_device\".\n"

    hfile=/usr/include/asm-generic/termbits.h ans=(yes no);column < <(
        while read -r bauds;do
            stty -F "$serial_device" $bauds &>/dev/null
            printf '%8d %-3s\n' $bauds ${ans[$?]}
        done < <(
      sed -r 's/^#define\s+B([0-9]{2,})\s+.*/\1/p;d' <$hfile ))
}

# For ALL serial devices TODO: clean up this code to be `shellcheck` compliant and to be readable
# and understandable  by myself as well.
print_all_bauds() {
    echo -e "Listing all baud rates of ALL serial devices.\n"

    devs=(/dev/tty?*) devs=(${devs[@]##*/}) devs=(${devs[@]%tty[0-9]*})
    ans=yes hfile=/usr/include/asm-generic/termbits.h
    for dev in ${devs[@]};do
        echo "[ $dev ]"
        column < <(
            while read -r bauds;do
                stty -F /dev/$dev $bauds &>/dev/null
                printf '%8d %-3s\n' $bauds ${ans[$?]:-no}
            done < <(
      sed -r 's/^#define\s+B([0-9]{2,})\s+.*/\1/p;d' <$hfile ))
    done
}

serial_list_bauds() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        print_help
        exit $RETURN_CODE_SUCCESS
    fi

    if [ "$#" -gt 1 ]; then
        echo -e "Error: invalid number of arguments. Expects 0 or 1 arguments.\n"
        print_help
        exit $RETURN_CODE_ERROR
    elif [ "$#" -eq 1 ]; then
        print_bauds "$1"
    else # arg count = 0
        print_all_bauds
    fi
}

# Main program entry point
serial_list_bauds "$@"

