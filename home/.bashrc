# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTALLATION & USAGE INSTRUCTIONS:
# - If you are using my bash configuration files for yourself, the primary file you
#   should edit and customize is the ".bash_aliases_private" file, NOT the ".bashrc" file.
# - See the "eRCaGuy_dotfiles/home/README.md" file, with full instructions and details, here:
#   https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home
#
# Option 1) (what you *may* want to use) if you think you will be editing your ~/.bashrc file
# directly, rather than the ~/.bash_aliases_private file like I recommend, then COPY this file
# to ~/.bashrc:
#   Option A) it doesn't exist in your home dir yet, so copy the whole thing over:
#           cp -i .bashrc ~
#   Option B) append the contents of this file to the end of your existing ~/.bashrc file:
#           cat .bashrc >> ~/.bashrc
# Option 2) (recommended, and what I do for most of my computers) if you plan to NOT edit your
# ~/.bashrc file directly, and instead edit only ~/.bash_aliases_private (like I do), then just
# SYMLINK this file from my repo into yoru home dir. This way you can pull my repo to always get
# the latest version of my ~/.bashrc file directly onto your computer too:
#       cd path/to/here
#       ln -si "${PWD}/.bashrc" ~


# ==================================================================================================
# START OF THE STANDARD UBUNTU-18-INSTALLED .bashrc FILE
# - some minor additions or changes from the original may exist, indicated by comments which
#   begin with "# GS"
# - Find a backup copy of Ubuntu's default ~/.bashrc file on Ubuntu in "/etc/skel/.bashrc".
#   See here: https://askubuntu.com/a/404428/327339
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

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

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# END OF THE STANDARD UBUNTU-18-INSTALLED .bashrc FILE
# - some minor additions or changes from the original may exist, indicated by comments which
#   begin with "# GS"
# ==================================================================================================

# Bash aliases and functions below will override any by the same name in both the ".bash_aliases"
# and ".bash_aliases_private" files. I recommend you edit the ".bash_aliases_private" file instead.
# See the "eRCaGuy_dotfiles/home/README.md" file, with full instructions, here:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home

# GS: Automatically added by the `fzf` installer, which was run with these installation commands
# from here: https://github.com/junegunn/fzf#using-git
#
#       git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#       ~/.fzf/install
#
# For more info. on the `fzf` fuzzy-finder, see the official repo here:
# https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# GS: Automatically added by installing the Rust programming language:
# https://www.rust-lang.org/tools/install
# via `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
# - I then wrapped it in this `if` statement to only source the file if it exists.
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# GS: update the Python path to include the **root** dir of any custom modules you have written or
# downloaded! This way you can import those modules using the names starting in the root of those
# paths. See:
# 1. ***** https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH
# 1. ***** https://docs.python.org/3/library/sys.html#sys.path
# 1. Permanently add a directory to PYTHONPATH?
#   1. https://stackoverflow.com/a/3402176/4561887
#   1. https://stackoverflow.com/a/3402196/4561887
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/GS/dev/eRCaGuy_hello_world/python/libraries" ]; then
    # See: https://stackoverflow.com/a/3402176/4561887
    # prepend our new path to the front of the `PYTHONPATH`, so that it takes priority
    export PYTHONPATH="$HOME/GS/dev/eRCaGuy_hello_world/python/libraries:$PYTHONPATH"

    # Notes:
    #
    # 1. You might consider just symlinking all of your custom Python libraries and things into
    # your home dir at the path just above so you don't have to append a bunch of paths to the
    # `PYTHONPATH` above!
    #
    # 2. The above line in bash is equivalent to the following in Python. See:
    #   1. https://stackoverflow.com/a/3402196/4561887
    #   1. https://stackoverflow.com/a/4028943/4561887
    #
    #   ```python
    #   import sys
    #   import pathlib
    #   HOME = str(pathlib.Path.home())
    #   # prepend our new path to the front of the `PYTHONPATH`, so that it takes priority
    #   sys.path.insert(0, f"{HOME}/PythonLibs")
    #   ```
fi

# Added by eRCaGuy_hello_world for importing Python libraries:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world
if [ -d "$HOME/libs_python/libraries" ]; then
    export PYTHONPATH="$HOME/libs_python/libraries:$PYTHONPATH"
fi

# Added by eRCaGuy_hello_world for importing Bash libraries:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world
if [ -d "$HOME/libs_bash/libraries" ]; then
    export BASHLIBS="$HOME/libs_bash/libraries"
fi

# Install Ruby Gems to ~/gems
if [ -d "$HOME/gems" ]; then
    # GS: these lines were automatically added by installing Jekyll by following the instructions
    # here: https://jekyllrb.com/docs/installation/ubuntu/.
    # - I then wrapped them inside this `if` statement to only run them if the directory exists.
    export GEM_HOME="$HOME/gems"
    export PATH="$HOME/gems/bin:$PATH"
fi

# Go lang setup; see: https://go.dev/doc/install
if [ -d "/usr/local/go/bin" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

