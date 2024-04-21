#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Author: Gabriel Staples
# 2023 (ideated 2019; started ~16 Jan. 2023 or so; finished 18 Jan. 2023)

# DESCRIPTION:
#
# Recursively find all broken **absolute** symlinks in a directory and replace them with
# **relative** ones.
#
# This is particularly useful when you want to share a directory with someone else when that
# directory contains symlinks. If they are absolute symlinks, they will break on the next person's
# computer because that person has a different username, and hence a different home directory path,
# than you, breaking the symlink. If they are relative symlinks, however, they will be fine. This
# script is handy, therefore, to quickly find all absolute symlinks and replace them with relative
# ones.

# STATUS: done and works!

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
# 1. ***** See my answer with this script used in it, here:
#    https://unix.stackexchange.com/a/732315/114401

# SEE ALSO
# 1. MY ANSWER: Unix & Linux: Convert absolute symlink to relative symlink with simple Linux command
#    - https://unix.stackexchange.com/a/774298/114401

# TODO list:
# 1. [x] highlight "FINAL" links in bold blue if they are different from their "FIXED" links.
#    Nah...just highlight the whole "FINAL" line blue instead!


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.3.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="true"  # "true" or "false"; can also be passed in as an option: `-d` or `--debug`

# ANSI color codes
# See:
# 1. ***** https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# 1. "eRCaGuy_dotfiles/useful_scripts/ripgrep_replace/rgr.sh"
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-diffn.sh#L126-L138
# 1. https://github.com/GNOME/glib/blob/main/gio/gdbus-tool.c#L43-L50
# 1. *****+ https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/ansi_text_format_lib.sh
COLOR_GRN="\033[1;32m" # green bold
COLOR_BLU="\033[1;94m" # bright blue bold
# COLOR_BLU="\033[1;34m" # blue bold
# COLOR_MGN="\033[1;35m" # magenta bold
COLOR_OFF="\033[m"
COLOR_DISABLED=""

STARTING_DIR="$(pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="'$SCRIPT_NAME' version $VERSION"

VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

CHANGELOG="\
v0.3.0; 2023.04.22
    Changed
        - changed default behavior of running '$SCRIPT_NAME' to run '$SCRIPT_NAME .' (ie: analyze
          the current dir) instead of showing the help menu.

v0.2.0; 2023.01.20
    Added:
        - changelog, and '--changelog' option
        - color output
        - '--no_color' option
        - '--no_relative' option
        - 'FIXED' vs 'UNCHANGED' indicators when fixing links
    Fixed:
        - various bug fixes

v0.1.0; 2023.01.18
    Initial version
"

HELP_STR="\
$VERSION_SHORT_STR

USAGE
    $SCRIPT_NAME [options] <dir> [<find_regex> <replacement_string>]

DESCRIPTION

    Find all broken symlinks in directory 'dir', then extract the target paths they point to, search
    those paths for 'find_regex', and replace those findings with 'replacement_string'. Finally,
    recreate the symlinks as relative symlinks (see also: '--no_relative') with those
    replacements to the target paths in place.

    If the 'find_regex' and 'replacement_string' are not provided, it will simply find and print out
    the broken symlinks as they currently are.

    All runs are dry-runs unless you use '--force'.

OPTIONS
    -h, -?, --help
        Print help menu.
    -v, --version
        Print version information.
    --changelog
        Print the changelog.
    --run_tests
        Run unit tests.
    -d, --debug
        Turn on debug prints.
    -f, --force
        Actually do the symlink replacements. With*out* this option, all runs are dry runs.
    --no_color
        Turn color output off (may be helpful when scripting). Otherwise, color output is by default
        on.
    --no_relative
        Disable creating relative symlinks. Normally, the program creates only **relative** symlinks
        when repairing links. This disables that, leaving absolute symlinks as absolute if you wish.

EXAMPLE USAGES:

    $SCRIPT_NAME -h
        Print help menu.
    $SCRIPT_NAME --help
        Print help menu.
    $SCRIPT_NAME .
        Recursively find all broken symlinks in the current directory (.).
    $SCRIPT_NAME
        Same as above.
    $SCRIPT_NAME . '/home/gabriel/some/dir' 'home/john/some/dir'
        (Dry run) fix all broken symlinks in the current dir (.) by replacing their target paths
        with John's home dir instead of Gabriel's.
    $SCRIPT_NAME . '/home/gabriel/some/dir' 'home/john/some/dir' -f
        (Real run) fix all broken symlinks in the current dir (.) by replacing their target paths
        with John's home dir instead of Gabriel's. **Relative** symlinks will be created in the end.

NOTES:

1. To **automatically** find and replace absolute symlinks with relative symlinks, use
the 'symlinks' tool instead:

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

2. Other ways to find broken symlinks include the following. Search my document here for these
and other commands and notes:
https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/git%20%26%20Linux%20cmds%2C%20help%2C%20tips%20%26%20tricks%20-%20Gabriel.txt

    symlinks -rsv . | grep '^dangling'
    find . -xtype l

3. To find all symlinks and see which are relative and which are absolute, run:

    symlinks -rsv .

4. To **manually** replace any absolute symlink with a relative symlink, do the following. This is
also the best 'ln' command in my opinion when creating a brand new symlink:

    # NB: **All** of these options are important, and what I want. See 'man ln' for what each does.
    ln -svnri target_path symlink_path

5. To **automatically** replace all functional absolute symlinks with relative symlinks, use the
following command:

    symlinks -cr .


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
    # echo "$HELP_STR"
}

print_version() {
    echo "$VERSION_LONG_STR"
}

print_changelog() {
    echo "$CHANGELOG"
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
        echo "No arguments supplied. Run '$SCRIPT_NAME -h' for the help menu."
        echo "Running '$SCRIPT_NAME .' now."
        echo ""
        # set the first positional arg to accomplish this.
        # See my answer: https://stackoverflow.com/a/76081159/4561887
        set -- "."
    fi

    # All possible input arguments we expect to see.

    DEBUG_PRINTS_ON="false"
    FORCE_ON="false"  # set to true to actually do the replacements, false for a dry run
    COLOR_ON="true"
    RELATIVE_ON="true"

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
            # Changelog
            "--changelog")
                print_changelog
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
            # No color output
            "--no_color")
                echo_debug "no color"
                COLOR_ON="false"

                # disable the color codes
                COLOR_GRN="$COLOR_DISABLED"
                COLOR_BLU="$COLOR_DISABLED"
                COLOR_OFF="$COLOR_DISABLED"

                shift # past argument
                ;;
            # No relative (don't forcefully create relative symlinks)
            "--no_relative")
                echo_debug "no relative"
                RELATIVE_ON="false"
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
    echo_debug "Positional args:"
    echo_debug "  DIR = '$DIR'"
    echo_debug "  FIND_REGEX = '$FIND_REGEX'"
    echo_debug "  REPLACEMENT_STR = '$REPLACEMENT_STR'"
    echo_debug "Optional args:"
    echo_debug "  DEBUG_PRINTS_ON = '$DEBUG_PRINTS_ON'"
    echo_debug "  FORCE_ON = '$FORCE_ON'"
    echo_debug "  COLOR_ON = '$COLOR_ON'"
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

    broken_symlinks_str="$(find "$DIR" -xtype l | sort)"
    # Convert string to array; see my answer: https://stackoverflow.com/a/71575442/4561887
    IFS=$'\n' read -r -d '' -a broken_symlinks_array <<< "$broken_symlinks_str"

    broken_symlinks_count="${#broken_symlinks_array[@]}"
    echo -e "$broken_symlinks_count broken symlinks found!\n"

    if [ "$broken_symlinks_count" -eq 0 ]; then
        return $RETURN_CODE_SUCCESS
    fi

    if [ "$FORCE_ON" = "false" ]; then
        echo "------------------------------------------------------------------------"
        echo "This is a dry run of what *would* happen. No replacements actually made."
        echo "------------------------------------------------------------------------"
    else
        echo "************************************************************************"
        echo "'--force' is on! Writing new symlinks!"
        echo "************************************************************************"
    fi
    echo ""

    i=0
    for symlink_path in "${broken_symlinks_array[@]}"; do
        ((i++))
        printf "%5s/%-6s " "$i" "${broken_symlinks_count}:"

        old_target_path="$(readlink "$symlink_path")"
        echo "BROKEN   : '$symlink_path' -> '$old_target_path'"

        if [ "$positional_args_array_len" -eq 3 ]; then
            # we have the FIND_REGEX and REPLACEMENT_STR args too, so do the replacement!
            new_target_path="$(echo "$old_target_path" | sed "s|$FIND_REGEX|$REPLACEMENT_STR|")"

            if [ "$new_target_path" = "$old_target_path" ]; then
                PREFIX_LABEL="             UNCHANGED: "
                echo -e "${PREFIX_LABEL}'$symlink_path' ->"\
                        "'$new_target_path'"
            else
                # The link actually changed, so add highlighting when you print it, and
                # recreate the link.

                PREFIX_LABEL="             ${COLOR_GRN}FIXED${COLOR_OFF}    : "
                # also color/highlight the fixed target path
                echo -e "${PREFIX_LABEL}'$symlink_path' ->"\
                        "'${COLOR_GRN}${new_target_path}${COLOR_OFF}'"

                if [ "$FORCE_ON" = "true" ]; then
                    # NB:
                    # 1. **All** of these options are important, and what I want. See 'man ln' for
                    # what each does.
                    # 2. To ensure the relative symlink is written correctly in case it is to a
                    # directory, you must use `-n` as well! See the discussion beginning with my
                    # comment here:
                    # https://unix.stackexchange.com/questions/18360/how-can-i-relink-a-lot-of-broken-symlinks/18365?noredirect=1#comment1389639_18365
                    # See also its meaning in `man ln`.
                    if [ "$RELATIVE_ON" = "true" ]; then
                        ln_args="svnrf"
                    else
                        ln_args="svnf"
                    fi

                    # First, cd into the dir in which the symlink we are about to change is located,
                    # in order to avoid breaking relative symlinks!
                    #
                    # EXPLANATION:
                    #
                    # This is a bit nuanced, but basically, if you are in a directory at
                    # path "~/dir1", and you run `ln -svnrf ../dir2/some_file.pdf
                    # dir3/some_file.pdf`, then what you *want* is to create a symlink
                    # at "~/dir1/dir3/some_file.pdf" which points to relative
                    # path "../dir2/some_file.pdf" at absolute path "~/dir1/dir2/some_file.pdf",
                    # since you expect the relative path to be relative to the symlink's path.
                    #
                    # But, what you get instead is that the `ln` tool makes it relative to **the dir
                    # you are in when you _run_ the cmd!**--NOT the dir relative to the symlink
                    # path.
                    #
                    # In other words:
                    # When you run: `ln -svnrf ../dir2/some_file.pdf dir3/some_file.pdf`
                    # YOU GET:  ~/dir1/dir3/some_file.pdf -> ../../dir2/some_file.pdf [BROKEN LINK!]
                    # YOU WANT: ~/dir1/dir3/some_file.pdf -> ../dir2/some_file.pdf    [GOOD LINK!]
                    #
                    # SOLUTIONS:
                    # 1) remove `-r` and use the absolute style cmd instead:
                    #       ln -svnf ../dir2/some_file.pdf dir3/some_file.pdf
                    # or 2) cd into the lower dir first then run the command with `-r`:
                    #       cd dir3
                    #       ln -svnrf ../dir2/some_file.pdf some_file.pdf
                    #
                    # In both cases above, YOU NOW GET WHAT YOU WANT!:
                    #           ~/dir1/dir3/some_file.pdf -> ../dir2/some_file.pdf    [GOOD LINK!]
                    #
                    # Solution 2 is preferable, in my opinion, because it will properly convert
                    # absolute links into relative links at the same time, withOUT breaking the
                    # relative link. So, let's do that! Cd into the lower dir, run the cmd with
                    # `-r` and with the proper symlink path fixed (ie: using its filename only),
                    # then `cd` back up again.

                    symlink_path_dir="$(dirname "$symlink_path")"
                    symlink_path_file="$(basename "$symlink_path")"

                    cd "$symlink_path_dir"
                    # actually fix/recreate the symlink here!
                    output="$(ln "-$ln_args" "$new_target_path" "$symlink_path_file")"
                    cd "$STARTING_DIR"
                    echo_debug "output = $output"

                    fixed_link_target="$(readlink "$symlink_path")"
                    fixed_link_summary="'$symlink_path' -> '${COLOR_BLU}${fixed_link_target}${COLOR_OFF}'"

                    # Final result of 'ln'
                    printf "             %b    : %b\n"\
                        "${COLOR_BLU}FINAL${COLOR_OFF}" \
                        "$fixed_link_summary"
                fi
            fi
        fi
    done

    echo ""
    if [ "$FORCE_ON" = "false" ]; then
        echo "------------------------------------------------------------------------"
        echo "This is a dry run of what *would* happen. No replacements actually made."
        echo "------------------------------------------------------------------------"
    else
        echo "************************************************************************"
        echo "'--force' is on! New symlinks written!"
        echo "************************************************************************"
        echo ""
        echo "Run '$SCRIPT_NAME \"$DIR\"' one more time to check if any symlinks are"
        echo "still broken."
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
    exit $RETURN_CODE_SUCCESS
fi
