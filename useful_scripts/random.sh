#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Mar. 2022

# DESCRIPTION:
#
# Random number generator for bash. You can specify a range, and it will output a random number
# in that range--even a negative number if desired.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -si "${PWD}/random.sh" ~/bin/random     # required
#           ln -si "${PWD}/random.sh" ~/bin/gs_random  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like like in any of these ways:
#   1. `random`
#   2. `gs_random`

# REFERENCES:
# 1. [my own answer with this code]: https://stackoverflow.com/a/71388666/4561887
# 1. `man bash`, then search for "RANDOM"
# 1. How to generate random number in Bash?: https://stackoverflow.com/a/1195035/4561887


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

HELP_STR="\
Generate a random integer number according to the usage styles below.

USAGE STYLES:
    'random'
        Generate a random number from 0 to 32767, inclusive (same as bash variable 'RANDOM').
    'random <max>'
        Generate a random number from 0 to 'max', inclusive.
    'random <min> <max>'
        Generate a random number from 'min' to 'max', inclusive. Both 'min' and 'max' can be
        positive OR negative numbers, and the generated random number can be negative too, so
        long as the range (max - min + 1) is less than or equal to 32767. Max must be >= min.

This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
See: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/random.sh
"

print_help() {
    echo "$HELP_STR" | less -RFX
}

# Get a random number according to the usage styles above.
# See also `utils_rand()` in utilities.c:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/c/utilities.c#L176
random() {
    # PARSE ARGUMENTS

    # help menu
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        print_help
        exit $RETURN_CODE_SUCCESS
    fi

    # 'random'
    if [ $# -eq 0 ]; then
        min=0
        max="none"
    # 'random max'
    elif [ $# -eq 1 ]; then
        min=0
        max="$1"
    # 'random min max'
    elif [ $# -eq 2 ]; then
        min="$1"
        max="$2"
    else
        echo "ERROR: too many arguments."
        exit "$RETURN_CODE_ERROR"
    fi

    # CHECK FOR ERRORS

    if [ "$max" = "none" ]; then
        rand="$RANDOM"
        echo "$rand"
        exit "$RETURN_CODE_SUCCESS"
    fi

    if [ "$max" -lt "$min" ]; then
        echo "ERROR: max ($max) < min ($min). Max must be >= min."
        exit "$RETURN_CODE_ERROR"
    fi

    # CALCULATE THE RANDOM NUMBER

    # See `man bash` and search for `RANDOM`. This is a limitation of that value.
    RAND_MAX=32767

    range=$((max - min + 1))
    if [ "$range" -gt "$RAND_MAX" ]; then
        echo "ERROR: the range (max - min + 1) is too large. Max allowed = $RAND_MAX, but actual" \
             "range = ($max - $min + 1) = $range."
        exit "$RETURN_CODE_ERROR"
    fi

    # NB: `RANDOM` is a bash built-in variable. See `man bash`, and also here:
    # https://stackoverflow.com/a/1195035/4561887
    rand=$((min + (RANDOM % range)))
    echo "$rand"
}

# Set the global variable `run` to "true" if the script is being **executed** (not sourced) and
# `main` should run, and set `run` to "false" otherwise. One might source this script but intend
# NOT to run it if they wanted to import functions from the script.
# See:
# 1. *****https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
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
    random "$@"
fi
