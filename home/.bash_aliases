# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTALLATION & USAGE INSTRUCTIONS:
# - If you are pulling in my bash configuration files for your usage, I recommend you leave this
#   file exactly as-is and copy and edit and customize the ".bash_aliases_private" file instead.
# - See the "eRCaGuy_dotfiles/home/README.md" file, with full instructions and details, here:
#   https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home
#
# 1. Make a symlink to this file in your home (~) dir:
#       cd path/to/eRCaGuy_dotfiles/home
#       ln -si "${PWD}/.bash_aliases" ~

# Note: to remind yourself what the definition is for any given alias, just run
# `alias some_alias_name` at the terminal. To see all aliases, run just `alias`. To see
# ALL my custom aliases AND functions AND executable scripts, type `gs_` then press Tab Tab
# (Tab two times).

# ==================================================================================================
# 1. GENERAL (PUBLICLY SHARED) Bash Setup, Variables, Aliases, & Functions
# ==================================================================================================

# Edit Prompt String 1 (PS1) variable to show 1) the shell level and 2) the currently-checked-out
# git branch whenever you are inside any directory containing a local git repository.
# See: [my ans] https://stackoverflow.com/questions/4511407/how-do-i-know-if-im-running-a-nested-shell/57665918#57665918
gs_git_show_branch() {
    GIT_BRANCH="$(git symbolic-ref -q --short HEAD 2>/dev/null)"
    if [ -n "$GIT_BRANCH" ]; then
        echo "$GIT_BRANCH"
    fi
}
#
# OLD:
# - shows shell level, git branch (if in a dir with one), and `hostname present_dir $ ` only,
#   rather than username too
# - has no color
# PS1="\e[7m\$(gs_git_show_branch)\e[m\n\h \w $ "
# PS1='\$SHLVL'":$SHLVL $PS1"
#
# NEW:
# - shows shell level, git branch (if in a dir with one), and `username@hostname:present_dir$ `
# - ie: it simply adds the shell level and git branch on a line above the
#   default-Ubuntu-18-installation prompt!
# - has color, like a default Ubuntu 18 installation does too!
#
PS1="\e[7m\$(gs_git_show_branch)\e[m\n$PS1" # comment out to NOT show git branch!
PS1='\$SHLVL'":$SHLVL $PS1"                 # comment out to NOT show shell level!

# See which files have changed since some prior commit named `MY_FIRST_COMMIT`.
# Usage:
#       gs_git_files_changed MY_FIRST_COMMIT~
# OR (same thing):
#       gs_git_files_changed BASE_COMMIT
# Known limitations: works only on filenames which have no spaces or special bash chars. To make
# it handle these chars, it will require using `git diff --name-only -z`, with some more
# fancy bash trickery. See my ans:
# https://stackoverflow.com/questions/28109520/how-to-cope-with-spaces-in-file-names-when-iterating-results-from-git-diff-nam/62853776#62853776
gs_git_list_files_changed() {
    files="$(git diff --name-only "$1")"
    echo "These are the changed files:"
    echo "$files"
    # Now optionally create a new function from this and do something with these files here if you
    # want!
}

# Find a file built by Bazel and therefor sitting in the "build/bin" dir.
alias gs_find_bazel_build_file='find -L build/bin | grep'
# note: the below could also be done with `gs_find_bazel_build_file -i somefilename`
alias gs_find_bazel_build_file_i='find -L build/bin | grep -i'

# Put computer to sleep (ie: suspend it).
# See: https://askubuntu.com/questions/1792/how-can-i-suspend-hibernate-from-command-line/1795#1795
alias gs_suspend='systemctl suspend'

############ TODO: fix this up!
# 1. make it stand-alone
# 2. make it work as `git branch_hash_bak [optional message]`
#   - let the optional message just be the remainder of the arguments, so it doesn't require a quote
#   - however, force it to not contain spaces, so replace spaces with underscores
#   - add the optional message into the filename itself at the end
############
# GS: git branch backups: useful to back up git branch hashes before deleting branches, so you can
# always have their hashes to go back to to checkout rather than having to dig through your `git
# reflog` forever.
# - Note that this currently requires that the GIT_BRANCH_HASH_BAK_DIR directory already exists.
# - TODO: fail more gracefully: make it check to see if this dir exists & prompt the user for
#   permission to auto-create it with `mkdir -p ${GIT_BRANCH_HASH_BAK_DIR}` if it does not.
#
# Syntax: `gs_git_branch_hash_bak [dir]` = back up to a backup file in directory "dir" if a dir is
# passed in.
GIT_BRANCH_HASH_BAK_DEFAULT_DIR="./git_branch_hash_backups"
gs_git_branch_hash_bak () {
    CMD="gs_git_branch_hash_bak"
    GIT_BRANCH_HASH_BAK_DIR="$GIT_BRANCH_HASH_BAK_DEFAULT_DIR"
    EXIT_SUCCESS=0
    EXIT_ERROR=1

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        echo "This is a bash function in \"~/.bash_aliases\" which backs up git branch"
        echo "names & short hashes to your local \"${GIT_BRANCH_HASH_BAK_DEFAULT_DIR}\" (or other"
        echo "specified) dir."
        echo ""
        echo "Usage: $CMD [dir]"
        echo "    Back up branch names and hashes to a backup file in directory \"dir\"."
        return $EXIT_SUCCESS
    fi

    if [ -n "$1" ]; then
        # If an arg is passed in, then use it instead of the default directory!
        GIT_BRANCH_HASH_BAK_DIR="$1"
    fi

    DATE=`date +%Y%m%d-%H%Mhrs-%Ssec`
    BRANCH="$(gs_git_show_branch)"
    DIR=$(pwd)
    REPO=$(basename "$DIR") # repository name
    # Replace any spaces in the repository name with underscores
    # See: https://stackoverflow.com/questions/19661267/replace-spaces-with-underscores-via-bash/19661428#19661428
    REPO="${REPO// /_}"
    FILE="${GIT_BRANCH_HASH_BAK_DIR}/${REPO}_git_branch_bak--${DATE}.txt"

    echo "Backing up 'git branch -vv' info to \"$FILE\"."
    echo -e "date = \"$DATE\"" > $FILE
    echo -e "repo (folder) name = \"$REPO\"" >> $FILE
    echo -e "pwd = \"$DIR\"" >> $FILE
    echo -e "current branch name = \"$BRANCH\"" >> $FILE
    echo -e "\n=== \`git branch -vv\` ===\n" >> $FILE
    git branch -vv >> $FILE
    echo "Done!"
}
# Alias to do the git hash backups in a directory one higher so you don't have to add this backup
# dir to this git project's .gitignore file
alias gs_git_branch_hash_bak_up1="gs_git_branch_hash_bak \"../git_branch_hash_backups\""

# ssh into another computer. Override this ssh command by re-defining it in
# "~/.bash_aliases_private"! Make the username, domain_name, & options what they should be for you.
# Notes:
# 1) enable X11 window forwarding with `-X`; see here:
#    https://unix.stackexchange.com/questions/12755/how-to-forward-x-over-ssh-to-run-graphics-applications-remotely/12772#12772
# 2) keep the connection alive with `-o "ServerAliveInterval 60"`; see here:
#    https://superuser.com/questions/699676/how-to-prevent-ssh-from-disconnecting-if-its-been-idle-for-a-while/699680#699680
alias gs_ssh="ssh -X -o \"ServerAliveInterval 60\" username@domain_name"

# Remotely decrypt a LUKS-encrypted hard drive on a computer during boot, by sshing into a Dropbear
# server on your machine. Here's a Google search to get started learning about this:
# "dropbear ssh remotely decrypt hard drive":
# https://www.google.com/search?q=dropbear+ssh+remotely+decrypt+hard+drive&oq=dropbear+ssh+remotely+decrypt+hard+drive&aqs=chrome..69i57.193j0j4&sourceid=chrome&ie=UTF-8
# alias gs_ssh_dropbear=""

# Mount a remote file system securely over ssh, using sshfs (SSH File System).
# See my own answer here!:
# https://askubuntu.com/questions/791002/how-to-prevent-sshfs-mount-freeze-after-changing-connection-after-suspend/942820#942820
alias gs_sshfs="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
username@server_hostname:/path/on/server/to/mount ~/mnt/my_server"
alias gs_sshfs_umount="sudo umount ~/mnt/my_server"

# Play sound; very useful to add to the end of a long cmd you want to be notified of when it completes!
# Ex: `long_cmd; gs_sound_bell` will play a bell sound when `long_cmd` completes!
alias gs_sound_bell="echo -e \"\a\""

# Even better, have a pop-up notification too!
# Ex: `long_cmd; gs_alert` will play the sound above *and* pop up a notification when complete!
# See more details & a screenshot of the popup on my answer here:
#   https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/1213564#1213564
# For other popup window options, see my other answer here:
#   https://superuser.com/questions/31917/is-there-a-way-to-show-notification-from-bash-script-in-ubuntu/1310142#1310142
alias gs_alert="gs_sound_bell; alert \"task complete\""

# More sounds:
# From: https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/604116#604116
sound() {
    # plays sounds in sequence and waits for them to finish
    for s in $@; do
        paplay $s
    done
}
# Run these commands directly from the terminal to play these sounds; ex: `sn1`, `sn2`, `sn3`
# Tick!
sn1() {
  sound /usr/share/sounds/ubuntu/stereo/dialog-information.ogg
}
# Dingggg!
sn2() {
  sound /usr/share/sounds/freedesktop/stereo/complete.oga
}
# Beeebeebeeebeeebeee!
sn3() {
  sound /usr/share/sounds/freedesktop/stereo/suspend-error.oga
}

# Text to speech as a sound: use cmd: `spd-say "some text to read"`
# Ex: `long_cmd; spd-say done` OR `long_cmd; gs_say_done` <=== AMAZING!
# See also: https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/587575#587575
alias gs_say_done="spd-say \"Done!\""
alias gs_say_complete="spd-say \"Operation Complete!\""

# Find and replace strings in a file.
# I posted this as an answer here:
# https://stackoverflow.com/questions/12144158/how-to-check-if-sed-has-changed-a-file/61238414#61238414
# Usage: `gs_replace_str "regex_search_pattern" "replacement_string" "file_path"`
# Ex:    `gs_replace_str "myFunc(" "myNewFunc(" "my_file.cpp"`
gs_replace_str() {
    CMD="gs_replace_str"
    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        echo "Find and replace strings in a file."
        echo "Usage:   $CMD <\"regex_search_pattern\"> <\"replacement_string\"> <\"file_path\">"
        echo "Example: $CMD \"myFunc(\" \"myNewFunc(\" \"my_file.cpp\""
        return $EXIT_SUCCESS
    fi

    REGEX_SEARCH="$1"
    REPLACEMENT_STR="$2"
    FILENAME="$3"

    num_lines_matched=$(grep -c -E "$REGEX_SEARCH" "$FILENAME")
    # Also count number of matches, NOT just lines (`grep -c` counts lines), in case there are
    # multiple matches per line; see:
    # https://superuser.com/questions/339522/counting-total-number-of-matches-with-grep-instead-of-just-how-many-lines-match/339523#339523
    num_matches=$(grep -o -E "$REGEX_SEARCH" "$FILENAME" | wc -l)

    echo -e "\n${num_matches} matches found on ${num_lines_matched} lines in file \"${FILENAME}\":"

    if [ "$num_matches" -gt 0 ]; then
        # Now *show these exact matches* with their corresponding line 'n'umbers in the file
        grep -n --color=always -E "$REGEX_SEARCH" "$FILENAME"
        # Now actually *DO the string replacing* on the files 'i'n place using the `sed`
        # 's'tream 'ed'itor!
        sed -i "s|${REGEX_SEARCH}|${REPLACEMENT_STR}|g" "$FILENAME"
    fi
}

# Set the title string at the top of your current terminal window or terminal window tab.
# See: https://unix.stackexchange.com/questions/177572/how-to-rename-terminal-tab-title-in-gnome-terminal/566383#566383
# and: https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563
# - Example usage:
#   - A) Static title strings (title remains fixed):
#     - `gs_set_title my tab 1` OR `gs_set_title "my tab 1"`
#     - `gs_set_title $PWD` OR `gs_set_title "$PWD"`
#   - B) Dynamic title strings (title updates each time you enter any terminal command): you may
#     use function calls or variables within your title string and have them *dynamically*
#     updated each time you enter a new command. Simply enter a command or access a global
#     variable inside your title string. **Be sure to use _single quotes_ (`'`) around the title
#     string for this to work!**:
#     - `gs_set_title '$PWD'` - this updates the title to the Present Working Directory every
#        time you `cd` to a new directory!
#     - `gs_set_title '$(date "+%m/%d/%Y - %k:%M:%S")'` - this updates the title to the new
#        date and time every time it changes *and* you enter a new terminal command! The
#        date output of the above command looks like this: `02/06/2020 - 23:32:58`
gs_set_title() {
    CMD="gs_set_title"
    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        echo "Set the title of your currently-opened terminal tab."
        echo "Usage:"
        echo "  1. set a **static** title"
        echo "          $CMD any title you want"
        echo "          # OR"
        echo "          $CMD \"any title you want\""
        echo "  2. set a **dynamic** title, which relies on variables or functions"
        echo "          $CMD '\$(some_cmd)'       # with a dynamically-run command"
        echo "          $CMD '\${SOME_VARIABLE}'  # with a dynamically-expanded variable"
        echo ""
        echo "Examples:"
        echo "  1. static title"
        echo "          $CMD my new title"
        echo "  2. dynamic title"
        echo "          $CMD 'Current Directory is \"\$PWD\"'"
        echo "          $CMD 'Date and time of last cmd is \"\$(date)\"'"
        echo "          # [MY FAVORITE!] To actively show just the directory name"
        echo "          $CMD '\$(basename \"\$(pwd)\")'"
        return $EXIT_SUCCESS
    fi

    TITLE="$@"
    # Set the PS1 title escape sequence; see "Customizing the terminal window title" here:
    # https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    ESCAPED_TITLE="\[\e]2;${TITLE}\a\]"

    # Delete any existing title strings, if any, in the current PS1 variable. See my Q here:
    # https://askubuntu.com/questions/1310665/how-to-replace-terminal-title-using-sed-in-ps1-prompt-string
    PS1_NO_TITLE="$(echo "$PS1" | sed 's|\\\[\\e\]2;.*\\a\\\]||g')"
    PS1="${PS1_NO_TITLE}${ESCAPED_TITLE}"
}

# This opens the fzf fuzzy finder tool (see: https://github.com/junegunn/fzf#usage), then allows
# you to multiselect (`-m`) files with the TAB key. Press ENTER when done to open them all in
# Sublime Text. Be sure to install fzf first for this to work.
# - Watch this YouTube video too for additional help using fzf: https://youtu.be/qgG5Jhi_Els?t=147
#       alias sublf='subl $(fzf -m)'
# Even better: also echo the selected files to the screen!
# USAGE:
#   Run `sublf`. Type to fuzzy search. Press TAB to select a file. Once you have selected all the
#   files you'd like to open, press ENTER to print their paths to the terminal and then open them
#   all up in Sublime Text!
alias sublf='FILES_SELECTED="$(fzf -m)" \
&& echo "$FILES_SELECTED" \
&& subl $(echo "$FILES_SELECTED")'
# 2nd alias to the same thing
alias fsubl='sublf'
alias gs_sublf="sublf"
alias gs_fsubl="fsubl"


# ===================================== SECTION 2 START ============================================
# 2. PERSONAL (PRIVATE) Bash Setup, Variables, Aliases, & Functions
# - Add your personal, custom, or otherwise unshared bash aliases and functions to
#   the "~/.bash_aliases_private" file, which is sourced (imported) here.
# - It is recommended that you edit the "~/.bash_aliases_private" file rather than modifying
#   this file, so that you can keep this file as a symlink to the file in the repo, and easily
#   and regularly pull the latest version of this file from the repo.
# - All bash aliases or functions in "~/.bash_aliases_private", or below, will override any
#   above if they have the same name.

# Import this "~/.bash_aliases_private" file, if it exists.
if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi

# ====================================== SECTION 2 END =============================================


# Back to more GENERAL (PUBLICLY SHARED) Bash Setup, Variables, Aliases, & Functions below:


#--------------------------- CUSTOM TERMINAL TABS & TITLES (START) ---------------------------------

# Set the terminal title to a user-specified value each time your open a terminal or re-source
# the "~/.bashrc" file if and only if `DEFAULT_TERMINAL_TITLE` has been previously set and/or
# exported by the user. This can be accomplished in a number of ways:
# 1. (Best option) Simply assign `DEFAULT_TERMINAL_TITLE` to some value inside
# "~/.bash_aliases_private":
#   a. to use a default title:
#           DEFAULT_TERMINAL_TITLE="some default title"
#   b. to NOT use a default title, either don't define this variable, or define it to be an empty
#   string:
#           DEFAULT_TERMINAL_TITLE=
# 2. In an open terminal, export a value for this variable, then re-source your "~/.bashrc" file:
#   a. turn it on:
#           export DEFAULT_TERMINAL_TITLE="some title"
#           . ~/.bashrc
#   b. turn it off:
#           DEFAULT_TERMINAL_TITLE=
#           # OR
#           unset DEFAULT_TERMINAL_TITLE
#           # then
#           . ~/.bashrc
# 3. Assign and pass in a variable as you re-source the "~/.bashrc" file:
#           DEFAULT_TERMINAL_TITLE="some title" . ~/.bashrc
#
# Note that sourcing the "~/.bashrc" file is done automatically by bash each time you open a new
# bash terminal, as long as it is an interactive type terminal. You can use `bash -i` (if calling
# bash directly) to force it to be an interactive terminal.
if [[ -n "$DEFAULT_TERMINAL_TITLE" ]]; then # If length of this is NONzero (see `man test`)
    gs_set_title "$DEFAULT_TERMINAL_TITLE"
fi

# See the description for this function in its help string just below.
gs_open_default_tabs() {
    CMD="gs_open_default_tabs"
    HELP_STR="\
Call this function to open up a bunch of terminal tabs, as configured in your
\"~/.bash_aliases_private\" file, calling the desired command in each tab and setting the title of
each tab as desired. This is really helpful to get your programming environment set up each day
for software development work, for instance."

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        echo "$HELP_STR"
        return $EXIT_SUCCESS
    fi

    if [ "$TERMINAL" == "terminator" ]; then
        # Example of how to do this in the `terminator` terminal:
        #       terminator --new-tab --command='ls; cd dev; ls; exec bash;'

        # Note: the `bash -ic` trick below is required in order to make the shell command calls
        # "interactive", thereby giving the terminal access to bash aliases and functions defined
        # in "~/.bashrc", "~/.bash_aliases" above, or "~/.bash_aliases_private". Without that trick,
        # commands such as `ll` would NOT work for the user as a `TERMINAL_TAB_CMD`, as `ll` isn't
        # defined yet! (It is defined inside "~/.bashrc" as the bash terminal is opening and
        # sourcing this file).

        if [[ -n "$TERMINAL_TAB_TITLE_01" ]] || [[ -n "$TERMINAL_TAB_CMD_01" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_01'; bash -ic '$TERMINAL_TAB_CMD_01; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_02" ]] || [[ -n "$TERMINAL_TAB_CMD_02" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_02'; bash -ic '$TERMINAL_TAB_CMD_02; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_03" ]] || [[ -n "$TERMINAL_TAB_CMD_03" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_03'; bash -ic '$TERMINAL_TAB_CMD_03; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_04" ]] || [[ -n "$TERMINAL_TAB_CMD_04" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_04'; bash -ic '$TERMINAL_TAB_CMD_04; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_05" ]] || [[ -n "$TERMINAL_TAB_CMD_05" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_05'; bash -ic '$TERMINAL_TAB_CMD_05; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_06" ]] || [[ -n "$TERMINAL_TAB_CMD_06" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_06'; bash -ic '$TERMINAL_TAB_CMD_06; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_07" ]] || [[ -n "$TERMINAL_TAB_CMD_07" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_07'; bash -ic '$TERMINAL_TAB_CMD_07; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_08" ]] || [[ -n "$TERMINAL_TAB_CMD_08" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_08'; bash -ic '$TERMINAL_TAB_CMD_08; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_09" ]] || [[ -n "$TERMINAL_TAB_CMD_09" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_09'; bash -ic '$TERMINAL_TAB_CMD_09; exec bash;'"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_10" ]] || [[ -n "$TERMINAL_TAB_CMD_10" ]]; then
            terminator --new-tab --command="export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_10'; bash -ic '$TERMINAL_TAB_CMD_10; exec bash;'"
        fi

    elif [ "$TERMINAL" == "gnome-terminal" ]; then
        if [[ -n "$TERMINAL_TAB_TITLE_01" ]] || [[ -n "$TERMINAL_TAB_CMD_01" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_01'; $TERMINAL_TAB_CMD_01; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_02" ]] || [[ -n "$TERMINAL_TAB_CMD_02" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_02'; $TERMINAL_TAB_CMD_02; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_03" ]] || [[ -n "$TERMINAL_TAB_CMD_03" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_03'; $TERMINAL_TAB_CMD_03; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_04" ]] || [[ -n "$TERMINAL_TAB_CMD_04" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_04'; $TERMINAL_TAB_CMD_04; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_05" ]] || [[ -n "$TERMINAL_TAB_CMD_05" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_05'; $TERMINAL_TAB_CMD_05; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_06" ]] || [[ -n "$TERMINAL_TAB_CMD_06" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_06'; $TERMINAL_TAB_CMD_06; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_07" ]] || [[ -n "$TERMINAL_TAB_CMD_07" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_07'; $TERMINAL_TAB_CMD_07; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_08" ]] || [[ -n "$TERMINAL_TAB_CMD_08" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_08'; $TERMINAL_TAB_CMD_08; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_09" ]] || [[ -n "$TERMINAL_TAB_CMD_09" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_09'; $TERMINAL_TAB_CMD_09; exec bash;"
        fi

        if [[ -n "$TERMINAL_TAB_TITLE_10" ]] || [[ -n "$TERMINAL_TAB_CMD_10" ]]; then
            gnome-terminal --tab -- bash -ic "export DEFAULT_TERMINAL_TITLE='$TERMINAL_TAB_TITLE_10'; $TERMINAL_TAB_CMD_10; exec bash;"
        fi
    fi
} # gs_open_default_tabs

# This chunk of code allows one to essentially call `gs_open_default_tabs` from another script to
# open up all default tabs in a brand new terminal window. See
# "eRCaGuy_dotfiles/useful_scripts/open_programming_tools.sh" for a full example and more-detailed
# comments.
# You must add these lines to your script:
#       mkdir -p ~/temp
#       if [ ! -f ~/temp/.open_default_tabs ]; then
#           touch ~/temp/.open_default_tabs
#       fi
#       # then either:
#       terminator&
#       # OR
#       gnome-terminal&
# As the terminal opens now, it will see that the file "~/temp/.open_default_tabs" has been created,
# and it will use this as an indicator it should open up all the default tabs automatically!
mkdir -p ~/temp
OPEN_DEFAULT_TABS="false"
if [ -f ~/temp/.open_default_tabs ]; then  # see `man test` for meaning of `-f`
    OPEN_DEFAULT_TABS="true"
fi
if [ "$OPEN_DEFAULT_TABS" == "true" ]; then
    rm ~/temp/.open_default_tabs
    gs_open_default_tabs
    # close the calling process so only the "default tabs" are left open while the initial
    # `gnome-terminal` or `terminator` tab that opened all the other tabs is now closed.
    exit 0
fi

#--------------------------- CUSTOM TERMINAL TABS & TITLES (END) -----------------------------------

