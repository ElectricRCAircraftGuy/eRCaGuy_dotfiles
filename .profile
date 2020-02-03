# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS: 
# Edit as desired, then copy to ~/.profile
# - Option 1) doesn't exist yet, so copy whole thing over: `cp -i .profile ~`
# - Option 2) append contents to existing .profile file: `cat .profile >> ~/.profile`
# - Note that one important purpose of the ~/.profile file is to add a user's private ~/bin dir to the PATH variable;
#   see: https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path/26059#26059

# ======================================================================================================================
# START OF THE STANDARD UBUNTU-18-INSTALLED .profile FILE
# - some minor additions or changes from the original may exist, indicated by comments which begin with "# GS"
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# END OF THE STANDARD UBUNTU-18-INSTALLED .profile FILE
# - some minor additions or changes from the original may exist, indicated by comments which begin with "# GS"
# ======================================================================================================================

