#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Mar. 2022

# DESCRIPTION:
#
# Back up a few files from a remote server. For backing up a lot of files, use `rsync`, NOT `scp`!
# ie: quit using this script altogether, OR update it to use `rsync` and a file list passed to it
# of files to back up.

# INSTALLATION INSTRUCTIONS:
# See "eRCaGuy_dotfiles/useful_scripts/README.md#installation-instructions" for generic
# installation instructions

# Usage format:
#       back_up_remote_files <local_backup_dir> <ssh_login_info> file1 file2 file3 ...
# Ex:
#       back_up_remote_files ######


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

# ------------------
# Parse arguments
# ------------------

if [ "$#" -lt 3 ]; then
    echo "Insufficient number of arguments. 3 expected. $# provided."
    exit $RETURN_CODE_ERROR
fi

local_backup_dir="$1"
login_info="$2"
declare -n files_array_reference="$3"

# Add the date to the end of the local backup dir, as a folder
foldername="$(date +"%Y%m%d-%H%M_%Shrs")"

local_backup_dir="${local_backup_dir}/${foldername}"
mkdir -p "$local_backup_dir"

if [ "${#files_array_reference[@]}" -eq 0 ]; then
    echo "No elements found in files array."
    exit $RETURN_CODE_ERROR
fi

# ------------------
# Do the backups!
# ------------------

progress_bar="10%..20%..30%..40%..50%..60%..70%..80%..90%..100%"
num_chars_in_progress_bar="${#progress_bar}"
echo "num_chars_in_progress_bar = $num_chars_in_progress_bar"  # debugging

echo "Progress: "
for file in "${files_array_reference[@]}"; do
    # NB: this assumes that all files in the files array are in your home (~) dir!
    # scp "$login_info":~/"$file" "$local_backup_dir"
done
