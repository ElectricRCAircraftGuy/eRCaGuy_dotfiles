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
# Example symbolic link commands to copy:
#       cd path/to/here
#       ln -si "${PWD}/back_up_remote_files.sh" ~/bin/back_up_remote_files
#       ln -si "${PWD}/back_up_remote_files.sh" ~/bin/gs_back_up_remote_files

# References:
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh

# Usage format:
# See help string below.


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1
RETURN_CODE_CTRL_C=2

# See also: https://stackoverflow.com/a/60157372/4561887
SCRIPT_NAME="$(basename "$0")"

DEBUG_PRINTS_ON="true"  # "true" or "false"

HELP_STR="\
Usage format:
      $SCRIPT_NAME <local_backup_dir> <ssh_login_info> <file1> [file2 file3 ...]
  Ex:
      $SCRIPT_NAME \"bak\" \"username@192.168.0.1\" \"file1.c\" \"file2.c\" \"file3.c\"
"

# A function to do echo-style debug prints only if `DEBUG_PRINTS_ON` is set to "true".
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        echo "$@"
    fi
}

print_help() {
    echo "$HELP_STR" | less -RFX
}

# Print a regular bash "indexed" array, passed by reference
# See:
# 1. my answer: https://stackoverflow.com/a/71060036/4561887 and
# 1. my answer: https://stackoverflow.com/a/71060913/4561887
print_array() {
    local -n array_reference="$1"

    if [ "${#array_reference[@]}" -eq 0 ]; then
        echo "No elements found."
    fi

    for element in "${array_reference[@]}"; do
        echo "  $element"
    done
}

# ------------------
# Parse arguments
# ------------------
parse_args() {
    if [ "$#" -lt 3 ]; then
        echo "Insufficient number of arguments. 3 or more expected. $# provided."
        print_help
        exit $RETURN_CODE_ERROR
    fi

    local_backup_dir="$1"
    login_info="$2"
    shift # past argument (`$1`)
    shift # past argument (`$2`)

    files_array=()
    while [ $# -gt 0 ]; do
        files_array+=("$1")
        shift # past argument (`$1`)
    done

    echo_debug "local_backup_dir = \"$local_backup_dir\""
    echo_debug "ssh login_info = \"$login_info\""

    echo "files to back up:"
    print_array files_array
}

# ------------------
# Do the backups!
# ------------------
main() {
    # Add the date to the end of the local backup dir, as a folder
    foldername="$(date +"%Y%m%d-%H%Mhrs_%Ssec")"

    local_backup_dir="${local_backup_dir}/${foldername}"
    mkdir -p "$local_backup_dir"

    num_files="${#files_array[@]}"
    if [ "$num_files" -eq 0 ]; then
        echo "No files to back up."
        exit $RETURN_CODE_ERROR
    fi

    progress_bar="00%..10%..20%..30%..40%..50%..60%..70%..80%..90%..100%"
    num_chars="${#progress_bar}"
    echo_debug "num_chars in progress bar = $num_chars"

    echo "Progress Bar:"
    echo "$progress_bar"
    files_copied=0
    dots_printed=0
    # Do the actual back up from remote to local!
    for file in "${files_array[@]}"; do
        # NB: this assumes that all files in the files array are in your home (~) dir!
        # TODO: consider parallelizing this in the future with multiple processes rather than only
        # doing it one process at a time!
        scp "$login_info":~/"$file" "$local_backup_dir"

        # Update the progress bar.
        ((files_copied++))
        percent_complete=$((files_copied*100/num_files))
        dots_to_have_printed=$((percent_complete*num_chars/100))
        # the output from `scp` above seems to overwrite this text, so start the progress bar over
        # each time by resetting it to zero here
        dots_printed=0
        while [ "$dots_printed" -lt "$dots_to_have_printed" ]; do
            printf "%s" "."
            ((dots_printed++))
        done
        echo ""
    done

    echo "Done! All files backed up."
}

# --------------------------------------------------------------------------------------------------
# Main program entry point
# --------------------------------------------------------------------------------------------------

# Capture the Ctrl + C command and specify what to do when it is pressed. This allows us to exit
# otherwise unexitable infinite while loops by pressing Ctrl + C!
# See [see my comments under this answer too!]: https://serverfault.com/a/105390/357116
trap 'printf "%s\n" "; Ctrl + C"; exit $RETURN_CODE_CTRL_C' SIGINT

parse_args "$@"
time main
