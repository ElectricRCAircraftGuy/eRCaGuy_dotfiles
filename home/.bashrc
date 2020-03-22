# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS: 
# Edit as desired, then copy to ~/.bashrc
# Option 1) doesn't exist yet, so copy whole thing over: `cp -i .bashrc ~`
# Option 2) append contents to existing .bashrc file: `cat .bashrc >> ~/.bashrc`

# ======================================================================================================================
# START OF THE STANDARD UBUNTU-18-INSTALLED .bashrc FILE
# - some minor additions or changes from the original may exist, indicated by comments which begin with "# GS"
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias rgrep='rgrep --color=auto' # GS added
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# END OF THE STANDARD UBUNTU-18-INSTALLED .bashrc FILE
# - some minor additions or changes from the original may exist, indicated by comments which begin with "# GS"
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Some nice nuggets to put in the bottom of your "~/.bashrc" file!
# ----------------------------------------------------------------------------------------------------------------------

# GS: show 1) the shell level and 2) the currently-checked-out git branch whenever you are inside any directory 
# containing a local git repository
# See: https://stackoverflow.com/questions/4511407/how-do-i-know-if-im-running-a-nested-shell/57665918#57665918
git_show_branch() {
    __gsb_BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
    if [ -n "$__gsb_BRANCH" ]; then
        echo "$__gsb_BRANCH"
    fi
}
# OLD:
# - shows shell level, git branch (if in a dir with one), and `hostname present_dir $ ` only, rather than username too
# - has no color
# PS1="\e[7m\$(git_show_branch)\e[m\n\h \w $ "
# PS1='\$SHLVL'":$SHLVL $PS1"
# NEW:
# - shows shell level, git branch (if in a dir with one), and `username@hostname:present_dir$ `; ie: it simply adds
#   the shell level and git branch on a line above the default-Ubuntu-18-installation prompt
# - has color, like a default Ubuntu 18 installation does too!
PS1="\e[7m\$(git_show_branch)\e[m\n$PS1"
PS1='\$SHLVL'":$SHLVL $PS1"

# GS: git branch backups: useful to back up git branch hashes before deleting branches, so you can 
# always have their hashes to go back to to checkout rather than having to dig through your `git reflog` forever.
# - Note that this currently requires that the GIT_BRANCH_HASH_BAK_DIR directory already exists. 
# - TODO: fail more gracefully: make it check to see if this dir exists & prompt the user for permission to 
#   auto-create it with `mkdir -p ${GIT_BRANCH_HASH_BAK_DIR}` if it does not.
# Syntax: `gs_git_branch_hash_bak [dir]` = back up to a backup file in directory "dir" if a dir is passed in
GIT_BRANCH_HASH_BAK_DEFAULT_DIR="./git_branch_hash_backups"
gs_git_branch_hash_bak () {
    GIT_BRANCH_HASH_BAK_DIR="$GIT_BRANCH_HASH_BAK_DEFAULT_DIR"
    if [ -n "$1" ]; then
        # If an arg is passed in, then use it instead of the default directory!
        GIT_BRANCH_HASH_BAK_DIR="$1"
    fi
    DATE=`date +%Y%m%d-%H%Mhrs-%Ssec`
    BRANCH="$(git_show_branch)"
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
alias gs_git_branch_hash_bak_echo='echo -e "This is a bash function in \"~/.bashrc\" which backs up git branch names \
& short hashes to your local \"${GIT_BRANCH_HASH_BAK_DEFAULT_DIR}\" (or other specified) dir."'
# Alias to do the git hash backups in a directory one higher so you don't have to add this backup dir
# to this git project's .gitignore file
alias gs_git_branch_hash_bak_up1="gs_git_branch_hash_bak \"../git_branch_hash_backups\""
alias gs_git_branch_hash_bak_up1_echo="echo gs_git_branch_hash_bak \"../git_branch_hash_backups\""

# Edit this ssh command! Make the username, domain_name, & options what they should be for you.
# Note: enable X11 window forwarding with `-X`; see here: 
# https://unix.stackexchange.com/questions/12755/how-to-forward-x-over-ssh-to-run-graphics-applications-remotely/12772#12772
SSH_CMD="ssh -X username@domain_name" 
alias gs_ssh="$SSH_CMD"
alias gs_ssh_echo="echo '$SSH_CMD'"

#-----------------------------------------------------------------------------------------------------------------------
# TERMINAL TABS & TITLE (START)

# Back up original PS1 Prompt 1 string when ~/.bashrc is first sourced upon bash opening; this must be placed
# AFTER all other modifications have already occured to the `PS1` Prompt String 1 variable
if [[ -z "$PS1_BAK" ]]; then # If length of this str is zero (see `man test`)
    PS1_BAK=$PS1 
fi

# Set the title string at the top of your current terminal window or terminal window tab.
# See: https://unix.stackexchange.com/questions/177572/how-to-rename-terminal-tab-title-in-gnome-terminal/566383#566383
# and: https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563
# - Example usage: 
#   - A) Static title strings (title remains fixed): 
#     - `set-title my tab 1` OR `set-title "my tab 1"`
#     - `set-title $PWD` OR `set-title "$PWD"`
#   - B) Dynamic title strings (title updates each time you enter any terminal command): you may use function calls or 
#     variables within your title string and have them *dynamically* updated each time you enter a new command.
#     Simply enter a command or access a global variable inside your title string. **Be sure to use _single quotes_ 
#     around the title string for this to work!**: 
#     - `set-title '$PWD'` - this updates the title to the Present Working Directory every time you `cd` to a new
#        directory!
#     - `set-title '$(date "+%m/%d/%Y - %k:%M:%S")'` - this updates the title to the new date and time every time
#        it changes *and* you enter a new terminal command! The format looks like this: `02/06/2020 - 23:32:58`
gs_set-title() {
    # Set the PS1 title escape sequence; see "Customizing the terminal window title" here: 
    # https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    TITLE="\[\e]2;$@\a\]" 
    PS1=${PS1_BAK}${TITLE}
}
alias gs_set-title_echo='echo -e "This is a bash function in \"~/.bashrc\" which sets the title of your \
currently-opened terminal tab'

# Set the title to a user-specified value if and only if TITLE_DEFAULT has been previously set and
# exported by the user. This can be accomplished as follows:
#   export TITLE_DEFAULT="my title"
#   . ~/.bashrc
# Note that sourcing the ~/.bashrc file is done automatically by bash each time you open a new bash 
# terminal, so long as it is an interactive (use `bash -i` if calling bash directly) type terminal
if [[ -n "$TITLE_DEFAULT" ]]; then # If length of this is NONzero (see `man test`)
    gs_set-title "$TITLE_DEFAULT"
fi

# ----------------------------------------------
# Configure default tabs to open if desired
# - UPDATE TITLES AND CMDS TO SUIT YOUR NEEDS!
# - See: https://askubuntu.com/questions/315408/open-terminal-with-multiple-tabs-and-execute-application/1026563#1026563
# ----------------------------------------------

# Tab titles
DEFAULT_TABS_TITLE1="git"
DEFAULT_TABS_TITLE2="bazel"
DEFAULT_TABS_TITLE3="Python"
DEFAULT_TABS_TITLE4="other"

# Tab commands
# Note: use quotes like this if there are spaces in the path: `DEFAULT_TABS_CMD3="cd '$HOME/temp/test folder'"`
DEFAULT_TABS_CMD1="cd '$HOME/dev'"
DEFAULT_TABS_CMD2="cd '$HOME/dev'"
DEFAULT_TABS_CMD3="cd '$HOME/dev'"
DEFAULT_TABS_CMD4="cd '$HOME/dev'"

# Call this function to open up the following tabs, calling the desired command in each tab and setting
# the title of each tab as desired. This is really helpful to get your programming environment set up
# for software development work, for instance.
gs_open_default_tabs() {
    gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='$DEFAULT_TABS_TITLE1'; $DEFAULT_TABS_CMD1; exec bash;"
    gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='$DEFAULT_TABS_TITLE2'; $DEFAULT_TABS_CMD2; exec bash;"
    gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='$DEFAULT_TABS_TITLE3'; $DEFAULT_TABS_CMD3; exec bash;"
    gnome-terminal --tab -- bash -ic "export TITLE_DEFAULT='$DEFAULT_TABS_TITLE4'; $DEFAULT_TABS_CMD4; exec bash;"
}

# This chunk of code allows one to essentially call `open_default_tabs` from another script to open up all 
# default tabs in a brand new terminal window simply by entering these lines into your script:
#   export OPEN_DEFAULT_TABS=true
#   gnome-terminal          # this also sources ~/.bashrc (this script)
#   OPEN_DEFAULT_TABS=      # set this variable back to an empty string so it's no longer in force
#   unset OPEN_DEFAULT_TABS # unexport it
# See "eRCaGuy_dotfiles/useful_scripts/open_programming_tools.sh" for a full example & more detailed comments.
if [[ -n "$OPEN_DEFAULT_TABS" ]]; then # If length of this is NONzero (see `man test`)
    # Reset to an empty string so this only happens ONCE since ~/.bashrc is about to be sourced recursively
    OPEN_DEFAULT_TABS= 
    gs_open_default_tabs
    # close the calling process so only the "default tabs" are left open while the initial `gnome-terminal` tab
    # that opened all the other tabs is now closed
    exit 0 
fi

# TERMINAL TABS & TITLE (END)
#-----------------------------------------------------------------------------------------------------------------------

# Play sound; very useful to add to the end of a long cmd you want to be notified of when it completes!
# Ex: `long_cmd; gs_sound_bell` will play the sound bell when `long_cmd` completes!
CMD="echo -e \"\a\""
alias gs_sound_bell="$CMD"
alias gs_sound_bell_echo="echo '$CMD'"

# Even better, have a pop-up notification too! 
# Ex: `long_cmd; gs_alert` will play the sound above *and* pop up a notification when complete!
# See more details, & screenshot of popup, here: 
# https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/1213564#1213564
CMD="gs_sound_bell; alert \"task complete\""
alias gs_alert="$CMD"
alias gs_alert_echo="echo '$CMD'"

# More sounds:
# From: https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/604116#604116
sound() {
  # plays sounds in sequence and waits for them to finish
  for s in $@; do
    paplay $s
  done
}
sn1() {
  sound /usr/share/sounds/ubuntu/stereo/dialog-information.ogg
}
sn2() {
  sound /usr/share/sounds/freedesktop/stereo/complete.oga
}
sn3() {
  sound /usr/share/sounds/freedesktop/stereo/suspend-error.oga
}

# Text to speech as a sound:
# See also: https://askubuntu.com/questions/277215/how-to-make-a-sound-once-a-process-is-complete/587575#587575
# Ex: `long_cmd; spd-say done` <=== AMAZING! 


