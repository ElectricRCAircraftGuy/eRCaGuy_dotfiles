#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
#
# Gabriel Staples
# Sept. 2024
#
# References:
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/hello_world_best.sh
# 1. 
# 

main() {
    echo "Running main."
    
    TIMEOUT_SEC=3

    # See my answer: https://superuser.com/a/1310142/425838 
    zenity --info --title "My example program" \
        --text "This window will automatically close in $TIMEOUT_SEC seconds..." \
        --timeout="$TIMEOUT_SEC"
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
