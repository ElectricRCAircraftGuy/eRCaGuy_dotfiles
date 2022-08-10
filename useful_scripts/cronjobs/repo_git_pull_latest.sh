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
    echo "Cmd:  REMOTE_NAME=\"$REMOTE_NAME\" MAIN_BRANCH_NAME=\"$MAIN_BRANCH_NAME\" PATH_TO_REPO=\"$PATH_TO_REPO\" \"$0\" $@"
    echo "========================================================================================="
}

# --------------- cron job automatic logger code END ---------------
# THE REST OF THE SCRIPT GOES BELOW THIS POINT.
# ------------------------------------------------------------------

main() {
    cd "$PATH_TO_REPO"
    branch_name="$(git rev-parse --abbrev-ref HEAD)"

    # Just exit immediately if the git server is not available. See my answer:
    # https://stackoverflow.com/a/73297645/4561887
    TIMEOUT="40s"
    echo "= Checking to see if the git server is up and running (will time out after $TIMEOUT)..."
    if timeout "$TIMEOUT" git ls-remote --tags > /dev/null 2>&1; then
        # Note: it takes 2~4 sec to get to here.
        echo "= git server IS available"
    else
        # Note: it takes N seconds (as specified by `timeout Ns` above) to get to here.
        echo "= git server is NOT available (check your VPN, if applicable); exiting now"
        exit 1
    fi

    # Handle the edge case where you are in a 'detached HEAD' state, checked-out on some branch-less
    # hash
    if [ "$branch_name" = "HEAD" ]; then
        # capture the commit hash instead, since no branch name exists
        branch_name="$(git rev-parse HEAD)"
    fi

    # if on the wrong branch, commit any uncommitted changes first, if any, then
    # check out the main branch
    started_on_different_branch="false"
    if [ "$branch_name" != "$MAIN_BRANCH_NAME" ]; then
        started_on_different_branch="true"
        echo "= On branch '$branch_name'; need to check out branch '$MAIN_BRANCH_NAME'".

        # Check for uncommitted changes.
        # See my answer, Option 2: https://stackoverflow.com/a/73284206/4561887
        if output="$(git status --porcelain)" && [ -n "$output" ]; then
            echo "= 'git status --porcelain' had no errors AND the working directory" \
                 "is dirty (has UNCOMMITTED changes)."

            echo "= committing changes"
            git add -A
            git commit -m "THESE ARE AUTOMATICALLY-COMMITTED CHANGES; UNCOMMIT ME!"
            echo ""
        fi

        echo "= checking out branch '$MAIN_BRANCH_NAME'"
        git checkout "$MAIN_BRANCH_NAME"
        echo ""
    fi

    echo "= Pulling latest git changes:  time git pull "$REMOTE_NAME" "$MAIN_BRANCH_NAME""
    time git pull "$REMOTE_NAME" "$MAIN_BRANCH_NAME"
    echo ""

    echo "= Pulling latest git lfs changes:  time git lfs pull "$REMOTE_NAME" "$MAIN_BRANCH_NAME""
    time git lfs pull "$REMOTE_NAME" "$MAIN_BRANCH_NAME"
    echo ""

    if [ "$started_on_different_branch" = "true" ]; then
        echo "= checking out branch '$branch_name' again"
        git checkout "$branch_name"
        echo ""
    fi

    echo "= DONE."
    echo ""
}

# --------------------------------------------------------------------------------------------------
# main program entry point
# --------------------------------------------------------------------------------------------------
begin_logging "$@"
time main "$@"
