#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Author: Gabriel Staples
# 2023 (ideated 2019)

# DESCRIPTION:
#
# Recursively find all **absolute** symlinks in a directory and replace them with **relative** ones.
#
# This is particularly useful when you want to share a directory with someone else when that
# directory contains symlinks. If they are absolute symlinks, they will break on the next person's
# computer because that person has a different username, and hence a different home directory path,
# than you, breaking the symlink. If they are relative symlinks, however, they will be fine. This
# script is handy, therefore, to quickly find all absolute symlinks and replace them with relative
# ones.

# STATUS: wip

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -si "${PWD}/fix_broken_symlinks.sh" ~/bin/fix_broken_symlinks     # required
#           ln -si "${PWD}/fix_broken_symlinks.sh" ~/bin/gs_fix_broken_symlinks  # optional; replace "gs" with your initials
#           . ~/.profile  # re-source your bash profile to ensure ~/bin gets added to your PATH
# 2. Run it
#           fix_broken_symlinks --help
#           # or
#           gs_fix_broken_symlinks --help

# REFERENCES:
# 1. ChatGPT - I got a start on this by asking ChatGPT: "How can I write a linux script in bash to
# replace all absolute symlinks in a directory with relative ones?"
# 1. General bash program template I wrote:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh

# TODO list:
# 1. [ ]


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="true"  # "true" or "false"; can also be passed in as an option: `-d` or `--debug`

SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="'$SCRIPT_NAME' version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

HELP_STR="\
$VERSION_SHORT_STR

Find all broken symlinks in directory 'dir', then extract the target paths they point to, search
those paths for 'find_regex', and replace those findings with 'replacement_string'. Finally,
recreate the symlinks as relative symlinks with those replacements to the target paths in place.

If the 'find_regex' and 'replacement_string' are not provided, it will simply find and print out the
broken symlinks as they currently are.

All runs are dry-runs unless you use '--force'.

USAGE
    $SCRIPT_NAME [options] <dir> [<find_regex> <replacement_string>]

OPTIONS
    -h, -?, --help
        Print help menu
    -v, --version
        Print version information.
    --run_tests
        Run unit tests.
    -d, --debug
        Turn on debug prints.
    -f, --force
        Actually do the symlink replacements. With*out* this option, all runs are dry runs.

EXAMPLE USAGES: //////////

    $SCRIPT_NAME -h
        Print help menu.
    $SCRIPT_NAME --help
        Print help menu.
    $SCRIPT_NAME .
        Do a dry-run test of replacing all absolute symlinks in the current path ('.') with relative
        symlinks.
    $SCRIPT_NAME -f .
        Actually do the symlink replacements in the current dir.
    $SCRIPT_NAME ~/some_dir
        Dry-run replace symlinks in ~/some_dir.
    $SCRIPT_NAME --force ~/some_dir
        Actually do the symlink replacements in this dir.

Note: to just find and replace absolute symlinks with relative symlinks, use the 'symlinks' tool
instead:

    sudo add-apt-repository universe && sudo apt update && sudo apt install symlinks
        Install the 'symlinks' utility in Ubuntu.
        See: https://www.makeuseof.com/how-to-find-and-fix-broken-symlinks-in-linux/
    symlinks -rsvt . | grep '^changed'
        <==============
        See just which links would be "changed" if you ran with '-c'.
    symlinks -rsvc .
        <==============
        CAUTION!: THIS ACTUALLY CHANGES SYMLINKS ON YOUR SYSTEM!
        Convert all "absolute" symlinks to "relative", and reduce/clean up any "messy" or "lengthy"
        symlinks as well. Note: this can NOT fix broken or "dangling" symlinks. That requires
        manual intervention from a human.

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

# A function to do echo-style debug prints only if `DEBUG_PRINTS_ON` is set to "true".
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        echo "$@"
    fi
}

echo_error() {
    printf "%s" "ERROR: "
    echo "$@"
}

# A function to do printf-style debug prints only if `DEBUG_PRINTS_ON` is set to "true".
printf_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        # See: https://github.com/koalaman/shellcheck/wiki/SC2059
        # shellcheck disable=SC2059
        printf "$@"
    fi
}

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Unit Tests
# Cmd: `<this_script_name> --run_tests`
run_tests() {
    echo "Running unit tests [none yet]."
    echo "You can have your unit test file source this script using" \
         "'. \"$SCRIPT_NAME\"' to then be able to call and test each of its functions."
    # Fill this in. Ex: call `my_unit_tests.sh`
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

# Print a regular bash "indexed" array, passed by reference, only if `DEBUG_PRINTS_ON` is set
# to "true".
print_array_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        print_array "$1"
    fi
}

parse_args() {
    # For advanced argument parsing help and demo, see:
    # https://stackoverflow.com/a/14203146/4561887

    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        exit $RETURN_CODE_ERROR
    fi

    # All possible input arguments we expect to see.

    DEBUG_PRINTS_ON="false"
    FORCE_ON="false"  # set to true to actually do the replacements, false for a dry run

    ALL_ARGS_ARRAY=("$@")  # See: https://stackoverflow.com/a/70572787/4561887
    POSITIONAL_ARGS_ARRAY=()
    while [ $# -gt 0 ]; do
        arg="$1"
        # get first letter of `arg`; see: https://stackoverflow.com/a/10218528/4561887
        # This is a form of bash "array slicing", treating the string like an array of chars,
        # so see also my answer about array slicing here:
        # https://unix.stackexchange.com/a/664956/114401
        first_letter="${arg:0:1}"

        case $arg in
            # Help menu
            "-h"|"-?"|"--help")
                print_help
                exit $RETURN_CODE_SUCCESS
                ;;
            # Version
            "-v"|"--version")
                print_version
                exit $RETURN_CODE_SUCCESS
                ;;
            # Unit tests
            "--run_tests")
                run_tests
                exit $RETURN_CODE_SUCCESS
                ;;
            # Debug prints on
            "-d"|"--debug")
                echo_debug "Debug on."
                DEBUG_PRINTS_ON="true"
                shift # past argument
                ;;
            # Force the symlinks replacements
            "-f"|"--force")
                echo_debug "force passed in"
                FORCE_ON="true"
                shift # past argument
                ;;
            # All positional args (ie: unmatched in the switch cases above)
            *)
                # error out for any unexpected options passed in
                if [ "$first_letter" = "-" ]; then
                    echo_error "Invalid optional argument ('$1'). See help menu for valid options."
                    exit $RETURN_CODE_ERROR
                fi

                POSITIONAL_ARGS_ARRAY+=("$1")  # save positional arg into array
                shift # past argument (`$1`)
                ;;
        esac
    done

    DIR="${POSITIONAL_ARGS_ARRAY[0]}"
    FIND_REGEX="${POSITIONAL_ARGS_ARRAY[1]}"
    REPLACEMENT_STR="${POSITIONAL_ARGS_ARRAY[2]}"

    # Do debug prints of all argument stats

    all_args_array_len="${#ALL_ARGS_ARRAY[@]}"
    echo_debug "Total number of args = $all_args_array_len"
    echo_debug "ALL_ARGS_ARRAY contains:"
    print_array_debug ALL_ARGS_ARRAY
    echo_debug ""

    positional_args_array_len="${#POSITIONAL_ARGS_ARRAY[@]}"
    echo_debug "Number of positional args = $positional_args_array_len"
    echo_debug "POSITIONAL_ARGS_ARRAY contains:"
    print_array_debug POSITIONAL_ARGS_ARRAY
    echo_debug ""
    echo_debug "DIR = '$DIR'"
    echo_debug "FIND_REGEX = '$FIND_REGEX'"
    echo_debug "REPLACEMENT_STR = '$REPLACEMENT_STR'"
    echo_debug ""
} # parse_args

# Check arguments and print errors and exit if any critical ones are invalid
check_if_arguments_are_valid() {
    if [ $positional_args_array_len -lt 1 ]; then
        echo_error "Not enough arguments. See help menu ('-h') for usage."
        exit $RETURN_CODE_ERROR
    fi

    echo_debug "All args are fine."
}

# Exit if the last command failed.
exit_if_last_command_failed() {
    error_code="$?"
    if [ "$error_code" -ne 0 ]; then
        echo_error "Last command failed with error code $error_code."
        exit $RETURN_CODE_ERROR
    fi
}

# Print and run the passed-in command
# USAGE:
#       cmd_array=(ls -a -l -F /)
#       print_and_run_cmd cmd_array
# See:
# 1. My answer on how to pass regular "indexed" and associative arrays by reference:
#    https://stackoverflow.com/a/71060036/4561887 and
# 1. My answer on how to pass associative arrays: https://stackoverflow.com/a/71060913/4561887
# 1. ***** This answer to me which tells me to **run `shellcheck`** on my bash script to fix it!:
#    https://stackoverflow.com/a/71118015/4561887
# 1. See also my comment here:
#    https://stackoverflow.com/questions/71117953/how-to-write-bash-function-to-print-and-run-command-when-the-command-has-argumen/71118445?noredirect=1#comment125716247_71118015
# 1. My answer to my follow-up question here: Bash: how to print and run a cmd array which has
#    the pipe operator, |, in it: https://stackoverflow.com/a/71151092/4561887
print_and_run_cmd() {
    local -n array_reference="$1"
    echo "Running cmd:  ${array_reference[*]}"
    # run the command by calling all elements of the command array at once
    "${array_reference[@]}"
}

main() {
    echo_debug "Running 'main'."
    check_if_arguments_are_valid

    broken_symlinks_str="$(find "$DIR" -xtype l)"
    # Convert string to array; see my answer: https://stackoverflow.com/a/71575442/4561887
    IFS=$'\n' read -r -d '' -a broken_symlinks_array <<< "$broken_symlinks_str"

    broken_symlinks_count="${#broken_symlinks_array[@]}"
    echo -e "$broken_symlinks_count broken symlinks found!\n"

    if [ "$FORCE_ON" = "false" ]; then
        echo "****************************************************"
        echo "Dry run--no replacements made."
        echo "****************************************************"
    else
        echo "****************************************************"
        echo "'--force' is on! Writing new **relative** symlinks!"
        echo "****************************************************"
    fi
    echo ""

    i=0
    for symlink_path in "${broken_symlinks_array[@]}"; do
        ((i++))
        echo "$i/$broken_symlinks_count:"

        old_target_path="$(readlink "$symlink_path")"
        echo "OLD: '$symlink_path' -> '$old_target_path'"

        if [ "$positional_args_array_len" -eq 3 ]; then
            # we have the FIND_REGEX and REPLACEMENT_STR args too, so do the replacement!
            new_target_path="$(sed "s|$FIND_REGEX|$REPLACEMENT_STR|")"
            echo "NEW: '$symlink_path' -> '$new_target_path'"
        fi

        if [ "$FORCE_ON" = "true" ]; then
            ln -svrf "$new_target_path" "$symlink_path"
        fi

        echo ""
    done

    if [ "$FORCE_ON" = "false" ]; then
        echo "****************************************************"
        echo "Dry run--no replacements made."
        echo "****************************************************"
    else
        echo "****************************************************"
        echo "'--force' is on! New **relative** symlinks written!"
        echo "****************************************************"
    fi
    echo ""

} # main

# Set the global variable `run` to "true" if the script is being **executed** (not sourced) and
# `main` should run, and set `run` to "false" otherwise. One might source this script but intend
# NOT to run it if they wanted to import functions from the script.
# See:
# 1. my answer: https://stackoverflow.com/a/70662049/4561887
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/check_if_sourced_or_executed.sh
run_check() {
    # This is akin to `if __name__ == "__main__":` in Python.
    if [ "${FUNCNAME[-1]}" == "main" ]; then
        # This script is being EXECUTED, not sourced
        run="true"
    fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Main program entry point
# ----------------------------------------------------------------------------------------------------------------------

# Only run main function if this file is being executed, NOT sourced.
run="false"
run_check
if [ "$run" == "true" ]; then
    parse_args "$@"
    time main
    # Explicitly exit after `main` to prevent any code from running afterwards
    # in case someone modifies this script and adds more code below.
    # See: https://unix.stackexchange.com/a/449508/114401
    exit $RETURN_CODE_SUCCESS
fi
