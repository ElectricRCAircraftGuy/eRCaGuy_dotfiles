#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Nov. 2023

# DESCRIPTION:
#
# Iteratively run `git difftool` on all commits going backwards from HEAD to the first commit, one
# commit at a time, to see the changes in each commit.

# INSTALLATION INSTRUCTIONS:
#
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#    Note that "gs" is my initials.
#    I do these versions with "gs_" in them so I can find all scripts I've written really easily
#    by simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab.
#
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-difft.sh" ~/bin/git-difft     # required
#       ln -si "${PWD}/git-difft.sh" ~/bin/git-gs_difft  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-difft.sh" ~/bin/gs_git-difft  # optional; replace "gs" with your initials
#
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#
#       git difft  <=== my preferred way to use this program, so it feels just like `git diff`!
#       git-difft
#       git gs_difft
#       git-gs_difft
#       gs_git-difft

# REFERENCES:
#
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
#    - a very advanced, general Bash program example.
# 1. GitHub Copilot helped me with the algorithm in `main()`.
# 1. "eRCaGuy_hello_world/bash/argument_parsing__3_advanced__gen_prog_template.sh" - for help 
#    parsing arguments. See:
#    https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
# 1. 
#

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.2.0"
AUTHOR="Gabriel Staples"

SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="'$SCRIPT_NAME' version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

HELP_STR="\
$VERSION_SHORT_STR

Iterate through all commits going backwards from HEAD to the first commit, one commit at a time,
running 'git difftool' on each one to see the changes it introduced.

- Press Ctrl + C once, then Enter, to break out of the current 'git difftool' command, but continue 
on with the previous commit. 
- Press Ctrl + C twice to exit out of the whole program.

USAGE:
    $SCRIPT_NAME [OPTIONS] [[commit] [commit_start~..commit_end]] -- [file1 file2 file3 ...]

OPTIONS
    -h, -?
        Print help menu
    -v, --version
        Print version information.
    --
        Lists of files or directories go after this point.

EXAMPLE USAGES:
    $SCRIPT_NAME -h
        Print help menu.
    $SCRIPT_NAME
        Start running 'git difftool' on the commit starting at HEAD (the currently-checked-out
        commit).
    $SCRIPT_NAME HEAD
        Same as above.
    $SCRIPT_NAME HEAD~
        Start running 'git difftool' on the commit starting at HEAD~ (one before HEAD).
    $SCRIPT_NAME HEAD~2
        Start running 'git difftool' on the commit starting at HEAD~2 (two before HEAD).
    $SCRIPT_NAME abcdefg
        Start running 'git difftool' on commit hash abcdefg.
    $SCRIPT_NAME my_branch
        Start running 'git difftool' on the commit at the tip of branch 'my_branch'.
    $SCRIPT_NAME commit1~..commit2
        Run 'git difftool' on all commits between commit1 and commit2, inclusive.    
    $SCRIPT_NAME commit1..commit2
        Run 'git difftool' on all commits between commit1 and commit2, including commit2 but
        NOT including commit1.
    $SCRIPT_NAME commit1~..commit2 -- file1 file2 file3
        Run 'git difftool' on all commits between commit1 and commit2, inclusive, but only
        for the files file1, file2, and file3.
    $SCRIPT_NAME -- path/to/file1
        Start running 'git difftool' on the commit starting at HEAD, but only for the file
        \"path/to/file1\".
    $SCRIPT_NAME -- path/to/dir1
        Start running 'git difftool' on the commit starting at HEAD, but only for the files
        in the directory \"path/to/dir1/\".

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Print all arguments, for debugging.
debugging_print_all_args() {
    # echo "$1"  # debugging

    echo "All args:"
    i=0
    for arg in "$@"; do
        ((i++))
        echo "arg${i} = $arg"
    done
}

parse_args() {
    # See my code here for advanced argument parsing:
    # https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
    ALL_ARGS_ARRAY=("$@")  # See: https://stackoverflow.com/a/70572787/4561887
    # echo "ALL_ARGS_ARRAY = ${ALL_ARGS_ARRAY[@]}"  # debugging
    POSITIONAL_ARGS_ARRAY=()
    filenames_array=()
    while [ "$#" -gt 0 ]; do
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
            # Filename args
            "--")
                # echo "Found '--' arg!"  # debugging
                # Collect *all* remaining args into the `filenames_array`
                shift # past argument
                all_remaining_args=("$@")
                filenames_array=("${all_remaining_args[@]}")
                break
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
}

handle_ctrl_c() {
    # Unset the Ctrl + C trap
    trap - SIGINT

    echo -e "\nCtrl + C captured! Exit out of the whole program? (y/N)"
    echo    "[Press n or Enter to continue on with the previous commit]"
    read -r -n 1 answer
    echo ""

    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "Exiting out of the whole program!"
        exit $RETURN_CODE_SUCCESS
    else
        echo "Continuing on with the next commit..."
    fi
}

main() {
    # Get a list of all commit hashes
    commits=$(git log --pretty=format:"%h" "${ALL_ARGS_ARRAY[@]}")
    if [ "$?" -ne "0" ]; then
        echo "ERROR: 'git log' command failed!"
        debugging_print_all_args "$@"
        echo ""
        echo "Run '$SCRIPT_NAME -h' for help."
        exit $RETURN_CODE_ERROR
    fi

    # debugging
    # echo -e "commits = \n$commits"

    echo "Analyzing previous commits in 'git difftool', one commit at a time."
    echo "- Press Ctrl + C, then Enter, to skip the current commit and continue on with the previous"\
         "commit."
    echo "- Press Ctrl + C twice to exit out of the whole program."
    echo ""

    # Loop through the list of commit hashes
    i=0
    for commit in $commits; do
        echo -e "========================================================"
        echo -e "#$i ($i commits prior to HEAD): Analyzing commit: $commit:"
        echo -e "========================================================"

        # For a 1-line commit message
        # git log --oneline -1 $commit

        # For the whole commit message
        # TODO: make this an option in the future, with the `--oneline` version above being default.
        git log -1 $commit

        echo -e "\n----------------------------------------"
        echo "Running 'git difftool $commit~..$commit -- ${filenames_array[@]}'."
        echo "Run this to pick back up here:"
        echo "    $SCRIPT_NAME $commit -- ${filenames_array[@]}"
        echo      "----------------------------------------"

        # Capture Ctrl + C so we can break out of `git difftool`, but NOT necessarily out of the
        # whole program at this time!
        trap 'handle_ctrl_c' SIGINT

        git difftool $commit~..$commit -- "${filenames_array[@]}"

        echo ""
        ((i++))
    done

    echo "Done with all commits! Exiting '$SCRIPT_NAME'."
}

# Determine if the script is being sourced or executed (run).
# See:
# 1. "eRCaGuy_hello_world/bash/if__name__==__main___check_if_sourced_or_executed_best.sh"
# 1. My answer: https://stackoverflow.com/a/70662116/4561887
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # This script is being run.
    __name__="__main__"
else
    # This script is being sourced.
    __name__="__source__"
fi

# ----------------------------------------------------------------------------------------------------------------------
# Main program entry point
# ----------------------------------------------------------------------------------------------------------------------

# Only run `main` if this script is being **run**, NOT sourced (imported).
# - See my answer: https://stackoverflow.com/a/70662116/4561887
if [ "$__name__" = "__main__" ]; then
    parse_args "$@"
    time main "$@"
    exit $RETURN_CODE_SUCCESS
fi
