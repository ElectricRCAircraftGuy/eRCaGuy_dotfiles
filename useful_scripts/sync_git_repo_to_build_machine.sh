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
# 1. Create symlinks in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -s "${PWD}/sync_git_repo_to_build_machine.sh" ~/bin/sync_git_repo_to_build_machine
# 2. Now cd into a repo you want to sync from a PC1 (ex: some light development machine) to a 
#    PC2 (some powerful build machine), and run this script. Note that I like to add `time` to the 
#    call to see how long it takes!:
#       time sync_git_repo_to_build_machine

# References:
# 1. For main notes & reference links see "sync_git_repo_to_build_machine--notes.txt"
# 1. Bash numerical comparisons: 
#    https://stackoverflow.com/questions/18668556/comparing-numbers-in-bash/18668580#18668580
# 1. How to create a branch in a remote git repository:
#    https://tecadmin.net/how-to-create-a-branch-in-remote-git-repository/

# Background Research:
# 1. Google search for "workflow to develop locally but build remotely" -
#    https://www.google.com/search?q=workflow+to+develop+locally+but+build+remotely&oq=workflow+to+develop+locally+but+build+remotely&aqs=chrome..69i57.7154j0j7&sourceid=chrome&ie=UTF-8
#   1. *****"Developing on a remote server _Without Jupyter and Vim_" - https://matttrent.com/remote-development/
# 1. Google search for "eclipse work local build remote" - 
#    https://www.google.com/search?q=eclipse+work+local+build+remote&oq=eclipse+work+local+build+remote&aqs=chrome..69i57.218j0j9&sourceid=chrome&ie=UTF-8
#   1. https://stackoverflow.com/questions/4216822/work-on-a-remote-project-with-eclipse-via-ssh

# --------------------
# USER PARAMETERS, INCL. SSH PARAMETERS TO SYNC & SSH FROM PC1 TO PC2
# Option 1: set these variables inside your ~/.bashrc file on PC1 (comment out this next line if using Option 2)
. ~/.bashrc
# . "$HOME/.bashrc"####
MY_NAME="gabriel.staples" # No spaces allowed! Recommended to use all lower-case.
# Option 2: set these variables right here (comment out these lines if using Option 1)
# PC2_GIT_REPO_TARGET_DIR="$/home/gabriel/dev/eRCaGuy_dotfiles"
# PC2_SSH_USERNAME="gabriel"
# PC2_SSH_DOMAIN="my_domain"
# --------------------

# Debugging prints
echo "PC2_GIT_REPO_TARGET_DIR = $PC2_GIT_REPO_TARGET_DIR"
echo "PC2_SSH_USERNAME = $PC2_SSH_USERNAME"
echo "PC2_SSH_DOMAIN = $PC2_SSH_DOMAIN"

SYNC_BRANCH="${MY_NAME}_SYNC_TO_BUILD_MACHINE" # The remote git branch we use for file synchronization from PC1 to PC2

get_path_to_this_script () {
    # Find the directory where this script lies
    # - See: https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself/246128#246128
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

    echo "$SOURCE"
}

PATH_TO_THIS_SCRIPT="$(get_path_to_this_script)"
echo "PATH_TO_THIS_SCRIPT = \"$PATH_TO_THIS_SCRIPT\""

# A function to obtain the temporary directory we will use, given a directory to a git repo.
# Call syntax: `get_temp_dir "$REPO_ROOT_DIR`
# Example: if REPO_ROOT_DIR="~/dev/myrepo", then this function will return (echo out) "~/dev/myrepo_temp" as 
#   the temp directory
get_temp_dir () {
    REPO_ROOT_DIR="$1" # Ex: /home/gabriel/dev/eRCaGuy_dotfiles
    BASENAME="$(basename "$REPO_ROOT_DIR")" # Ex: eRCaGuy_dotfiles
    DIRNAME="$(dirname "$REPO_ROOT_DIR")" # Ex: /home/gabriel/dev
    TEMP_DIR="${DIRNAME}/${BASENAME}_temp" # this is where temp files will be stored
    echo "$TEMP_DIR"
}

# Create a temporary directory to store the results, & check the git repo for changes--very similar to 
# what a human is doing when calling `git status`.
# This function determines if any local, uncommitted changes or untracked files exist.
create_temp_and_check_for_changes() {
    # Get git root dir (so you can do `git commit -A` from this dir in case you are in a lower dir--ie: cd to 
    # the root FIRST, then `git commit -A`, then cd back to where you were)
    # See: https://stackoverflow.com/questions/957928/is-there-a-way-to-get-the-git-root-directory-in-one-command/957978#957978
    REPO_ROOT_DIR="$(git rev-parse --show-toplevel)" # Ex: /home/gabriel/dev/eRCaGuy_dotfiles
    # echo "REPO_ROOT_DIR = $REPO_ROOT_DIR" # debugging

    # Make a temp dir one level up from REPO_ROOT_DIR, naming it "repo-name_temp"
    TEMP_DIR="$(get_temp_dir "$REPO_ROOT_DIR")"
    # echo "TEMP_DIR = $TEMP_DIR" # debugging
    mkdir -p "$TEMP_DIR"

    echo "Storing temp files in \"$TEMP_DIR\"."

    # See if any changes exist (as normally shown by `git status`). 
    # If any changes do exist, back up the file paths which are:
    # 1) changed and staged
    # 2) changed and not staged
    # 3) untracked

    FILES_STAGED="$TEMP_DIR/1_staged.txt"
    FILES_NOT_STAGED="$TEMP_DIR/2_not_staged.txt"
    FILES_UNTRACKED="$TEMP_DIR/3_untracked.txt"

    # 1) Get list of changed and staged files:
    # See: https://stackoverflow.com/questions/33610682/git-list-of-staged-files/33610683#33610683
    git diff --name-only --cached > "$FILES_STAGED"
    num_staged=$(cat "$FILES_STAGED" | wc -l)
    echo "  num_staged = $num_staged"

    # 2) Get list of changed and not staged files:
    # See (Implicitly learned from here): https://stackoverflow.com/questions/33610682/git-list-of-staged-files/33610683#33610683
    git diff --name-only > "$FILES_NOT_STAGED"
    num_not_staged=$(cat "$FILES_NOT_STAGED" | wc -l)
    echo "  num_not_staged = $num_not_staged"

    # 3) Get list of untracked files:
    # See: https://stackoverflow.com/questions/3801321/git-list-only-untracked-files-also-custom-commands/3801554#3801554
    git ls-files --others --exclude-standard > "$FILES_UNTRACKED"
    num_untracked=$(cat "$FILES_UNTRACKED" | wc -l)
    echo "  num_untracked = $num_untracked"

    total=$[$num_staged + $num_not_staged + $num_untracked]
    echo "  total = $total"
} 

# On local machine:
# Summary: Look for changes. Commit them to current local branch. Force Push them to remote SYNC branch. 
# Uncommit them on local branch. Restore original state by re-staging any files that were previously staged.
# Done.
sync_pc1_to_remote_branch () {
    echo "===== Syncing PC1 to remote branch ====="
    echo "Preparing to push current branch with all changes (including staged, unstaged, & untracked files)"
    echo "  to remote sync branch."

    create_temp_and_check_for_changes

    # Commit uncommitted changes (if any exist) into a temporary commit we will uncommit later
    made_temp_commit=false
    if [ "$total" -gt "0" ]; then
        # Uncommitted changes *do* exist!
        made_temp_commit=true

        echo "Making a temporary commit of all uncommitted changes."
        cd "$REPO_ROOT_DIR"
        git add -A
        git commit -m "SYNC TO BUILD MACHINE"
    fi

    echo "Force pushing to remote \"$SYNC_BRANCH\" branch."
    echo "ENSURE YOU HAVE YOUR PROPER SSH KEYS FOR GITHUB LOADED INTO YOUR SSH AGENT"
    echo "  (w/'ssh-add <my_github_key>') OR ELSE THIS WILL FAIL!"
    # TODO: figure out if origin is even available (ex: via a ping or something), and if not, error out right here!
    git push --force origin "HEAD:$SYNC_BRANCH" # MAY NEED TO COMMENT OUT DURING TESTING

    # Uncommit the temporary commit we committed above
    if [ "$made_temp_commit" = "true" ]; then
        echo "Uncommitting the temporary commit we made above."
        git reset HEAD~

        # Now re-stage any files that were previously staged
        # See: 1) https://stackoverflow.com/questions/4227994/how-do-i-use-the-lines-of-a-file-as-arguments-of-a-command/4229346#4229346
        # and  2) *****https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/
        # and  3) *****+ [my own ans I just made now]: 
        #         https://stackoverflow.com/questions/4227994/how-do-i-use-the-lines-of-a-file-as-arguments-of-a-command/60276836#60276836
        if [ "$num_staged" -gt "0" ]; then
            echo "Re-staging (via 'git add') any files that were previously staged."
            # `git add` each file that was staged before in order to stage it again like it was
            # - See link 3 just above for how this works
            while IFS= read -r line
            do
                echo "  git add \"$line\""
                git add "$line" 
            done < "$FILES_STAGED"
        fi
    fi

    echo "Done syncing PC1 to remote branch."
}

# This is the main command to run on PC2 via ssh from PC1 in order to sync the remote branch to PC2!
# Call syntax: `update_pc2 "$PC2_GIT_REPO_TARGET_DIR"`
update_pc2 () {
    PC2_GIT_REPO_TARGET_DIR="$1"

    cd "$PC2_GIT_REPO_TARGET_DIR"
    create_temp_and_check_for_changes

    # 1st, back up any uncommitted changes that may exist

    if [ "$total" -gt "0" ]; then
        # Uncommitted changes *do* exist!
        echo "Uncommitted changes exist in PC2's repo, so committing them to new branch to save them in case"
        echo "  they are important."

        # Produce a new branch name to back up these uncommitted changes.
        
        # Get just the name of the currently-checked-out branch:
        # See: https://stackoverflow.com/questions/6245570/how-to-get-the-current-branch-name-in-git/12142066#12142066
        # - Will simply output "HEAD" if in a 'detached HEAD' state (ie: not on any branch)
        current_branch_name=$(git rev-parse --abbrev-ref HEAD)

        timestamp="$(date "+%Y%m%d-%H%Mhrs-%Ssec")"
        new_branch_name="${current_branch_name}_SYNC_BAK_${timestamp}"

        echo "Creating branch \"$new_branch_name\" to store all uncommitted changes."
        git checkout -b "$new_branch_name"

        echo "Committing all changes to branch \"$new_branch_name\"."
        git add -A
        git commit -m "DO BACKUP OF ALL UNCOMMITTED CHANGES ON PC2 (TARGET PC/BUILD MACHINE)"
    fi

    # 2nd, check out the sync branch and pull latest changes just pushed to it from PC1

    # Hard-pull from the remote server to fully overwrite local copy of this branch.
    # See: https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files/8888015#8888015
    # TODO: figure out if origin is even available (ex: via a ping or something), and if not, error out right here!
    echo "ENSURE YOU HAVE YOUR PROPER SSH KEYS FOR GITHUB LOADED INTO YOUR SSH AGENT"
    echo "  (w/'ssh-add <my_github_key>') OR ELSE THESE FOLLOWING STEPS WILL FAIL!"
    echo "Force pulling from remote \"$SYNC_BRANCH\" branch to overwrite local copy of this branch."
    echo "  1st: git fetch origin \"$SYNC_BRANCH\""
    git fetch origin "$SYNC_BRANCH"         # MAY NEED TO COMMENT OUT DURING TESTING
    echo "  2nd: git checkout \"$SYNC_BRANCH\"" 
    # Note: this `git checkout` call automatically checks out this branch from the remote "origin" if this branch
    # is not already present locally
    git checkout "$SYNC_BRANCH"             # MAY NEED TO COMMENT OUT DURING TESTING
    echo "  3rd: git reset --hard \"origin/$SYNC_BRANCH\" (to force-update the local branch to match the origin branch)"
    git reset --hard "origin/$SYNC_BRANCH"  # MAY NEED TO COMMENT OUT DURING TESTING
}

# On remote machine:
# Summary: Look for changes. Commit them to a new branch forked off of current branch. Call it 
# current_branch_SYNC_BAK_20200217-2310hrs. Check out $SYNC_BRANCH branch. Pull and hard reset. 
# Done! We are ready to build now!
sync_remote_branch_to_pc2 () {
    echo "===== Syncing remote branch to PC2 ====="

    echo "PC2_GIT_REPO_TARGET_DIR = $PC2_GIT_REPO_TARGET_DIR"
    PC2_GIT_REPO_TARGET_DIR="/home/gabriel.staples/GS--w/dev--w/repos/cruise"
    echo "PC2_GIT_REPO_TARGET_DIR = $PC2_GIT_REPO_TARGET_DIR"
    # rsync a copy of this script over to a temp dir
    TEMP_DIR="$(get_temp_dir "$PC2_GIT_REPO_TARGET_DIR")"
    echo "TEMP_DIR = \"$TEMP_DIR\""

    # ssh $PC2_SSH_USERNAME@$PC2_SSH_DOMAIN "mkdir -p \"$TEMP_DIR\""
    # rsync "$PATH_TO_THIS_SCRIPT" "$PC2_SSH_USERNAME@$PC2_SSH_DOMAIN:$TEMP_DIR/"

    # TODO--UPDATE--MAY NOT EVEN BE NECESSARY! I CAN JUST CALL `update_pc2()` remotely perhaps..not sure!

    # THE FOLLOWING ARE ALL RUN REMOTELY (OVER SSH) ON PC2 FROM PC1
    ######### TODO: MAKE THIS GET CALLED OVER SSH FROM PC1 TO PC2

    # ssh -t $PC2_SSH_USERNAME@$PC2_SSH_DOMAIN  #"update_pc2 \"$PC2_GIT_REPO_TARGET_DIR\""


    # update_pc2 "$PC2_GIT_REPO_TARGET_DIR"
    echo "Done syncing remote branch to PC2. It should be ready to be built on PC2 now!"
}

# Main code
main () {
    DIR_START="$(pwd)"
    # echo "DIR_START = $DIR_START" # debugging

    # sync_pc1_to_remote_branch########
    sync_remote_branch_to_pc2

    # cd back to where we started
    cd "$DIR_START"

    echo "END!"
}

# Only run main if no input args are given
# Calling syntax: `sync_git_repo_to_build_machine.sh`
if [ "$#" -eq "0" ];  then
    main

# Call only `update_pc2` function if desired
# Calling syntax: `sync_git_repo_to_build_machine.sh update_pc2 <input_arg_to_update_pc2>`
elif [ "$1" = "update_pc2" ];  then
    update_pc2 "$2"
fi
