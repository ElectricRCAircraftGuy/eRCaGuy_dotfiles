#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Status: IT WORKS! USE AS A COMPLETE, 100% SYNTAX-COMPATIBLE, DROP-IN REPLACEMENT FOR `git diff`!
#         See details just below.

# Author: Gabriel Staples
# www.ElectricRCAircraftGuy.com 

# Inspired by this question here: 
# "Git diff to show only lines that have been modified:"
# https://stackoverflow.com/questions/18810623/git-diff-to-show-only-lines-that-have-been-modified

# Caveat: I don't really find this script all that useful, but once I wrote `git diffn`, which I
# find to be **extremely useful** since it shows line numbers, writing this script was trivial, and
# it answers the Stack Overflow question above, so I figured I'd write it to be thorough/helpful.

# DESCRIPTION:
# git-diffc.sh = git diff 'c'hanged lines only!
# - a drop-in replacement for `git diff` which shows NOTHING BUT THE CHANGED LINES WHICH `git diff`
#   BEGINS WITH A "+" or "-". Use it *exactly* like `git diff`.
# - since it's just a light-weight awk-language-based wrapper around `git diff`, it accepts ALL 
#   options and parameters that `git diff` accepts. Examples:
#   - `git diffc HEAD~`
#   - `git diffc HEAD~3..HEAD~2`
# - works with any of your `git diff` color settings, even if you are using custom colors
#   - See my answer here for how to set custom diff colors, as well as to see a screenshot of
#     custom-color output from `git diffc`:
#     https://stackoverflow.com/questions/26941144/how-do-you-customize-the-color-of-the-diff-header-in-git-diff/61993060#61993060
#   - Here are some sample `git config` commands from my answer above to set custom `git diff` 
#     colors and attributes (text formatting):
#           git config --global color.diff.meta "blue"
#           git config --global color.diff.old "black red strike"
#           git config --global color.diff.new "black green italic"
#           git config --global color.diff.context "yellow bold"
# - in `git diffc`, color output is ON by default; if you want to disable the output color, you 
#   must use `--no-color` or `--color=never`. See `man git diff` for details. Examples: 
#   - `git diffc --color=never HEAD~`
#   - `git diffc --no-color HEAD~3..HEAD~2`

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere as `git diffc` OR
#    as `git-diffc` OR as `gs_git-diffc` OR as `git gs_diffc`. Note that "gs" is my initials. 
#    I do these versions with "gs_" in them so I can find all scripts I've written really easily 
#    by simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab. 
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-diffc.sh" ~/bin/git-diffc     # required
#       ln -si "${PWD}/git-diffc.sh" ~/bin/git-gs_diffc  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-diffc.sh" ~/bin/gs_git-diffc  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#   1. `git diffc`  <=== my preferred way to use this program, so it feels just like `git diff`!
#   2. `git-diffc`
#   3. `git gs_diffc`
#   4. `git-gs_diffc`
#   3. `gs_git-diffc`

# References:
# 1. git-diffn, which is `git diff` with line 'n'umbers! See:
#   1.  https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-diffn.sh
#   1.  My answer here: https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers/61997003#61997003

# See all of my comments in git-diffn.sh above to help you decipher all of this goobly-gock.
# See also here: https://stackoverflow.com/questions/18810623/git-diff-to-show-only-lines-that-have-been-modified/62009746#62009746
git diff --color=always "$@" | awk '
# 1. Match and then skip "--- a/" and "+++ b/" lines
/^(\033\[(([0-9]{1,2};?){1,10})m)?(--- a\/|\+\+\+ b\/)/ {
    next 
} 
# 2. Now print the remaining "+" and "-" lines ONLY! Note: doing step 1 above first was required or
# else those lines would have been matched by this matcher below too since they also begin with 
# the "+" and "-" symbols.
/^(\033\[(([0-9]{1,2};?){1,10})m)?[-+]/ {
    print $0 
}
' | less -RFX
