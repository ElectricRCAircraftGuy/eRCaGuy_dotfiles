#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# git-filechange-search.sh
# - See which commit changed a certain keyword (regex search pattern) in a certain file.
# - This allows you to track down the exact commit which changed a certain variable or function 
#   of interest, for example, in a particular file.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-filechange-search.sh" ~/bin/gs_git-filechange-search
# 2. Now you can use the `gs_git-filechange-search` command directly anywhere you like.

# References:
# 1. My "find_and_replace.sh" script in this repo
# 1. See `man test` for [ ] style comparisons (=, !=, -eq, -ge, -gt, -lt, etc.)

# Test cases:
#   gs_git-filechange-search "git & Linux cmds, help, tips & tricks - Gabriel.txt"
#   gs_git-filechange-search -v "git & Linux cmds, help, tips & tricks - Gabriel.txt"
#   gs_git-filechange-search -vv "git & Linux cmds, help, tips & tricks - Gabriel.txt"
#   gs_git-filechange-search "git & Linux cmds, help, tips & tricks - Gabriel.txt" "difftool"
#   gs_git-filechange-search -v "git & Linux cmds, help, tips & tricks - Gabriel.txt" "difftool"
#   gs_git-filechange-search -vv "git & Linux cmds, help, tips & tricks - Gabriel.txt" "difftool"

# TODO:
# 1. Once this script is tried and proven and working well, try to get it merged upstream into 
#    git itself, if possible.

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"


SCRIPT_NAME="$(basename "$0")"
NAME_AND_VERSION_STR="git-filechange-search (run as '$SCRIPT_NAME') version $VERSION"

print_help() {
    echo ''
    echo "$NAME_AND_VERSION_STR"
    echo " - find out which commit changed a certain variable (ie: keyword, or regex search"
    echo "   pattern) in a certain file"
    echo ""
    echo "Main Usage: $SCRIPT_NAME [-v|-vv] <filename> <regex_search>"
    echo ""
    echo "'$SCRIPT_NAME <filename> <regex_search>'    = print the commit hashes which modify this"
    echo "      file AND contain changes which match the regular expression <regex_search>"
    echo "'$SCRIPT_NAME -v <filename> <regex_search>' = same as above, except with 'v'erbose output"
    echo "'$SCRIPT_NAME -vv <filename> <regex_search>' = same as above, except with extra 'v'erbose"
    echo "      output"
    echo "'$SCRIPT_NAME <filename>'    = print all commit hashes which modify this file"
    echo "'$SCRIPT_NAME -v <filename>' = same as above, except with 'v'erbose output"
    echo "'$SCRIPT_NAME -vv <filename>' = same as above, except with extra 'v'erbose output"
    echo "'$SCRIPT_NAME'            = print help menu"
    echo "'$SCRIPT_NAME -h'         = print help menu"
    echo "'$SCRIPT_NAME -?'         = print help menu"
    echo "'$SCRIPT_NAME --version'  = print author & version"
    echo ""
    echo "This program is part of: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles"
    echo ""
}

print_version() {
    echo "$NAME_AND_VERSION_STR"
    echo "Author = $AUTHOR"
    echo "See '$SCRIPT_NAME -h' for more info."
}

parse_args() {
    if [ $# -lt 1 ]; then
        echo "ERROR: Not enough arguments supplied"
        print_help
        exit $EXIT_ERROR
    fi

    if [ $# -gt 3 ]; then
        echo "ERROR: Too many arguments supplied"
        print_help
        exit $EXIT_ERROR
    fi

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        print_help
        exit $EXIT_SUCCESS
    fi

    # Version
    if [ "$1" == "--version" ]; then
        print_version
        exit $EXIT_SUCCESS
    fi

    VERBOSITY_LEVEL=0
    FILENAME="$1"
    REGEX_SEARCH=""
    
    # Verbosity level
    if [ "$1" == "-v" ]; then
        VERBOSITY_LEVEL=1
    elif [ "$1" == "-vv" ]; then
        VERBOSITY_LEVEL=2
    fi

    echo "Verbosity level $VERBOSITY_LEVEL"

    if [ "$VERBOSITY_LEVEL" -gt 0 ]; then
        FILENAME="$2"

        if [ $# -eq 1 ]; then
            echo "ERROR: Not enough arguments supplied"
            print_help
            exit $EXIT_ERROR
        elif [ $# -eq 3 ]; then
            REGEX_SEARCH="$3"
        fi
    else # NOT verbose (VERBOSITY_LEVEL is 0)
        if [ $# -gt 2 ]; then
            echo "ERROR: Too many arguments supplied, or invalid order. Note that -v and "
            echo "       -vv are positional."
            print_help
            exit $EXIT_ERROR
        elif [ $# -eq 2 ]; then
            REGEX_SEARCH="$2"
        fi
    fi
}

main() {
    echo "Searching for regex pattern \"$REGEX_SEARCH\" in filename \"$FILENAME\"."
    
    # List of all commit hashes which have modified FILENAME
    COMMIT_HASHES="$(git log --follow "$FILENAME" | grep -E "commit [0-9a-f]{30,}" | \
                   grep -E --only-matching "[0-9a-f]{30,}")"
    # echo "$COMMIT_HASHES" # for debugging

    # Convert the multi-line string into an array
    COMMIT_HASHES_ARRAY=($(echo "$COMMIT_HASHES"))
    # Num elements in array; see: 
    # https://unix.stackexchange.com/questions/193039/how-to-count-the-length-of-an-array-defined-in-bash/193042#193042
    num_elements="${#COMMIT_HASHES_ARRAY[@]}"
    echo "${num_elements} commits modify this file."

    STR_GIT_LOG="" #######

    # If no 2nd argument provided, there's no regex pattern to search for, so just print the commits
    # which modify this file
    if [ -z "$REGEX_SEARCH" ]; then 
        commit="commit_hash"
        
        # Copy to VERBOSE_INSTRUCTIONS below to match if you modify this block
        VERBOSE_INSTRUCTIONS="\
Run this command to see the commit log header for this commit:\n\
    git log -n 1 ${commit}\n\
Run this command to see the commit changes:\n\
    git diff --color=always ${commit}~..${commit} \"$FILENAME\"\n\
  OR:\n\
    git difftool ${commit}~..${commit} \"$FILENAME\""

        if [ "$VERBOSITY_LEVEL" -eq 0 ]; then
            echo -e "$VERBOSE_INSTRUCTIONS"
        fi

        echo "All commits which modify this file are (most recent FIRST):"
        # Loop through the array; see: 
        # https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash/8880633#8880633
        count=0
        for commit in "${COMMIT_HASHES_ARRAY[@]}"
        do
            ((count++))
            git_log_oneline_output="$(git log --color=always -n 1 --pretty=oneline "${commit}")"
            VERBOSE_STR="${count}/${num_elements}: ${git_log_oneline_output}"
            # Copy to VERBOSE_INSTRUCTIONS above to match if you modify this block
            VERBOSE_INSTRUCTIONS="\
Run this command to see the commit log header for this commit:\n\
    git log -n 1 ${commit}\n\
Run this command to see the commit changes:\n\
    git diff --color=always ${commit}~..${commit} \"$FILENAME\"\n\
  OR:\n\
    git difftool ${commit}~..${commit} \"$FILENAME\""

            if [ "$VERBOSITY_LEVEL" -eq 0 ]; then
                echo "$VERBOSE_STR"
            elif [ "$VERBOSITY_LEVEL" -eq 1 ]; then
                echo "------"
                echo "$VERBOSE_STR"
                echo -e "$VERBOSE_INSTRUCTIONS"
            elif [ "$VERBOSITY_LEVEL" -eq 2 ]; then
                echo "======"
                # echo "$VERBOSE_STR" # Unused
                echo "${count}/${num_elements}: ${commit}"
                echo "---full commit header start---"
                git log -n 1 "$commit"
                echo "---full commit header end---"
                echo -e "$VERBOSE_INSTRUCTIONS"
                echo ""
            fi
        done
        echo "($num_elements total commits)"

        exit $EXIT_SUCCESS
    fi

    # Actually do the searching
    echo "Listing commits which **contain changes which match the regex pattern above** \
(most recent FIRST):"
    total_count=0
    match_count=0 # number of commits found with changes matching the regex pattern
    for commit in "${COMMIT_HASHES_ARRAY[@]}"
    do
        ((total_count++))

        # Use `--unified=0` to NOT show surrounding, unchanged lines in the `git diff`; see:
        # https://stackoverflow.com/questions/18810623/git-diff-to-show-only-lines-that-have-been-modified/18810673#18810673
        num_lines_changed="$(git diff --unified=0 "${commit}~..${commit}" "$FILENAME" | \
            grep -E "$REGEX_SEARCH" | wc -l)"
        
        if [ "$num_lines_changed" -gt 0 ]; then
            ((match_count++))

            if [ "$VERBOSITY_LEVEL" -eq 0 ]; then
                echo "${commit}"
            elif [ "$VERBOSITY_LEVEL" -eq 1 ]; then
                echo "${match_count} (${total_count}/${num_elements}): Changes found in commit \
${commit} (${num_lines_changed} lines changed)."
            elif [ "$VERBOSITY_LEVEL" -eq 2 ]; then
                echo "======"
                echo "${match_count} (${total_count}/${num_elements}): Changes found in commit \
${commit} (${num_lines_changed} lines changed)."
                echo "---commit header start---"
                git log -n 1 "$commit"
                echo "---commit header end / git diff start---"
                git diff --color=always ${commit}~..${commit} "$FILENAME" | grep --color=always \
                    -En -B 3 -A 3 "$REGEX_SEARCH"
                echo "---git diff end---"
                echo "  Run this command to see the commit log header for this commit:"
                echo "      git log -n 1 ${commit}"
                echo "  Run this command to see the commit changes:"
                echo "      git diff --color=always ${commit}~..${commit} \"$FILENAME\" | \
grep -En -B 3 -A 3 \"$REGEX_SEARCH\""
                echo "    OR:"
                echo "      git difftool ${commit}~..${commit} \"$FILENAME\""
                echo ""
            fi
        fi
    done
    echo "($match_count matching commits out of $total_count total commits which modify this file)"

    if [ "$match_count" -eq 0 ]; then
        echo "NO MATCHES FOUND!"
    fi
}


# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main # run main, while also timing how long it takes

