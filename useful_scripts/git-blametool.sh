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

VERSION="0.1.0"
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

    '$SCRIPT_NAME [commit_hash] <file_path>'
            Open up the 'git blame' output for file \"file_path\" from commit or branch
            \"commit_hash\" in your editor specified by 'git config blametool.editor'.
            If no editor is set, the default, '$DEFAULT_EDITOR' ($DEFAULT_EDITOR_DESCRIPTION) is
            used. You can set your editor of choice with
            'git config --global blametool.editor [editor-executable]'.
            Example:
            'git config --global blametool.editor gedit'.
    '$SCRIPT_NAME'
            print this help menu
    '$SCRIPT_NAME -h'
            print this help menu
    '$SCRIPT_NAME -?'
            print this help menu
    '$SCRIPT_NAME -v'
            print author & version

Examples:

    '$SCRIPT_NAME master path/to/myfile.c'
    '$SCRIPT_NAME path/to/myfile.c'

Configuration:

    1. Set your blametool editor:
       'git config --global blametool.editor [editor]'
       Example: set 'subl', for Sublime Text 3:
       'git config --global blametool.editor subl'
    2. Set whether or not to auto-delete the temporary file when done:
       'git config --global blametool.auto-delete-tempfile-when-done [true|false]'
       Be sure to set to 'true' or 'false' (case-sensitive). Example:
       'git config --global blametool.auto-delete-tempfile-when-done true

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

main() {
    mkdir -p "$TEMP_DIR"

    # get the last argument, which is the file name; see:
    # https://stackoverflow.com/questions/1853946/getting-the-last-argument-passed-to-a-shell-script/1854031#1854031
    FILE_IN="${@: -1}"
    # echo "$FILENAME" # for debugging

    # Read the user's settings.
    editor="$(git config blametool.editor)"
    auto_delete_tempfile_when_done="$(git config blametool.auto-delete-tempfile-when-done)"

    if [ -z "$editor" ]; then  # see `man test` for meaning of `-z`
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

parse_args "$@"
main "$@"
