#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
# 
# Gabriel Staples
# Sept. 2024
#
# Run this installer before running the "Example Program Launcher"
# `example_program_launcher.desktop` Desktop launcher file in order to make it work.
#

echo "\"Installing\" example_program.sh into '~/Downloads' by making a symlink to it there."

mkdir -p ~/Downloads
ln -sir "$(pwd)/example_program.sh" ~/Downloads

echo "Done."
