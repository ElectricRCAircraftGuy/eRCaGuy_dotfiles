#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Added to eRCaGuy_dotfiles by Gabriel Staples in 2023. Originally written by Liam Staskawicz
# (see below), and added to this repo with his permission. The purpose of this script is to make it
# easy to switch between various versions of gcc on your build machine.

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
#   set_up_gcc_alternatives.sh 8
#   set_up_gcc_alternatives.sh 9
#   set_up_gcc_alternatives.sh 10
#   set_up_gcc_alternatives.sh 11
#
# REFERENCES:
# 1. Google search for "set up gcc alternatives" -
# https://www.google.com/search?q=set+up+gcc+alternatives&oq=set+up+gcc+alternatives&aqs=chrome..69i57.2997j0j9&sourceid=chrome&ie=UTF-8
# 1. https://linuxconfig.org/how-to-switch-between-multiple-gcc-and-g-compiler-versions-on-ubuntu-20-04-lts-focal-fossa


set -eu

# accept version from first arg, default to 8
ACTIVE_GCC_VERSION=${1:-8}

echo "**********************"
echo "* Current GCC version"
echo "**********************"
gcc --version

add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt-get update -y

# install gcc versions of interest
apt install -y \
    build-essential \
    software-properties-common \
    manpages-dev \
    gcc-8 g++-8 \
    gcc-9 g++-9 \
    gcc-10 g++-10 \
    gcc-11 g++-11

for i in {8..11}
  do
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-"$i" "$i" \
        --slave /usr/bin/g++ g++ /usr/bin/g++-"$i" \
        --slave /usr/bin/gcov gcov /usr/bin/gcov-"$i"
done

# set active version - select a different version as needed
update-alternatives --set gcc "$(update-alternatives --list gcc | grep gcc-$ACTIVE_GCC_VERSION)"

echo "**********************"
echo "* Selected GCC version"
echo "**********************"
gcc --version
