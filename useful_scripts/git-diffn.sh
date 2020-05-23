#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Author: Gabriel Staples
# Status: Work in Progress (WIP)

# git-diffn.sh
# - a drop-in replacement for `git diff` which also shows line 'n'umbers! Use it *exactly* like
#   `git diff`, except you'll see these beautiful line numbers as well to help you make sense of
#   your changes. 
# - since it's just a wrapper around `git diff`, it accepts ALL options and parameters that 
#   `git diff` accepts. Examples:
#   - `git diffn HEAD~`
#   - `git diffn HEAD~3..HEAD~2`
# - the one caveat and difference is that if you want to disable the output color, you must use
#   `--no-color` or `--color=never` as your FIRST ARGUMENT, as I'm parsing it as a positional 
#   argument. Examples: 
#   - `git diffn --color=never HEAD~`
#   - `git diffn --no-color HEAD~3..HEAD~2`

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere as `git diffn` OR
#    as `git-diffn` OR as `gs_git-diffn` Note that "gs" is my initials. I do this last version 
#    so I can find all scripts I've written really easily by simply typing "gs_" + Tab + Tab. 
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-diffn.sh" ~/bin/git-diffn
#       ln -si "${PWD}/git-diffn.sh" ~/bin/gs_git-diffn
# 2. Now you can use this command directly anywhere you like in any of the 3 ways:
#   1. `git diffn`
#   2. `git-diffn`
#   3. `gs_git-diffn`

# References:
# 1. This script heavily borrows from @PFudd's script here:
#    https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers/33249416#33249416
# 2. @PFudd expands on @Andy Talkowski's code from here:
#    https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers/32616440#32616440
# 3. I also received help from @Ed Morton and @Inian here: 
#    https://stackoverflow.com/questions/61932427/git-diff-with-line-numbers-and-proper-code-alignment-indentation
# 4. https://www.gnu.org/software/gawk/manual/html_node/Using-Shell-Variables.html
# 5. Dynamic Regexps: https://www.gnu.org/software/gawk/manual/html_node/Computed-Regexps.html


####### ADD A MECHANISM of turning off color, in case the user wants no color. ie: 
# if --color=never then don't do --color=always

# C_RED="\033[31m" # Color code for red
# C_GRN="\033[32m" # Color code for green
# C_OFF="\033[m"   # Code to turn off or "end" the previous color code

# git diff --color=always "$@" | \
# gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
#   match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
#   bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
#   {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
#   bare~/^-/{printf   "\033[31m-%+4s     \033[m:\033[31m%s\n", left++, line;next};\
#   bare~/^[+]/{printf "\033[32m+     %+4s\033[m:\033[32m%s\n", right++, line;next};\
#   {printf                    " %+4s,%+4s:%s\n", left++, right++, line;next}'


# TODO (easy):
# 1. make the whole gawk part below a standalone function called "add_line_numbers() {}"
# 2. if the FIRST param to `git diffn` is `--color=never` or `--no-color`, then do NOT add the
#    --color=always option as you run the command! This will give the user an easy way to turn off
#    color!




# git diff "$@" | \
git diff --color=always "$@" | \
gawk '
{
    bare = $0
    gsub("\033[[][0-9]*m", "", bare)
}

match(bare, "^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@", a) {
    left = a[1]
    right = a[2]
    print
    next
}

bare ~ /^(---|\+\+\+|[^-+ ])/ {
    print
    next
}

{
    line = gensub("^(\033[[][0-9]*m)?(.)", "\\2\\1", 1, $0)
}

bare ~ /^-/ {
    printf "\033[31m-%+4s     \033[m:\033[31m%s\n", left++, line
    next
}

bare ~ /^[+]/ {
    printf "\033[32m+     %+4s\033[m:\033[32m%s\n", right++, line
    next
}

{
    printf " %+4s,%+4s:%s\n", left++, right++, line
    next
}' | less -R -F -X


# ^^  use -R to interpret ANSI color codes, -F to quit if less than one-screen, and -X to not clear
# the screen when less exits!
# See here: https://stackoverflow.com/questions/2183900/how-do-i-prevent-git-diff-from-using-a-pager/14118014#14118014
# and https://unix.stackexchange.com/questions/38634/is-there-any-way-to-exit-less-without-clearing-the-screen/38638#38638

########## ONE MORE THING I'D LIKE TO DO: DO *NOT* consume the "@@ -1,6 +1,7 @@" lines! I want them
# to still stick around. Currently, awk is eating them up it looks like!
#####################


# Need to add the color ENDING strings into their proper places too!
# UPDATE: NEVERMIND! IT causes the ending + and - to lose their colors... :(
# end color code: '\033[m'