#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# DESCRIPTION:
#
# Same as `git branch` except don't show "hidden", user-backed-up branches.
#
# A special version of `git branch` which hides (doesn't show) any branches which begin with either
# PREFIX1 or PREFIX2 below and would normally show up when you run `git branch`.
#
# This is useful, for instance, so that you can prefix all backup branches with `z-bak` or `_`
# (examples: `z-bak-my_backup_branch_name` or `_my_backup_branch_name`), withOUT having them
# clutter your screen whenever you run `git branch_`. Simply run `git branch_` in place of `git
# branch` from now on.
#
# Since it's a simple wrapper around `git branch`, it takes any and all input parameters/options
# accepted by `git branch`!
#
# For details, see my Stack Overflow answer here: https://stackoverflow.com/a/66574807/4561887.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere as `git branch_` OR
#    as `git-branch_` OR as `gs_git-branch_` OR as `git gs_branch_`. Note that "gs" is my initials.
#    I do these versions with "gs_" in them so I can find all scripts I've written really easily
#    by simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab.
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -si "${PWD}/git-branch_.sh" ~/bin/git-branch_     # required
#           ln -si "${PWD}/git-branch_.sh" ~/bin/git-gs_branch_  # optional; replace "gs" with your initials
#           ln -si "${PWD}/git-branch_.sh" ~/bin/gs_git-branch_  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git branch_`  <=== my preferred way to use this program, so it feels just like `git branch`!
#   2. `git-branch_`
#   3. `git gs_branch_`
#   4. `git-gs_branch_`
#   3. `gs_git-branch_`

# Ignore (don't print with `git branch_`) branch names which begin with
# these prefix strings
PREFIX1="z-bak"
PREFIX2="_"

git branch --color=always "$@" \
| grep --color=never -v "^  $PREFIX1" \
| grep --color=never -v "^  $PREFIX2"

