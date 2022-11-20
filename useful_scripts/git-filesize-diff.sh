#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Original Author: @patthoyts: https://stackoverflow.com/a/10847242/4561887
# Modified by: Gabriel Staples
# Status: works!

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

# TODO: run `shellcheck` on this script and clean it up a bunch for readability and best coding
# practices.
# TODO: fill out the version & author info

# EXIT_SUCCESS=0
# EXIT_ERROR=1

# VERSION="0.1.0"
# AUTHOR="Gabriel Staples"


USAGE='
git filesize-diff [options] <tree-ish> <tree-ish>

OPTIONS:
[--cached] [<rev-list-options>...]

Show file size changes between two commits or the index and a commit.
'

# Overcome the error of "You need to run this command from the toplevel of the working tree."
# if running this script in a subdir of the repo by first cd'ing to the repo root, then cd'ing
# back to the starting dir when done.
starting_dir="$(pwd)"
repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

. "$(git --exec-path)/git-sh-setup"
args=$(git rev-parse --sq "$@")
[ -n "$args" ] || usage
cmd="diff-tree -r"
[[ $args =~ "--cached" ]] && cmd="diff-index"
eval "git $cmd $args" | {

  printf -- "Num Bytes changed\n"
  printf -- "      |\n"
  printf -- "      v     Filename\n"
  printf -- "----------  ---------------------------\n"
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
    printf '%10d  %s\n' $bytes "$P"
  done
  echo "------------------------------"
  echo "total change:  $total bytes"

}

cd "$starting_dir"


# TODO:
# # ----------------------------------------------------------------------------------------------------------------------
# # Program entry point
# # ----------------------------------------------------------------------------------------------------------------------

# parse_args "$@"
# time main # run main, while also timing how long it takes

