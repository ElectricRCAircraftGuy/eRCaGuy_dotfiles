#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: it works!

# Author: Gabriel Staples
# www.GabrielStaples.com
# www.ElectricRCAircraftGuy.com

# DESCRIPTION:
# git-blametool.sh:
# This is a wrapper around `git blame` to open up the output in your favorite text editor.

# INSTALLATION INSTRUCTIONS:
# 1. Install your editor of choice.
#   1. For me, that's Sublime Text 3. So, install it from here: https://www.sublimetext.com/3.
#   2. Install the "Git" package so that you get access to the "Git --> Git Blame" syntax
#      highlighting.
# 2. Set up your blametool configuration settings as desired. I am setting my blametool editor to
#    'subl' (Sublime Text 3), and I am telling it to auto-delete the `git blame` output file
#    after each run. Set these as you desire:
#           git config --global blametool.editor subl
#           git config --global blametool.auto-delete-tempfile-when-done true  # set to true or false (case-sensitive)
# 3. Open up "~/.gitconfig", after running the commands above, and verify you see the following,
#    or similar, in the end of the file:
#    ```
#    [blametool]
#        editor = subl
#        auto-delete-tempfile-when-done = true
#    ```
# 4. Create a symlink in ~/bin to this script so you can run it from anywhere.
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -si "${PWD}/git-blametool.sh" ~/bin/git-blametool     # required
#           ln -si "${PWD}/git-blametool.sh" ~/bin/git-gs_blametool  # optional; replace "gs" with your initials
#           ln -si "${PWD}/git-blametool.sh" ~/bin/gs_git-blametool  # optional; replace "gs" with your initials
# 5. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git blametool`  <=== my preferred way to use this program, so it feels just like a native `git` cmd!
#   2. `git-blametool`
#   3. `git gs_blametool`
#   4. `git-gs_blametool`
#   3. `gs_git-blametool`
# 6. See `git blametool -h` for more details.

# References:
# 1. Issue to make this feature: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues/13

VERSION="0.2.0"
AUTHOR="Gabriel Staples"

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="git blametool (run as '$SCRIPT_NAME') version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

DEFAULT_EDITOR="subl"
DEFAULT_EDITOR_DESCRIPTION="Sublime Text 3"

TEMP_DIR="$HOME/temp/git-blametool"

HELP_STR="\
$VERSION_SHORT_STR

Purpose: open up your 'git blame' output in your favorite editor, so you can see who made
what changes, when, and in what commit, easily, and in your editor of choice.

Usage:

    See 'man git blame' and 'git blame -h' for additional details. Since this is a thin wrapper
    around 'git blame', it takes ALL of the same parameters that 'git blame' takes too! A typical
    usage of 'git blametool' is like this:

    $SCRIPT_NAME [commit_hash] <file_path>
            Open up the 'git blame' output for file \"file_path\" from commit or branch
            \"commit_hash\" in your editor specified by 'git config blametool.editor'.
            If no editor is set, the default, '$DEFAULT_EDITOR' ($DEFAULT_EDITOR_DESCRIPTION) is
            used. You can set your editor of choice with:
                    git config --global blametool.editor [editor-executable]
            Example:
                    git config --global blametool.editor gedit
    $SCRIPT_NAME
            print this help menu
    $SCRIPT_NAME -h
            print this help menu
    $SCRIPT_NAME -?
            print this help menu
    $SCRIPT_NAME -v
            print author & version

Examples:

    $SCRIPT_NAME master path/to/myfile.c
    $SCRIPT_NAME path/to/myfile.c

Configuration:

    1. Set your blametool editor. If not set, the default is '$DEFAULT_EDITOR'
       ($DEFAULT_EDITOR_DESCRIPTION). General form:
            git config --global blametool.editor [editor-executable]
       Example: set your editor as Sublime Text 3 (its command-line executable is 'subl'):
            git config --global blametool.editor subl
       Other popular choices:
            git config --global blametool.editor vim
            git config --global blametool.editor emacs
            git config --global blametool.editor nano
            git config --global blametool.editor gedit
            git config --global blametool.editor leafpad
       Remember, you can use ANY editor you want. You can set the 'editor' to a full path too if
       you like:
            git config --global blametool.editor \"/path/to/editor\"

    2. Set whether or not to auto-delete the temporary file when done (if not set, the default is
       'true'). Be sure to set to 'true' or 'false' (case-sensitive), NOT 'True' or 'False' or
       'TRUE' or 'FALSE'! General form:
            git config --global blametool.auto-delete-tempfile-when-done [true|false]
        Examples:
            git config --global blametool.auto-delete-tempfile-when-done true
            git config --global blametool.auto-delete-tempfile-when-done false

Source Code:
https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-blametool.sh
"

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Parse the 'git blametool'-specific arguments first
parse_args() {
    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        exit $RETURN_CODE_ERROR
    fi

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        print_help
        exit $RETURN_CODE_SUCCESS
    fi

    # Version
    if [ "$1" == "-v" ]; then
        print_version
        exit $RETURN_CODE_SUCCESS
    fi
}

# Find the revision (git commit) argument, either `<rev>` or `<rev>..<rev>` below, as well as the
# `<file>` argument.
# Note: `man git blame` shows these are the possible args:
#       git blame [-c] [-b] [-l] [--root] [-t] [-f] [-n] [-s] [-e] [-p] [-w] [--incremental]
#                   [-L <range>] [-S <revs-file>] [-M] [-C] [-C] [-C] [--since=<date>]
#                   [--progress] [--abbrev=<n>] [<rev> | --contents <file> | --reverse <rev>..<rev>]
#                   [--] <file>
get_revision_and_filename() {
    # For advanced argument parsing help and demo, see:
    # https://stackoverflow.com/a/14203146/4561887.

    # skip over all optional args beginning with `-`. But, if you see a `-L` or `-S` or
    # `--contents`, skip over the accompanying mandatory positional arg right after those too.
    # This will leave just 1 or 2 positional arguments remaining, with the last arg being
    # `<file>`, and the 2nd-to-last arg (if it exists at all, since it doesn't have to be
    # provided) being either `<rev>` or `<rev>..<rev>`.
    POSITIONAL_ARGS_ARRAY=()
    while [[ $# -gt 0 ]]; do
    arg="$1"
    # first letter of `arg`; see: https://stackoverflow.com/a/10218528/4561887
    first_letter="${arg:0:1}"

    case $first_letter in
        "-")
            shift # past argument
            if [ "$arg" == "-L" ] || [ "$arg" == "-S" ] || [ "$arg" == "--contents" ]; then
                shift # past value
            fi
            ;;
        *) # unknown option (ie: unmatched in the switch cases above)
            POSITIONAL_ARGS_ARRAY+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
    done

    # last filtered arg
    FILE_IN="${POSITIONAL_ARGS_ARRAY[-1]}"
    # 2nd-to-last filtered arg
    REVISION="${POSITIONAL_ARGS_ARRAY[-2]}"

    array_len=${#POSITIONAL_ARGS_ARRAY[@]}
    if [ $array_len -gt 2 ]; then
        echo "Warning. 'git blametool' parsing may be faulty. Positional arguments array is longer"
        echo   "than expected. Please open an issue here:"
        echo "  https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues"
        echo "  Include this output. array_len = $array_len. Your cmd:"
        echo "          $FULL_CMD"
    fi

    # debugging
    # TEST 1 INPUT:
    #       git blametool hey how --are -- -you doing -L l_arg -S s_arg --contents contents_arg -a -b -c
    # TEST 1 EXPECTED RESULTS:
    #       last filtered arg        = doing
    #       2nd-to-last filtered arg = how
    echo "last filtered arg        = $FILE_IN"
    echo "2nd-to-last filtered arg = $REVISION"

    # # testing
    # OUTSIDE_ARRAY="${POSITIONAL_ARGS_ARRAY[-200]}"
    # if [ -z  "$OUTSIDE_ARRAY" ]; then
    #     echo "== is zero-length-string =="
    # fi


    # for i in "${!all_args_array[@]}"; do
    #     arg="${all_args_array[$i]}"
    #     echo "$arg" # debugging
    #     echo "end"
    #     # first_letter="${arg:0:1}"  # See: https://stackoverflow.com/a/10218528/4561887
    #     # # echo "$first_letter" # debugging

    #     # # skip over all optional args beginning with `-`. But, if you see a `-L` or `-S` or
    #     # # `--contents`, skip over the accompanying mandatory positional arg right after those too.
    #     # # This will leave just 1 or 2 positional arguments remaining, with the last arg being
    #     # # `<file>`, and the 2nd-to-last arg (if it exists at all, since it doesn't have to be
    #     # # provided) being either `<rev>` or `<rev>..<rev>`.
    #     # if [ "$arg" == "-L" ] || [ "$arg" == "-S" ] || [ "$arg" == "--contents" ]; then


    #     # if [ "$first_letter" != "-" ]; then
    #     #     positional_args_array+=("$arg") # see: https://stackoverflow.com/a/1951523/4561887
    #     # fi
    # done

    # # For debugging

    # # Sample test call: `git blametool hey how --are -- -you doing`
    # # Expected output:
    # #       hey
    # #       how
    # #       doing
    # for arg in "${positional_args_array[@]}"; do
    #     echo "$arg"
    # done

    # # For debugging
    # # print the last arg in it
    # # See: https://unix.stackexchange.com/a/198789/114401
    # echo "last arg = ${positional_args_array[-1]}"
    # # print the 2nd to last arg in it
    # echo "2nd to last arg = ${positional_args_array[-2]}"

    exit
}

# Get the short commit hash specified by the user's inputs to `git blame`/`git blametool`.
# This will be used as part of the temporary file name, for instance, to make it obvious for which
# commit the temp file is showing `git blame` output.
get_commit_hash() {
    # The
    echo ""
    # See: https://stackoverflow.com/a/1441062/4561887 and see my comments under that answer too.
    # git log -1 --pretty=format:"%h" HEAD~..HEAD


    ####### parse and get `HEAD~..HEAD` part.
    # git rev-parse --short $(git rev-parse HEAD~..HEAD | head -n 1)
}

main() {
    mkdir -p "$TEMP_DIR"

    # get the last argument, which is the file name; see:
    # https://stackoverflow.com/questions/1853946/getting-the-last-argument-passed-to-a-shell-script/1854031#1854031
    FILE_IN="${@: -1}"
    # echo "$FILENAME" # for debugging

    # Read the user's settings.
    editor="$(git config blametool.editor)"
    auto_delete_tempfile_when_done="$(git config blametool.auto-delete-tempfile-when-done)"

    if [ -z "$editor" ]; then  # see `man test` or `man [` for meaning of `-z`
        # If no editor is set by the user, use Sublime Text 3 (subl) as the default
        echo "NOTICE: you have set no text editor as your git blametool, so '$DEFAULT_EDITOR'"
        echo "  ($DEFAULT_EDITOR_DESCRIPTION) will be used by default. To override this setting"
        echo "  and set your own git blametool editor, call"
        echo "  'git config --global blametool.editor [editor-executable]'. Example: "
        echo "  'git config --global blametool.editor gedit'."

        editor="$DEFAULT_EDITOR"
    fi
    echo "git blametool editor = '$editor'."

    if [ -z "$auto_delete_tempfile_when_done" ]; then
        auto_delete_tempfile_when_done="true"
    fi

    # See my own answer about `basename`: https://stackoverflow.com/a/60157372/4561887
    # - Ex: if `FILE_IN` is "some/path/file.txt", then `FILE_OUT`
    #   will now be simply "file.txt.git-blame".
    FILE_OUT="$(basename "$FILE_IN").git-blame"
    FILE_OUT_FULL_PATH="${TEMP_DIR}/${FILE_OUT}"
    echo "Temporary file path: \"$FILE_OUT_FULL_PATH\"."

    echo "Creating temporary file with output from 'git blame'."
    git blame "$@" > "$FILE_OUT_FULL_PATH"
    # Obtain return code from `git blame`; see: https://stackoverflow.com/a/38533260/4561887
    ret_code="$?"
    # echo "Return code from 'git blame' = $ret_code" # debugging

    # open output in your favorite text editor only if `git blame` is successful
    if [ "$ret_code" -eq "$RETURN_CODE_SUCCESS" ]; then
        echo "Opening temporary file."
        $editor "$FILE_OUT_FULL_PATH"
        sleep 0.5  # give the file time to open
    fi

    if [ "$auto_delete_tempfile_when_done" == "true" ]; then
        echo "Deleting temporary file."
        rm "$FILE_OUT_FULL_PATH"
    fi
}

# --------------------------------------------------------------------------------------------------
# main program entry point
# --------------------------------------------------------------------------------------------------

ALL_ARGS_ARRAY="$@"
FULL_CMD="$0 $ALL_ARGS_ARRAY"

get_revision_and_filename $ALL_ARGS_ARRAY
parse_args $ALL_ARGS_ARRAY
main $ALL_ARGS_ARRAY
