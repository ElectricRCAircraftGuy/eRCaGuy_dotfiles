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

# Awk-language-specific References:
# 1. awk cheatsheet: https://www.shortcutfoo.com/app/dojos/awk/cheatsheet
# 1. https://www.gnu.org/software/gawk/manual/html_node/Using-Shell-Variables.html
# 1. Dynamic Regexps: https://www.gnu.org/software/gawk/manual/html_node/Computed-Regexps.html
# 1. https://www.gnu.org/software/gawk/manual/html_node/Quoting.html
# 1. awk print: https://www.gnu.org/software/gawk/manual/html_node/Print.html 
# 1. awk printf: https://www.gnu.org/software/gawk/manual/html_node/Basic-Printf.html
# 1. awk printf examples: https://www.gnu.org/software/gawk/manual/html_node/Printf-Examples.html
#   1. Sample data files for all awk examples: https://www.gnu.org/software/gawk/manual/html_node/Sample-Data-Files.html#Sample-Data-Files
# 1. awk String Functions: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html; Including:
#   1. gsub()
#   1. match()
#   1. gensub()
#   1. etc. 
# 1. awk `next` statement: https://www.gnu.org/software/gawk/manual/html_node/Next-Statement.html
# 1. awk variable and shell variable usage
#   1. see the last example here:
#      https://www.gnu.org/software/gawk/manual/html_node/Printf-Examples.html
#   1. and also this info here: 
#      https://www.gnu.org/software/gawk/manual/html_node/Using-Shell-Variables.html
#      

# Awk-language Notes:
# The gist of awk: pattern {action}
# Meaning of tidle (~): ?



####### ADD A MECHANISM of turning off color, in case the user wants no color. ie: 
# if --color=never then don't do --color=always


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


# ANSI Color Codes:
COLOR_RED="\033[31m" # red
COLOR_GRN="\033[32m" # green
COLOR_OFF="\033[m"   # code to turn off or "end" the previous color code

# git diff "$@" | \
git diff --color=always "$@" | \
gawk \
-v RED="$COLOR_RED" \
-v GRN="$COLOR_GRN" \
-v OFF="$COLOR_OFF" \
'
{
    bare = $0
    gsub(/\033[[][0-9]*m/, "", bare)
}

match(bare, /^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@/, array) {
    left = array[1]
    right = array[2]
    print bare
    next
}

bare ~ /^(---|\+\+\+|[^-+ ])/ {
    print bare
    next
}

{
    # line = gensub(/^(\033[[][0-9]*m)?(.)/, "\\2\\1", 1, bare) ########## WHATS THIS DO!? AND WHY?
    line = bare
}

bare ~ /^-/ {
    printf RED "-%+4s     " OFF ":" RED "%s\n", left++, line
    next
}

bare ~ /^[+]/ {
    printf GRN "+     %+4s" OFF ":" GRN "%s\n", right++, line
    next
}

{
    printf " %+4s,%+4s:%s\n", left++, right++, line
    next
}
' \
| less -F -X
# | less -R -F -X


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