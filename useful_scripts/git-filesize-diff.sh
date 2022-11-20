#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Original Author: @patthoyts: https://stackoverflow.com/a/10847242/4561887
# Modified by: Gabriel Staples
# Status: WIP

# - See which files changed in size, and by how much, from one commit to another in a git
#   repository.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/git-filesize-diff.sh" ~/bin/git-filesize-diff
#       ln -si "${PWD}/git-filesize-diff.sh" ~/bin/gs_git-filesize-diff  # optional
# 2. Now you can use these commands directly anywhere you like.

# References:
# 1. Original Author: @patthoyts: https://stackoverflow.com/a/10847242/4561887


# TODO: fill out the version & author info

# EXIT_SUCCESS=0
# EXIT_ERROR=1

# VERSION="0.1.0"
# AUTHOR="Gabriel Staples"


USAGE='[--cached] [<rev-list-options>...]

git filesize-diff <tree-ish> <tree-ish>

Show file size changes between two commits or the index and a commit.'

. "$(git --exec-path)/git-sh-setup"
args=$(git rev-parse --sq "$@")
[ -n "$args" ] || usage
cmd="diff-tree -r"
[[ $args =~ "--cached" ]] && cmd="diff-index"
eval "git $cmd $args" | {
  total=0
  while read A B C D M P
  do
    case $M in
      M) bytes=$(( $(git cat-file -s $D) - $(git cat-file -s $C) )) ;;
      A) bytes=$(git cat-file -s $D) ;;
      D) bytes=-$(git cat-file -s $C) ;;
      *)
        echo >&2 warning: unhandled mode $M in \"$A $B $C $D $M $P\"
        continue
        ;;
    esac
    total=$(( $total + $bytes ))
    printf '%d\t%s\n' $bytes "$P"
  done
  echo total $total
}


# TODO:
# # ----------------------------------------------------------------------------------------------------------------------
# # Program entry point
# # ----------------------------------------------------------------------------------------------------------------------

# parse_args "$@"
# time main # run main, while also timing how long it takes

