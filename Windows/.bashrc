# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

alias gs_cd_to_dev_w='cd ~/GS-w/dev-w'
alias subl="/c/Program\ Files/Sublime\ Text/subl.exe"

# -------------------------------- START -----------------------------------
# Auto-launch the ssh-agent and load all private keys on Git for Windows
# Copied from: https://stackoverflow.com/a/76568760/4561887
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not
# running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    echo "Starting ssh-agent and adding your private keys."
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    echo "Adding your private keys to ssh-agent."
    ssh-add
fi

unset env
# -------------------------------- END -------------------------------------

# Add Microchip PIC XC32 binary executables to our PATH
DIR="/c/Program Files (x86)/Microchip/xc32/v4.30/bin"
if [ -d "$DIR" ] ; then
    PATH="$DIR:$PATH"
fi

alias make="'/c/Program Files/Microchip/MPLABX/v6.15/gnuBins/GnuWin32/bin/make.exe'"
alias prjMakefilesGenerator="'/c/Program Files/Microchip/MPLABX/v6.15/mplab_platform/bin/prjMakefilesGenerator.bat'"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

