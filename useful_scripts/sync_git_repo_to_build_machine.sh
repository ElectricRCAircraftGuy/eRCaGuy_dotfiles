#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# sync_git_repo_to_build_machine.sh
# - Sometimes you need to develop software on one machine (ex: a decent laptop, running an IDE like Eclipse) 
#   while building on a remote server machine (ex: a powerful desktop, or a paid cloud-based server such as 
#   AWS or Google Cloud). The problem, however, is "how do I sync from the machine I work on to the machine 
#   I build on?". This script answers that problem. It uses git to sync from one to the other. Git is 
#   preferred over rsync or other sync tools since they try to sync *everything* and on large repos 
#   they take FOREVER (dozens of minutes, to hours)! This script is lightning-fast (seconds)! 
# - Run it from the *client* machine where you develop code, NOT the server where you will build the code!
# - It MUST be run from a directory inside the repo you are syncing FROM.

# INSTALLATION:
# todo

# References:
# - For notes & reference links see "sync_git_repo_to_build_machine--notes.txt"

# Background Research:
# 1. 

# . ~/.bashrc # contains ##########

DIR_START="$(pwd)"
# echo "DIR_START = $DIR_START" # debugging

DIR_REPO_ROOT="$(git rev-parse --show-toplevel)"
# echo "DIR_REPO_ROOT = $DIR_REPO_ROOT" # debugging
cd "$DIR_REPO_ROOT"

# Make a temp dir one level up from DIR_REPO_ROOT, naming it "repo-name_temp"
BASENAME="$(basename $DIR_REPO_ROOT)"
DIRNAME="$(dirname $DIR_REPO_ROOT)"
TEMP_DIR="${DIRNAME}/${BASENAME}_temp" # this is where temp files will be stored
echo "TEMP_DIR = $TEMP_DIR" # debugging
mkdir -p "$TEMP_DIR"

# See if any changes exist (as normally shown by `git status`). 
# If any changes do exist, back up the file paths which are:
# 1) changed and staged
# 2) changed and not staged
# 3) untracked


# cd back to where we started
cd "$DIR_START"