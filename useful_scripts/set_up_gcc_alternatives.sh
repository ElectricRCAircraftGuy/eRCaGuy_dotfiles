#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Added to eRCaGuy_dotfiles by Gabriel Staples in 2023. Originally written by Liam Staskawicz
# (see below), and added to this repo with his permission. The purpose of this script is to make it
# easy to switch between various versions of gcc on your build machine.
#
# INSTALLATION:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -si "${PWD}/set_up_gcc_alternatives.sh" ~/bin/set_up_gcc_alternatives     # required
#           ln -si "${PWD}/set_up_gcc_alternatives.sh" ~/bin/gs_set_up_gcc_alternatives  # optional; replace "gs" with your initials
#           . ~/.profile
# 2. Run it
#           set_up_gcc_alternatives
#           # or
#           gs_set_up_gcc_alternatives
#
# TODO:
# 1. [ ] Don't do the full PPA installation and `update-alternatives --install` commands each time.
# Rather, do them *once*. Then, on subsequent calls, simply set the new version with `sudo
# update-alternatives --set` or whatever, and be done. You can either use a temporary flag file
# in /tmp to test for previous runs, or store a more-permanent flag file in the user's home dir or
# something. Also, if the user is calling to set the new gcc version to the currently-set gcc
# version, then of course there's nothing more to do, so just print a statement saying that, and
# exit.


# Originally By Liam Staskawicz
# 2022
# - https://github.com/liamstask
# - https://www.linkedin.com/in/liamstaskawcz/
#
# DESCRIPTION:
# Install multiple GCC versions, with the ability to switch which one is active system-wide via
# `update-alternatives` executable.
#
# USAGE:
#   set_up_gcc_alternatives.sh <GCC_VERSION_TO_ACTIVATE>
#
# Currently-supported versions are 8, 9, 10, 11.
#
# EXAMPLES:
#   set_up_gcc_alternatives.sh     # set to gcc/g++ version 8
#   set_up_gcc_alternatives.sh 8   # set to gcc/g++ version 8
#   set_up_gcc_alternatives.sh 9   # set to gcc/g++ version 9
#   set_up_gcc_alternatives.sh 10  # set to gcc/g++ version 10
#   set_up_gcc_alternatives.sh 11  # set to gcc/g++ version 11
#
# REFERENCES:
# 1. Google search for "set up gcc alternatives" -
# https://www.google.com/search?q=set+up+gcc+alternatives&oq=set+up+gcc+alternatives&aqs=chrome..69i57.2997j0j9&sourceid=chrome&ie=UTF-8
# 1. https://linuxconfig.org/how-to-switch-between-multiple-gcc-and-g-compiler-versions-on-ubuntu-20-04-lts-focal-fossa


set -eu

# accept version from first arg, >>defaults to 8<<
ACTIVE_GCC_VERSION=${1:-8}

echo "**********************"
echo "* Current GCC version"
echo "**********************"
echo "gcc:  $(gcc --version)"
echo "g++:  $(g++ --version)"
echo "gcov: $(gcov --version)"
echo ""

echo "**********************"
echo "INSTALLING PPAS:"
echo "**********************"
echo ""

sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update -y

# Install gcc versions of interest

# 1. For earlier versions of Ubuntu
# apt install -y \
#     build-essential \
#     software-properties-common \
#     manpages-dev \
#     gcc-8 g++-8 \
#     gcc-9 g++-9 \
#     gcc-10 g++-10 \
#     gcc-11 g++-11

# 2. For Ubuntu 22.04
# NB: gcc-8/g++-8 can only be installed on Ubuntu 22.04 if done manually. See:
# https://askubuntu.com/a/1446899/327339
# So, let's remove that one. YOU MUST GO MANUALLY INSTALL gcc-8/g++-8 per the answer above!
sudo apt install -y \
    build-essential \
    software-properties-common \
    manpages-dev \
    gcc-9 g++-9 \
    gcc-10 g++-10 \
    gcc-11 g++-11

for i in {8..11}
  do
    sudo update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-"$i" "$i" \
        --slave /usr/bin/g++ g++ /usr/bin/g++-"$i" \
        --slave /usr/bin/gcov gcov /usr/bin/gcov-"$i"
done

# set active version - select a different version as needed
sudo update-alternatives --set gcc "$(update-alternatives --list gcc | grep gcc-$ACTIVE_GCC_VERSION)"

echo ""
echo "**********************"
echo "* Selected GCC version"
echo "**********************"
echo "gcc:  $(gcc --version)"
echo "g++:  $(g++ --version)"
echo "gcov: $(gcov --version)"
