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

# GS: git branch backups: back up git branch hashes before deleting branches, so you can always have their hashes
# to go back to to checkout rather than having to dig through your `git reflog` forever.
# - Note that this currently requires that the GIT_BRANCH_HASH_BAK_DIR directory already exists. 
# - TODO: fail more gracefully: make it check to see if this dir exists & prompt the user for permission to 
#   auto-create it with `mkdir -p ${GIT_BRANCH_HASH_BAK_DIR}` if it does not.
GIT_BRANCH_HASH_BAK_DIR="./git_branch_hash_backups"
gs_git_branch_hash_bak () {
    DATE=`date +%Y%m%d-%H%Mhrs-%Ssec`
    FILE="${GIT_BRANCH_HASH_BAK_DIR}/git_branch_bak--${DATE}.txt"
    BRANCH="$(git_show_branch)"
    DIR=$(pwd)
    echo -e "pwd = \"$DIR\"" > $FILE
    echo -e "current branch name = \"$BRANCH\"" >> $FILE
    echo -e "\n=== \`git branch -vv\` ===\n" >> $FILE
    git branch -vv >> $FILE
}
alias gs_git_branch_hash_bak_echo='echo -e "This is a bash function in \"~/.bashrc\" which backs up git branch names \
& short hashes to your local \"${GIT_BRANCH_HASH_BAK_DIR}\" dir."'

SSH_TARGET="username.domain_name" # Edit this! Make the username and domain_name what they should be for you.
alias gs_ssh="ssh $SSH_TARGET"
alias gs_ssh_echo='echo "ssh $SSH_TARGET"'

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
    # If the length of string stored in variable `PS1_BAK` is zero...
    # - See `man test` to know that `-z` means "the length of STRING is zero"
    if [[ -z "$PS1_BAK" ]]; then
        # Back up your current Bash Prompt String 1 (`PS1`) into a global backup variable `PS1_BAK`
        PS1_BAK=$PS1 
    fi

    # Set the title escape sequence string with this format: `\[\e]2;new title\a\]`
    # - See: https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    TITLE="\[\e]2;$@\a\]"
    # Now append the escaped title string to the end of your original `PS1` string (`PS1_BAK`), and set your
    # new `PS1` string to this new value
    PS1=${PS1_BAK}${TITLE}
}
alias gs_set-title_echo='echo -e "This is a bash function in \"~/.bashrc\" which sets the title of your \
currently-opened terminal tab'




