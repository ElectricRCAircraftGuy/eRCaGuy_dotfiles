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

# From my answer: https://stackoverflow.com/a/76856090/4561887
# Get a short commit hash, and see whether `git status` is clean or dirty.
# Example outputs:
# 1. Not in a git repo: `(not a git repo)`
# 2. In a repo which has a "dirty" `git status`: `72361c8-dirty`
#   - Note that "dirty" means there are pending uncommitted changes.
# 3. In a repo which has a "clean" `git status`: `72361c8`
git_get_short_hash() {
    # See: https://stackoverflow.com/a/16925062/4561887
    is_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    if [ "$is_git_repo" != "true" ]; then
        echo "(not a git repo)"
        return $RETURN_CODE_SUCCESS
    fi

    # See my answer here: https://stackoverflow.com/a/76856090/4561887
    test -z "$(git status --porcelain)" \
        && echo "$(git rev-parse --short HEAD)" \
        || echo "$(git rev-parse --short HEAD)-dirty"
}


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
read -rp "Would you like to continue and remove all items in the list above [y/N]?
(Use Enter or N to cancel & exit).
Note that your '.vscode/' folder will be backed up and restored. " user_continue
if [[ "$user_continue" = [Yy] || "$user_continue" == [Yy][Ee][Ss] ]]; then
    # 1. back up your .vscode folder, if it exists
    back_up_dir="false"
    if [ -e .vscode ]; then
        back_up_dir="true"

        # See: https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/blob/263e9404b36e14869e41c69c051ad74476651e63/pdf2searchablepdf.sh#L305
        timestamp="$(date '+%Y%m%d-%H%M%S.%N')"
        git_short_hash="$(git_get_short_hash)"
        backup_dir="/tmp/.vscode.bak.$timestamp.REPO_$repo_name.COMMIT_$git_short_hash"
        echo "Moving your '.vscode' folder to '$backup_dir'."
        mv .vscode "$backup_dir"
    fi

    # 2. actually delete the files
    echo "Running 'git clean -Xdf'"
    git clean -Xdf

    # 3. restore your .vscode folder, if it existed
    if [ "$back_up_dir" = "true" ]; then
        echo "Restoring your '.vscode' folder from '$backup_dir' to '.vscode'."
        cp -a "$backup_dir" .vscode
    fi
else
    echo "Aborting."
fi

echo "Done."
exit $RETURN_CODE_SUCCESS
