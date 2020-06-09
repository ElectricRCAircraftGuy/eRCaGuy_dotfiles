#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: IT WORKS! USE IT.

# Author: Gabriel Staples
# www.ElectricRCAircraftGuy.com 

# DESCRIPTION:
# git-changes.sh
# - quickly check a newly-rebased branch against its backup branch you made prior to rebasing it
# - see full details in the help string below; run `git changes` with no arguments to see the help
#   string get printed out

# INSTALLATION INSTRUCTIONS:
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

# FUTURE WORK/TODO:
# 1. Add a help command: `git changes -h`

# References:
# 1. Obtain all but the first args; see:
#    https://stackoverflow.com/questions/9057387/process-all-arguments-except-the-first-one-in-a-bash-script/9057392#9057392

# Usage: see details in the help string below

# Argument notes:
#
# echo "cmd + next 4 args:"
# echo "0: $0"
# echo "1: $1"
# echo "2: $2"
# echo "3: $3"
# echo "4: $4"
#
# echo "Only arguments 2 and after:"
# echo "${@:2}"
#
# echo "Only arguments 3 and after:"
# echo "${@:3}"

EXIT_SUCCESS=0
EXIT_ERROR=1

HELP_STR="
Usage: git changes <common_base> <backup_branch> [any other args to pass to git difftool]

git-changes.sh
- quickly compare a newly-rebased branch (your currently-checked-out branch) against its
  backup branch you should have manually created just before doing the rebase
- this *requires* that you should have manually created a backup branch before doing the
  rebase!
- Here is the whole process:
        # 1. ensure you have the latest upstream changes from master
        git checkout master
        git pull origin master
        # 2. check out the branch you'd like to rebase onto the latest master
        git checkout my_branch
        # 3. create a backup branch; NB: \"20200605-2230hrs\" in the backup branch name
        #    below means 10:30pm (2230hrs) on 5 June 2020.
        git branch my_branch_BAK_20200605-2230hrs_about_to_rebase
        # 4. rebase my_branch onto latest master; manually resolve any conflicts as 
        #    necessary
        git rebase master
        # 5. now use 'git changes' to compare your newly-rebased my_branch against your
        #    backup branch from before the rebase, to ensure only valid changes made
        #    it in during the rebase, and no mistakes were made while rebasing!
        git changes master my_branch_BAK_20200605-2230hrs_about_to_rebase

This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
"

print_help() {
    echo "$HELP_STR"
}

if [ $# -lt 1 ]; then
    echo "ERROR: Not enough arguments supplied"
    print_help
    exit $EXIT_ERROR
fi

COMMON_BASE_BRANCH="$1"
BACKUP_BRANCH="$2"
# Obtain all but the first args; see:
# https://stackoverflow.com/questions/9057387/process-all-arguments-except-the-first-one-in-a-bash-script/9057392#9057392
ARGS_3_AND_LATER="${@:3}"

merge_base="$(git merge-base $BACKUP_BRANCH $COMMON_BASE_BRANCH)"
files_changed="$(git diff --name-only "$merge_base" $BACKUP_BRANCH)"

echo "Checking for changes against backup branch \"$BACKUP_BRANCH\""
echo "only in these files which were previously-modified by that backup branch:"
echo "--- files originally changed by the backup branch: ---"
echo "$files_changed"
echo "------------------------------------------------------"
echo "Checking only these files for differences between your backup branch and your current branch."

git difftool $ARGS_3_AND_LATER $BACKUP_BRANCH $files_changed

