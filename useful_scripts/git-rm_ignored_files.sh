#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# June 2023

# DESCRIPTION:
# Delete all ignored files in a git repository.
# - Remove (after listing all files and asking you for permission) all files and directories in
#   all .gitignore files in whichever repo you are currently cd'ed into.
# - In other words, running this script in any repo you are in will run `git clean -Xdn` to list all
#   files which *will be* deleted, followed by `git clean -Xdf` to actually delete them, if you
#   give it permission.
# - This helps you easily clean out build files and stuff periodically, kind of like a strong and
#   thorough `make clean` whenever needed.

# LINT:
# Lint/check this file to check it for errors or bad Bash programming practices with. If
# `shellcheck` comes back clean (ie: if it has no output at all), then there are no errors to fix!
#
#       shellsheck path/to/git-rm_ignored_files.sh
#

# INSTALLATION INSTRUCTIONS:
#
#       # 1. Ensure ~/bin is in your PATH
#       mkdir -p ~/bin
#       . ~/.profile
#
#       # 2. Add symlinks to this script
#       cd path/to/here
#       ln -si "${PWD}/git-rm_ignored_files.sh" ~/bin/git-rm_ignored_files     # required
#       ln -si "${PWD}/git-rm_ignored_files.sh" ~/bin/git-gs_rm_ignored_files  # optional; replace "gs" with your initials
#       ln -si "${PWD}/git-rm_ignored_files.sh" ~/bin/gs_git-rm_ignored_files  # optional; replace "gs" with your initials
#
#       # 3. Run it, using any of the 3 symlinks which are now in your PATH!
#       # Any of these several commands will now work, due to the 3 symlinks above:
#       git rm_ignored_files  # my preference
#       git-rm_ignored_files
#       git gs_rm_ignored_files  # also useful when typing `git gs_` then pressing Tab Tab to see all of my custom git commands
#       git-gs_rm_ignored_files
#       gs_git-rm_ignored_files  # also useful when typing `gs_` then pressing Tab Tab to see all of my custom commands
#

# REFERENCES:
# 1. My git & Linux cmds doc: "eRCaGuy_dotfiles/git & Linux cmds, help, tips & tricks - Gabriel.txt"
#    - search this file for "git clean -X"
# 1. Finding the repo root dir with `git rev-parse --show-toplevel`:
#    https://stackoverflow.com/a/957978/4561887


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1


# List of folders to not delete
DIRS_TO_RESTORE=(
    ".vscode"
    "build"
)

# Echo a regular bash array. 
echo_array() {
    local -n array_reference="$1"
    for element in "${array_reference[@]}"; {
        echo "  $element"
    }
}

git_rm_ignored_files() {
    # Note: `repo_dir` will contain the full path to the repo root dir.
    # See: https://stackoverflow.com/a/957978/4561887
    if ! repo_dir="$(git rev-parse --show-toplevel)"; then
        echo "Error: you are not in a git repository."
        exit $RETURN_CODE_ERROR
    fi
    repo_name="$(basename "$repo_dir")"

    cd "$repo_dir" || exit $RETURN_CODE_ERROR

    echo "Removing all of these files and folders that are in .gitignore files in this repo:"
    echo "== LIST START ==="
    git clean -Xdn
    echo "== LIST END ==="
    echo "Note that the list above may be empty if there is nothing to do."

    echo "NB: the following directories will be BACKED UP AND RESTORED, and therefore NOT deleted,"\
        "even if present in the list above:"
    echo_array DIRS_TO_RESTORE

    echo "Would you like to continue and remove all items in the list above,"\
         "except for those which will be backed up and restored [y/N]?"
    read -rp "(Use Enter or N to cancel & exit)." user_continue
    echo ""
    if [[ "$user_continue" = [Yy] || "$user_continue" == [Yy][Ee][Ss] ]]; then
        # 1. Back up the dirs to restore, if they exist
        backup_dir="None"
        for dir in "${DIRS_TO_RESTORE[@]}"; do
            if [ -e "$dir" ]; then
                if [ "$backup_dir" = "None" ]; then
                    echo "Backing up your folders to restore:"
                    backup_dir="$(mktemp -d)"
                fi
                target_path="$backup_dir/$dir"
                echo "  Moving your '$dir' folder to '$target_path'."
                mv "$dir" "$backup_dir"
            fi
        done
        
        # 2. actually delete the files
        echo "Running 'git clean -Xdf', removing all of these files and folders that are in"\
            ".gitignore files in this repo:"
        git clean -Xdf
        echo "Done running 'git clean -Xdf'."

        # 3. restore your backed-up dirs
        if [ "$backup_dir" != "None" ]; then
            echo "Restoring your backed-up folders:"
            for dir in "${DIRS_TO_RESTORE[@]}"; do
                from_path="$backup_dir/$dir"
                if [ -e "$from_path" ]; then
                    echo "  Restoring your '$dir' folder from '$from_path' to '$dir'."
                    mv "$from_path" "$dir"
                fi
            done
        fi
    else
        echo "Aborting."
    fi

    echo "Done."
}

main() {
    git_rm_ignored_files
    exit $RETURN_CODE_SUCCESS
}

# Determine if the script is being sourced or executed (run).
# See:
# 1. "eRCaGuy_hello_world/bash/if__name__==__main___check_if_sourced_or_executed_best.sh"
# 1. My answer: https://stackoverflow.com/a/70662116/4561887
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # This script is being run.
    __name__="__main__"
else
    # This script is being sourced.
    __name__="__source__"
fi

# Only run `main` if this script is being **run**, NOT sourced (imported).
# - See my answer: https://stackoverflow.com/a/70662116/4561887
if [ "$__name__" = "__main__" ]; then
    main "$@"
fi
