#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# This is a simple script that turns RipGrep (`rg`) into a simple interactive fuzzy finder to find
# content in any files.
# See: https://github.com/junegunn/fzf#3-interactive-ripgrep-integration

# INSTALLATION INSTRUCTIONS:
# 1. Install fzf: https://github.com/junegunn/fzf#installation
#    The "Using git" instructions there, for instance, work great.
# 2. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/rgf.sh" ~/bin/rgf     # required
#       ln -si "${PWD}/rgf.sh" ~/bin/gs_rgf  # optional; replace "gs" with your initials
# 3. Now you can use this command directly anywhere you like in any of these ways:
#   1. `rgf`
#   2. `gs_rgf`

# References:fsub
# 1. https://github.com/junegunn/fzf#3-interactive-ripgrep-integration
# 1. See also my `sublf` and `fsubl` aliases in .bash_aliases.

    echo
    echo "This ('$0') is a simple script that turns RipGrep ('rg') into a simple interactive fuzzy"
    echo "finder to find content in any files. Options passed to this program are passed to 'rg'."
    echo "- See also my 'sublf' and 'fsubl' aliases in .bash_aliases."
    echo "- Run 'rg -h' if you wish to see the RipGrep help menu."
    echo ""
    echo "This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles"
    echo "by Gabriel Staples."
    echo ""

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$HELP_STR" | less -RFX
    exit
fi

PASSED_IN_ARGS="$@"

INITIAL_QUERY=""
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' $PASSED_IN_ARGS" \
  fzf --bind "change:reload:$RG_PREFIX {q} $PASSED_IN_ARGS || true" \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --height=50% --layout=reverse


#   3. Pass in `-i` to make ripgrep act in case 'i'nsensitive mode:
#      `rgf -i`
#   4. You can specify
