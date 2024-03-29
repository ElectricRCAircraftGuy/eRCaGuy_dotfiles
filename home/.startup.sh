#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# DESCRIPTION:
#
# This is a "startup" script intended to be run on an ephemeral remote machine or virtual desktop
# (ex: running in Google Cloud or Amazon Web Services or Microsoft Azure or something) or whatever,
# in order to configure your desktop environment, and install and set up necessary tools, each time
# you construct a new instance of your virtual machine or desktop and boot it for the first time.
#
#
# HOW TO GET THIS SCRIPT TO AUTO-RUN AT BOOT:
#
# *How* exactly you get this script to run is up to you and your particular remote setup. Examples
# may include:
#
# 1. Call it in a hook script of some sort provided by your virtual machine provider. Ex: perhaps
# your virtual machine provider has a script at "~/.login_hooks/run_at_boot.sh", which runs every
# time the remote virtual machine is booted. In that case, add a call there to run this script:
#
#       echo "Running Gabriel's custom startup script at ~/.startup.sh"
#       ~/.startup.sh
#
# 1. Call or source it in your ~/.bashrc file so that it gets run each time a shell is loaded or
# reset. NB: if you do this approach, you should also add to the top of this script to create some
# temporary file at "/tmp/startup_script_has_run" or something, and only run the script fully if
# that file does *not* yet exist. This way, you do NOT run these heavy `apt install` commands once
# per shell, but rather, once per boot, since everything in "/tmp" gets automatically erased
# (I believe) at each reboot. Here is some *untested* code to get started with that:
#
#       #!/usr/bin/env bash
#
#       RETURN_CODE_SUCCESS=0
#       RETURN_CODE_ERROR=1
#
#       if [ -f /tmp/startup_script_has_run ]; then
#           echo "Startup script has already run. Nothing to do. Exiting."
#           exit $RETURN_CODE_SUCCESS
#       else
#           # create the file
#           touch /tmp/startup_script_has_run
#           echo "Running the startup script for the first time since boot."
#           # Now the code below *will* be run!
#       fi
#
# Something similar to the above is how I auto-start my ssh-agent on remote ssh-only machines. See:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home/.ssh#auto-starting-the-the-ssh-agent-on-a-remote-ssh-based-development-machine
#
# 1. Just manually call the script after you login:
#
#       ~/.startup.sh
#
# 1. Add the script to some other startup file, such as "/etc/rc.local". See here for what that file
# looks like: https://askubuntu.com/a/895124/327339
#
#
# INSTRUCTIONS:
# 1. Copy this script to your home dir:
#       cd path/to/here
#       cp -i .startup.sh ~
# 2. Edit and customize the copy in your home dir. The contents below are ideas to get you started.
# 3. Get the script to auto-run at startup. See some ideas above.

starting_dir="$(pwd)"

# See my answer: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

# Copied from my code here:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/sound_bell_lib.sh
#
# Description:
# Play the bell sound "ding" to alert the user of something.
#
# Usage:
#       sound_bell [number_of_times [second_delay_between_sounds]]
# Examples
#       sound_bell          # sound bell once
#       sound_bell 1        # sound bell once
#       sound bell 2        # sound bell 2x with default delay between each
#       sound bell 2 .2     # sound bell 2x with delay of 0.2 sec between each
#       sound bell 3 .5     # sound bell 3x with delay of 0.5 sec between each
sound_bell() {
    # set default values
    num_times="1"
    delay_sec="0.12"

    # set to user-defined values if the user passes them in as args
    if [ -n "$1" ]; then
        num_times="$1"
    fi
    if [ -n "$2" ]; then
        delay_sec="$2"
    fi

    # sound the bell
    for (( i=0; i<"$num_times"; i++ )); do
        printf "%b" "\a"  # bell sound

        # Only sleep the delay time **between** bell sounds, and NOT after the last one
        # - for how to do arithmetic expansion (math in Bash), see my answer here:
        #   https://stackoverflow.com/a/71567705/4561887
        if [ "$i" -lt "$((num_times-1))" ]; then
            sleep "$delay_sec"
        fi
    done
}

# Note: write this to both stdout *and* stderr; see: https://stackoverflow.com/a/6852984/4561887
echo -e "\n\n======================== SETTING UP NEW VIRTUAL MACHINE ===========================" | tee /dev/stderr
echo -e "======================== RUNNING ~/.startup.sh ====================================\n" | tee /dev/stderr
echo -e "Script path = '$FULL_PATH_TO_SCRIPT'" | tee /dev/stderr

echo "Time     is $(date)." | tee /dev/stderr
echo "Setting timezone." | tee /dev/stderr
# sudo timedatectl set-timezone America/Los_Angeles
sudo timedatectl set-timezone America/Phoenix
echo "Time is now $(date)." | tee /dev/stderr

echo "Installing various apt packages."
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    g++-9 \
    gcc-9 \
    libncurses-dev \
    pv \
    gnupg

echo "Making gcc-9/g++-9 the default compiler"
sudo ln -sf /usr/bin/gcc-9 /usr/bin/gcc
sudo ln -sf /usr/bin/g++-9 /usr/bin/g++
sudo ln -sf /usr/bin/gcov-9 /usr/bin/gcov

echo "Installing ripgrep"
# See: https://github.com/BurntSushi/ripgrep#installation
mkdir -p ~/Downloads/Install_Files
cd ~/Downloads/Install_Files
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb

echo "Time is now $(date)." | tee /dev/stderr
echo -e "\n\n======================== ~/.startup.sh FINISHED ===================================\n" | tee /dev/stderr
sound_bell 3 .2

cd "${starting_dir}"
