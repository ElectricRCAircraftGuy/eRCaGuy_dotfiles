#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Mar. 2022

# DESCRIPTION:
#
# This is an example program to show how you can easily back up files from a remote server to your
# local machine using the `back_up_remote_files.sh` script.

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

foldername="my_backup_dir1"
login_info="username@192.168.0.1"
# Files to back up from remote to `local_backup_dir`, defined below
files_array=(
    ".bash_aliases"
    ".bashrc"
    ".profile"
)
local_backup_dir="$SCRIPT_DIRECTORY/$foldername"
back_up_remote_files "$local_backup_dir" "$login_info" "${files_array[@]}"


