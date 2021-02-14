#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: work-in-progress

# Author: Gabriel Staples
# www.GabrielStaples.com
# www.ElectricRCAircraftGuy.com

# DESCRIPTION:
# This is a wrapper around `git diff` to open up the output in your favorite text editor.

# INSTALLATION INSTRUCTIONS:

# instlal plugin



################3
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-changes.sh" ~/bin/git-changes     # required
#       ln -si "${PWD}/git-changes.sh" ~/bin/git-gs_changes  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-changes.sh" ~/bin/gs_git-changes  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git changes`  <=== my preferred way to use this program, so it feels just like a native `git` cmd!
#   2. `git-changes`
#   3. `git gs_changes`
#   4. `git-gs_changes`
#   3. `gs_git-changes`

# References:
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues/13

# EXIT_SUCCESS=0
# EXIT_ERROR=1

# HELP_STR="
# Usage: git changes <common_base> <backup_branch> [any other args to pass to git difftool]

# Brief description:
# See all changes (via `git difftool`) that were just added to `HEAD` (the currently-checked-out
# feature branch) by a merge or rebase of `common_base` (ex: `master` branch) into `HEAD`, but
# **only looking for merge/rebase changes in the files the feature branch had touched or changed**
# (relative to the `common_base`--ex: `master`).

# git-changes.sh
# - quickly compare a newly-rebased branch (your currently-checked-out branch) against its
#   backup branch you should have manually created just before doing the rebase
# - this *requires* that you should have manually created a backup branch before doing the
#   rebase!
# - I recommend you also have a 'git difftool' configured. I use 'meld'. It is amazing. To install it,
#   see my instrucitons here:
#   https://stackoverflow.com/questions/14821358/git-mergetool-with-meld-on-windows/48979939#48979939
# - Here is the whole process:
#         # 1. ensure you have the latest upstream changes from the branch you would like to rebase
#         #    your feature branch **onto**. Let's assume that is 'master':
#         git checkout master
#         git pull origin master
#         # 2. check out the branch you'd like to rebase onto the latest master
#         git checkout my_branch
#         # 3. create a backup branch; NB: \"20200605-2230hrs\" in the backup branch name
#         #    below means 10:30pm (2230hrs) on 5 June 2020.
#         git branch my_branch_BAK_20200605-2230hrs_about_to_rebase
#         # 4. rebase my_branch onto latest master; manually resolve any conflicts as
#         #    necessary
#         git rebase master
#         # 5. now use 'git changes' to compare your newly-rebased 'my_branch' against your
#         #    backup branch from before the rebase, to ensure only valid changes made
#         #    it in during the rebase, and no mistakes were made while rebasing!
#         git changes master my_branch_BAK_20200605-2230hrs_about_to_rebase

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
# "

# print_help() {
#     echo "$HELP_STR"
# }

# if [ $# -lt 1 ]; then
#     echo "ERROR: Not enough arguments supplied"
#     print_help
#     exit $EXIT_ERROR
# fi

RETURN_CODE_SUCCESS=0

TEMP_DIR="$HOME/temp/git-blametool"

mkdir -p "$TEMP_DIR"

# get the last argument, which is the file name; see:
# https://stackoverflow.com/questions/1853946/getting-the-last-argument-passed-to-a-shell-script/1854031#1854031
FILE_IN="${@: -1}"
# echo "$FILENAME" # for debugging

# Get the editor command from the user's settings.
editor="$(git config blametool.editor)"
if [ -z "$editor" ]; then
    # If no editor is set by the user, use Sublime Text 3 (subl) as the default
    echo "NOTICE: you have set no text editor as your git blametool, so Sublime Text 3 ('subl') "
    echo "  will be used by default. To override this setting and set your own git blametool editor,"
    echo "  call 'git config --global blametool.editor [editor-executable]'. Example: "
    echo "  'git config --global blametool.editor gedit'."
    editor="subl"
fi
echo "git blametool editor = '$editor'."

FILE_OUT="${FILE_IN}.git-blame"
FILE_OUT_FULL_PATH="${TEMP_DIR}/${FILE_OUT}"
echo "Temporary file path: \"$FILE_OUT_FULL_PATH\"."

echo "Creating temporary file with output from 'git blame'."
git blame "$@" > "$FILE_OUT_FULL_PATH"
# For return code, see: https://stackoverflow.com/a/38533260/4561887
ret_code="$?"
# echo "Return code from 'git blame' = $ret_code" # debugging

# open it in your favorite text editor only if `git blame` is successful
if [ "$ret_code" -eq "$RETURN_CODE_SUCCESS" ]; then
    echo "Opening temporary file."
    $editor "$FILE_OUT_FULL_PATH"
    sleep 0.5  # give the file time to open
fi

echo "Deleting temporary file."
rm "$FILE_OUT_FULL_PATH"
