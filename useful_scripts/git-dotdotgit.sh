#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: Work in Progress (WIP)

# Author: Gabriel Staples
# www.ElectricRCAircraftGuy.com 

# DESCRIPTION:
# I want to archive a bunch of small git repos inside a single, larger repo, which I will back up on 
# GitHub until I have time to manually pull out each small, nested repo into its own stand-alone
# GitHub repo. To do this, however, `git` in the outer, parent repo must NOT KNOW that the inner
# git repos are git repos! The easiest way to do this is to just rename all inner, nested `.git` 
# folders to anything else, such as to `..git`, so that git won't recognize them as stand-alone
# repositories, and so that it will just treat their contents like any other normal directory
# and allow you to back it all up! Thus, this project is born. It will allow you to quickly
# "toggle" the naming of any folder from `.git` to `..git`, or vice versa. Hence the name of this
# project: "git-dotdotgit". 
# See my answer here: 
# https://stackoverflow.com/questions/47008290/how-to-make-outer-repository-and-embedded-repository-work-as-common-standalone-r/62368415#62368415

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere as `git dotdotgit` OR
#    as `git-dotdotgit` OR as `gs_git-dotdotgit` OR as `git gs_dotdotgit`. Note that "gs" is my initials. 
#    I do these versions with "gs_" in them so I can find all scripts I've written really easily 
#    by simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab. 
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-dotdotgit.sh" ~/bin/git-dotdotgit     # required
#       ln -si "${PWD}/git-dotdotgit.sh" ~/bin/git-gs_dotdotgit  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-dotdotgit.sh" ~/bin/gs_git-dotdotgit  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git dotdotgit`  <=== my preferred way to use this program
#   2. `git-dotdotgit`
#   3. `git gs_dotdotgit`
#   4. `git-gs_dotdotgit`
#   3. `gs_git-dotdotgit`

# FUTURE WORK/TODO:
# 1. NA

# References:
# 1. https://stackoverflow.com/questions/47008290/how-to-make-outer-repository-and-embedded-repository-work-as-common-standalone-r/62368415#62368415

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

EXIT_SUCCESS=0
EXIT_ERROR=1

# SCRIPT_NAME="$(basename "$0")"
SCRIPT_NAME="git dotdotgit"
NAME_AND_VERSION_STR="'$SCRIPT_NAME' version $VERSION"

HELP_STR="
$NAME_AND_VERSION_STR
  - Rename all \".git\" subdirectories in the current directory to \"..git\" so that they can be 
    easily added to a parent git repo as if they weren't git repos themselves. 
  - Why? See: https://stackoverflow.com/a/62368415/4561887

Usage: '$SCRIPT_NAME [positional_parameters]'
  Positional Parameters:
    '-h' OR '-?'        = print this help menu
    '-v' OR '--version' = print the author and version
    '--on'              = rename all \".git\" subdirectories --> \"..git\"
    '--off'             = rename all \"..git\" subdirectories --> \".git\"
        So, once you do '$SCRIPT_NAME --off' Now you can then do 
        'cd path/to/parent/repo && mv ..git .git && git add -A' to add all files and folders to 
        the parent git repo, and then 'git commit' to commit them. Prior to running
        '$SCRIPT_NAME', git would not have allowed this since it won't natively let 
        you add sub-repos to a repo, and it recognizes sub-repos by the existence of their
        \".git\" directories.  
    '--list'            = list all \".git\" and \"..git\" subdirectories

This program is part of: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
"

print_help() {
    echo "$HELP_STR"
}

print_version() {
    echo "$NAME_AND_VERSION_STR"
    echo "Author = $AUTHOR"
    echo "See '$SCRIPT_NAME -h' for more info."
}

parse_args() {
    if [ $# -lt 1 ]; then
        echo "ERROR: Not enough arguments supplied ($# supplied, 1 required)"
        print_help
        exit $EXIT_ERROR
    fi

    if [ $# -gt 1 ]; then
        echo "ERROR: Too many arguments supplied ($# supplied, 1 required)"
        print_help
        exit $EXIT_ERROR
    fi

    # Help menu
    # Note: if running this command as `git dotdotgit` rather than `git-dotdotgit`, you can NOT
    # pass it a '--help' parameter, because `git` intercepts this parameter and tries to print its
    # own help or man pages for the given command. Nevertheless, let's leave in the '--help' option
    # for those who wish to run the command with the '-' in it vs without the '-' in it. 
    if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]; then
        print_help
        exit $EXIT_SUCCESS
    fi

    # Version
    if [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
        print_version
        exit $EXIT_SUCCESS
    fi

    # All other commands
    if [ "$1" == "--on" ] || [ "$1" == "--off" ] || [ "$1" == "--list" ]; then
        CMD="$1"
    else 
        echo "ERROR: Invalid Parameter. You entered \"$1\". Valid parameters are shown below."
        print_help
        exit $EXIT_ERROR
    fi
} # parse_args()

main() {
    echo "CMD = $CMD" # for debugging

} # main()


# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main # run main, while also timing how long it takes

