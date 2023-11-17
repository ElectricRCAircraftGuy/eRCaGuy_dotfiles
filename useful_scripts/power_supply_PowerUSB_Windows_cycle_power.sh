#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Nov. 2023

# DESCRIPTION:
#
# Cycle power, in Windows, on a PowerUSB device from here:
# https://pwrusb.com/collections/all
#
# This Bash script is meant to be run on Windows in a Linux-like terminal such
# as Git Bash or MSYS2. For my MSYS2 setup instructions, see here:
# https://stackoverflow.com/a/77407282/4561887.
#
# See also: "power_supply_PowerUSB_Windows_cycle_power_README.md"
#

echo "Power cycling all 3 outlets."

PwrUsbCmd="/c/Program Files (x86)/PowerUSB/PwrUsbCmd.exe"

echo "Power OFF."
"$PwrUsbCmd" 0 0 0  # outlet1 outlet2 outlet3  OFF
echo "Waiting for 4 seconds with the power OFF..."
sleep 4
echo "Power ON."
"$PwrUsbCmd" 1 1 1  # outlet1 outlet2 outlet3  ON

echo "Done."

# Keep the terminal window open
echo "Press any key to continue..."
read -n 1


# EXAMPLE RUN OUTPUT:
#
#       Power cycling all 3 outlets.
#       Power OFF.
#       PowerUSB Connected. Number of Devices:1 Model: 2. Version:3.3
#       Before Setting Port Status: 1 1 1
#       After Setting Port Status (unit1): 0 0 0
#       Waiting for 4 seconds with the power OFF...
#       Power ON.
#       PowerUSB Connected. Number of Devices:1 Model: 2. Version:3.3
#       Before Setting Port Status: 0 0 0
#       After Setting Port Status (unit1): 1 1 1
#       Done.
#       Press any key to continue...
