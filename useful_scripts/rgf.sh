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

EXECUTABLE_NAME="$(basename "$0")"

HELP_STR="\
This ('$EXECUTABLE_NAME') is a RipGrep interactive fuzzy finder of content in files!

It is a simple wrapper script around Ripgrep and the fzf fuzzy finder that turns RipGrep ('rg') into
an easy-to-use interactive fuzzy finder to find content in any files. Options passed to this
program are passed to 'rg'.

See also: https://github.com/junegunn/fzf#3-interactive-ripgrep-integration

The default behavior of Ripgrep used under-the-hood here is '--smart-case', which means:
    Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise.

EXAMPLE USAGES:

1. Pass in '-i' to make Ripgrep act in case 'i'nsensitive mode:
        rgf -i
2. You can specify a path to search in as well:
        rgf \"path/to/some/dir/to/search/in\"
3. Providing an initial search regular expression is allowed, but only optional:
        rgf \"my regular expression search pattern\"
4. If you do both a regex pattern and a path, follow the order Ripgrep requires:
        rgf \"regex pattern\" \"path\"
5. Search only in \"*.cpp\" files!
        rgf -g \"*.cpp\"

- See also my 'sublf' and 'fsubl' aliases in .bash_aliases.
- Run 'rg -h' or 'man rg' if you wish to see the RipGrep help menu.
- Run 'fzf -h' or 'man fzf' if you wish to see the fzf fuzzy finder help menu.

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

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


