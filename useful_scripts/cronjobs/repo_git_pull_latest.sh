#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Gabriel Staples
# ~June~Aug 2022

# DESCRIPTION:
#
# This is a script designed to be run by a nightly cronjob, to pull the latest version of your repo
# through `git` and `git lfs` every night.
#
# This is really useful for very large repos and remote workers (people who work remotely), for
# example. Maybe your repo is 100 GB+ and a `git pull` or `git lfs pull` takes 30 minutes to 3 hrs.
# if it hasn't been run in a few days. So, just run it automatically nightly so you don't have to
# waste that time during the day!

# References:
# 1. My answer on "How to use git lfs as a basic user", which covers "What is the difference between
# `git lfs fetch`, `git lfs fetch --all`, `git lfs pull`, and `git lfs checkout`?"
# 1. How can I view results of my cron jobs?:
#   1. https://superuser.com/q/122246/425838
#   1. https://superuser.com/a/569315/425838 - demonstrates the `exec &>>` redirection operator.
# 1. https://stackoverflow.com/q/49509264/4561887 -
#    [Process substitution]: Explain the bash command "exec > >(tee $LOG_FILE) 2>&1"
#       1. *****+++ The answer!: https://stackoverflow.com/a/49514467/4561887
#          This is how to use bash "process substitution" to get all future output of a script
#          logged to a log file **as well as** printed to stdout, via `tee`!:
#          `exec > >(tee $LOG_FILE) 2>&1`.

# INSTALLATION & USAGE INSTRUCTIONS:
# See the README in this directory.
#
# Variables which must be passed to this script at call-time, OR defined here.
# If you don't want to pass these variables to this script at call-time, just uncomment them and
# update them here instead!
#
# REMOTE_NAME="origin"
# MAIN_BRANCH_NAME="main"
# PATH_TO_REPO="$HOME/GS/dev/some_repo"


# -------------- cron job automatic logger code START --------------

# See my ans: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

# Automatically log the output of this script to a file!
begin_logging() {
    mkdir -p ~/cronjob_logs

    # Redirect all future prints in this script from this call-point forward to both the screen and
    # a log file!
    #
    # This is about as magic as it gets! This line uses `exec` + bash "process substitution" to
    # redirect all future print statements in this script after this line from `stdout` to the
    # `tee` command used below, instead. This way, they get printed to the screen *and* to the
    # specified log file here! The `2>&1` part redirects `stderr` to `stdout` as well, so that
    # `stderr` output gets logged into the file too.
    # See:
    # 1. *****+++ https://stackoverflow.com/a/49514467/4561887 -
    #    shows `exec > >(tee $LOG_FILE) 2>&1`
    # 1. https://superuser.com/a/569315/425838 - shows `exec &>>` (similar)
    exec > >(tee -a "$HOME/cronjob_logs/${SCRIPT_FILENAME}.log") 2>&1

    echo ""
    echo "========================================================================================="
    echo "Running cronjob \"$FULL_PATH_TO_SCRIPT\""
    echo "on $(date)."
    echo "========================================================================================="
}

# --------------- cron job automatic logger code END ---------------
# THE REST OF THE SCRIPT GOES BELOW THIS POINT.
# ------------------------------------------------------------------

main() {
    cd "$PATH_TO_REPO"
    branch_name="$(git rev-parse --abbrev-ref HEAD)"


    echo "= Running 'time git fetch "$REMOTE_NAME" "$MAIN_BRANCH_NAME"' ="
    time git fetch "$REMOTE_NAME" "$MAIN_BRANCH_NAME"
    echo ""

    echo "= Running 'time git lfs fetch "$REMOTE_NAME" "$MAIN_BRANCH_NAME"' ="
    time git lfs fetch "$REMOTE_NAME" "$MAIN_BRANCH_NAME"
    echo ""

    echo "= DONE. ="
    echo ""
}

# --------------------------------------------------------------------------------------------------
# main program entry point
# --------------------------------------------------------------------------------------------------
begin_logging
time main "$@"
