#!/bin/bash

# Install:
# ln -si "${PWD}/git-diffn.sh" ~/bin/git-diffn
# ln -si "${PWD}/git-diffn.sh" ~/bin/gs_git-diffn

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

# GS I changed this:
# match(bare, "^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@", a) {
#     left = a[1]
#     right = a[2]
#     next
# }
# TO THIS, TO PRINT THIS LINE TOO!
# match(bare, "^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@", a) {
#     left = a[1]
#     right = a[2]
#     print
#     next
# }

git diff --color=always "$@" | \
gawk -v C_RED="\033[31m" '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
  match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];print;next};\
  bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
  {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
  bare~/^-/{printf   "\033[31m-%+4s     \033[m:\033[31m%s\n", left++, line;next};\
  bare~/^[+]/{printf "\033[32m+     %+4s\033[m:\033[32m%s\n", right++, line;next};\
  {printf                    " %+4s,%+4s:%s\n", left++, right++, line;next}' | \
  less -R -F -X

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