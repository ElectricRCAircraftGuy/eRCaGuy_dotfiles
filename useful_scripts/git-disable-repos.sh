#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: It works! It's ready for full usage anywhere.

# Author: Gabriel Staples
# www.ElectricRCAircraftGuy.com 

DESCRIPTION="
I want to archive a bunch of small git repos inside a single, larger repo, which I will back up on 
GitHub until I have time to manually pull out each small, nested repo into its own stand-alone
GitHub repo. To do this, however, 'git' in the outer, parent repo must NOT KNOW that the inner
git repos are git repos! The easiest way to do this is to just rename all inner, nested '.git' 
folders to anything else, such as to '..git', so that git won't recognize them as stand-alone
repositories, and so that it will just treat their contents like any other normal directory
and allow you to back it all up! Thus, this project is born. It will allow you to quickly
"toggle" the naming of any folder from '.git' to '..git', or vice versa. Hence the name of this
project: "git-disable-repos". 
See my answer here: 
https://stackoverflow.com/questions/47008290/how-to-make-outer-repository-and-embedded-repository-work-as-common-standalone-r/62368415#62368415
"

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere as 
#    `git disable-repos` OR as `git-disable-repos` OR as `gs_git-disable-repos` 
#    OR as `git gs_disable-repos`. Note that "gs" is my initials. I do these 
#    versions with "gs_" in them so I can find all scripts I've written really easily by
#    simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab. 
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-disable-repos.sh" ~/bin/git-disable-repos     # required
#       ln -si "${PWD}/git-disable-repos.sh" ~/bin/git-gs_disable-repos  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-disable-repos.sh" ~/bin/gs_git-disable-repos  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git disable-repos`  <=== my preferred way to use this program
#   2. `git-disable-repos`
#   3. `git gs_disable-repos`
#   4. `git-gs_disable-repos`
#   3. `gs_git-disable-repos`

# FUTURE WORK/TODO:
# 1. NA

# References:
# 1. https://stackoverflow.com/questions/47008290/how-to-make-outer-repository-and-embedded-repository-work-as-common-standalone-r/62368415#62368415

VERSION="0.3.0"
AUTHOR="Gabriel Staples"

EXIT_SUCCESS=0
EXIT_ERROR=1

# SCRIPT_NAME="$(basename "$0")" # automatically obtain it from whatever program the user just ran
SCRIPT_NAME="git disable-repos" # just manually specify it
NAME_AND_VERSION_STR="'$SCRIPT_NAME' version $VERSION"

HELP_STR="
$NAME_AND_VERSION_STR
  - Rename all \".git\" subdirectories in the current directory to \"..git\" to temporarily
    \"disable\" them so that they can be easily added to a parent git repo as if they weren't 
    git repos themselves (\".git\" <--> \"..git\").
  - Why? See my StackOverflow answer here: https://stackoverflow.com/a/62368415/4561887
  - See also the \"Long Description\" below.

Usage: '$SCRIPT_NAME [positional_parameters]'
  Positional Parameters:
    '-h' OR '-?'         = print this help menu, piped to the 'less' page viewer
    '-v' OR '--version'  = print the author and version
    '--true'             = Disable all repos by renaming all \".git\" subdirectories --> \"..git\"
        So, once you do '$SCRIPT_NAME --true' **from within the parent repo's root directory,** 
        you can then do 'mv ..git .git && git add -A' to re-enable the parent repo ONLY and 
        stage all files and folders to be added to it. Then, run 'git commit' to commit them. 
        Prior to running '$SCRIPT_NAME --true', git would not have allowed adding all 
        subdirectories since it won't normally let you add sub-repos to a repo, and it recognizes 
        sub-repos by the existence of their \".git\" directories.  
    '--true_dryrun'      = dry run of the above
    '--false'            = Re-enable all repos by renaming all \"..git\" subdirectories --> \".git\"
    '--false_dryrun'     = dry run of the above
    '--list'             = list all \".git\" and \"..git\" subdirectories

Common Usage Example:
  - To rename all '.git' subdirectories to '..git' **except for** the one immediately in the current 
    directory, so as to not disable the parent repo's .git dir (assuming you are in the parent 
    repo's root dir when running this command), run this:

        $SCRIPT_NAME --true  # disable all git repos in this dir and below
        mv ..git .git        # re-enable just the parent repo

    Be sure to do a dry run first for safety, to ensure it will do what you expect:

        $SCRIPT_NAME --true_dryrun

  - To recursively list all git repos within a given folder, run this command from within the 
    folder of interest:

        $SCRIPT_NAME --list

Long Description: $DESCRIPTION
This program is part of: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
"

print_help() {
    echo "$HELP_STR"
}

print_help_piped_to_less() {
    # Note: I borrowed the "less" options below from my
    # "eRCaGuy_dotfiles/useful_scripts/git-diffn.sh" script. `-RFX` produces the same "less" 
    # behavior as `git diff`, for instance. 
    # -R = interpret ANSI color codes (in case I decide to add any in the future)
    # -F = quit immediately if the output takes up less than one screen
    # -X = do NOT clear the screen when less exits
    print_help | less -RFX
}

print_see_help() {
    echo "See '$SCRIPT_NAME -h' for proper usage and help."
}

print_version() {
    echo "$NAME_AND_VERSION_STR"
    echo "Author = $AUTHOR"
    echo "See '$SCRIPT_NAME -h' for more info."
    echo "This program is part of: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles"
}

parse_args() {
    if [ $# -lt 1 ]; then
        echo "ERROR: Not enough arguments supplied ($# supplied, 1 required)"
        print_see_help
        exit $EXIT_ERROR
    fi

    if [ $# -gt 1 ]; then
        echo "ERROR: Too many arguments supplied ($# supplied, 1 required)"
        print_see_help
        exit $EXIT_ERROR
    fi

    # Help menu
    # Note: if running this command as `git disable-repos` rather than `git-disable-repos`, you can NOT
    # pass it a '--help' parameter, because `git` intercepts this parameter and tries to print its
    # own help or man pages for the given command. Nevertheless, let's leave in the '--help' option
    # for those who wish to run the command with the '-' in it vs without the '-' in it. 
    if [ "$1" == "-h" ] || [ "$1" == "-?" ] || [ "$1" == "--help" ]; then
        print_help_piped_to_less
        exit $EXIT_SUCCESS
    fi

    # Version
    if [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
        print_version
        exit $EXIT_SUCCESS
    fi

    # All other commands

    # WARNING: default to the SAFE STATE, which is to do a dry run, *NOT* the unsafe state, which
    # is to do real renames!
    DRY_RUN="true" 
    if [ "$1" == "--true" ] || [ "$1" == "--true_dryrun" ] || \
       [ "$1" == "--false" ] || [ "$1" == "--false_dryrun" ] || \
       [ "$1" == "--list" ]; then

        CMD="$1"
        if [ "$CMD" == "--true_dryrun" ]; then
            CMD="--true"
        elif [ "$CMD" == "--false_dryrun" ]; then
            CMD="--false"
        elif [ "$CMD" == "--true" ] || [ "$CMD" == "--false" ]; then
            # disable the dry run setting for real runs
            DRY_RUN="false"
        fi
    else 
        echo "ERROR: Invalid Parameter. You entered \"$1\"."
        echo "       Valid parameters are shown in the help menu."
        print_see_help
        exit $EXIT_ERROR
    fi
} # parse_args()

# Actually do the renaming (disabling/enabling of git repos) here: (".git" <--> "..git")
disable-repos() {
    # BORROWED FROM MY "eRCaGuy_dotfiles/useful_scripts/find_and_replace.sh" script:

    # Obtain a long multi-line string of paths to all dirs whose names match the `regex_from`
    # regular expression; there will be one line per filename path. It is important that we run
    # the `find` command ONLY ONCE, since it takes the longest amoung of time of all of the 
    # commands we use in this script! So, we must run it once & store its output into a variable.
    dirnames="$(find . -type d | grep -E "$regex_from" | sort -V)"
    # echo -e "===============\ndirnames = \n${dirnames}\n===============" # for debugging

    # Convert the long `dirnames` string to a Bash array, separated by new-line chars; see:
    # 1. https://stackoverflow.com/questions/24628076/bash-convert-n-delimited-strings-into-array/24628676#24628676
    # 2. https://unix.stackexchange.com/questions/184863/what-is-the-meaning-of-ifs-n-in-bash-scripting/184867#184867
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS to the newline char
    dirnames_array=($dirnames) # split long string into array, separating by IFS (newline chars)
    IFS=$SAVEIFS   # Restore IFS

    # Get the length of the bash array; see here:
    # https://stackoverflow.com/questions/1886374/how-to-find-the-length-of-an-array-in-shell/1886483#1886483
    num_dirs="${#dirnames_array[@]}"
    echo "Number of directories (git repositories) found = ${num_dirs}."

    dir_num=0
    num_dirs_renamed=0
    # For how to loop through an array of strings in bash, see:
    # https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash/8880633#8880633
    for dirname in "${dirnames_array[@]}"; do
        dir_num=$((dir_num + 1))

        # echo "dirname = \"$dirname\"" # for debugging

        if [ "$list_only" == "true" ]; then
            # List the results only
            dirname_colorized="$(echo "$dirname" | grep --color=always -E "$regex_from")"
            printf "%3u: %-70s\n" $dir_num "\"${dirname_colorized}\""

        elif [ "$list_only" == "false" ]; then
            # Also do renaming or renaming dry runs

            parentdir="$(dirname "$dirname")"
            dir="$(basename "$dirname")"

            from="${parentdir}/${dir}"
            to="${parentdir}/${rename_to}"
            from_colorized="$(echo "$from" | grep --color=always -E "$regex_from")"
            to_colorized="$(echo "$to" | grep --color=always -E "$regex_to")"

            if [ "$DRY_RUN" == "true" ]; then
                printf "DRY RUN: %3u: %s %-70s %-70s\n" $dir_num \
                "mv" "\"${from_colorized}\"" "\"${to_colorized}\""
            elif [ "$DRY_RUN" == "false" ]; then
                num_dirs_renamed=$((num_dirs_renamed + 1))
                printf "%3u: %s %-70s %-70s\n" $dir_num \
                "mv" "\"${from_colorized}\"" "\"${to_colorized}\""
                # Now actually DO the renames since it is NOT a dry run!
                mv "$from" "$to"
            fi
        fi
    done

    echo "Number of directories actually renamed = ${num_dirs_renamed} of ${num_dirs}."
}

main() {
    # echo "CMD = $CMD" # for debugging

    # WARNING: DO *NOT* FORGET THE `/` AT THE BEGINNING AND THE `$` AT THE END FOR ALL OF THESE!
    # - IF YOU FORGET IT, IT WILL COMPLETELY SCREW UP THE FOLDER RENAMING BADLY! SO BE SURE TO 
    #   ALWAYS DO A DRYRUN FIRST IF YOU EVER MAKE CHANGES TO THESE REGULAR EXPRESSIONS!
    DOTGIT="/\.git$" # matches "/.git" at the end of a line
    DOTDOTGIT="/\.\.git$" # matches "/..git" at the end of a line
    EITHERGIT="/(\.|\.\.)git$" # matches "/.git" and "/..git" at the end of a line

    list_only="false"
    if [ "$CMD" == "--true" ]; then
        echo "Temporarily disabling all git repos by renaming all \"/.git\" directories --> \"/..git\"."
        regex_from="$DOTGIT"
        regex_to="$DOTDOTGIT"
        rename_to="..git"
        disable-repos
    elif [ "$CMD" == "--false" ]; then
        echo "Re-enabling all git repos by renaming all \"/..git\" directories back to --> \"/.git\"."
        regex_from="$DOTDOTGIT"
        regex_to="$DOTGIT"
        rename_to=".git"
        disable-repos
    elif [ "$CMD" == "--list" ]; then
        echo "Showing all nested git repos by listing all \".git\" and \"..git\" directories:"
        regex_from="$EITHERGIT"
        list_only="true"
        disable-repos
    fi

    echo "Done!"
} # main()


# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
# time main # run main, while also timing how long it takes
main
