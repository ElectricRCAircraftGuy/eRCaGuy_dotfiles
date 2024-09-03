#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Gabriel Staples
# Sept. 2024


echo "Would you like to install all of these Templates into '~/Templates/'?" \
     "This will be done by making symlinks to them in '~/Templates/'. (y/N)"

read -r response
# GS note: `=~` is the regex match operator in bash. The `^` then means in regex the "start of line"
# and the `$` means "end of line".
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Make the `~/Templates` directory if it doesn't already exist
    mkdir -p ~/Templates

    # Make symlinks to all of the files in this directory in `~/Templates`
    for file in *; do
        if [[ -f "$file" ]]; then
            ln -sir "$(pwd)/$file" ~/Templates/
        fi
    done
    echo "Templates have been installed into '~/Templates'."
else
    echo "No Templates have been installed."
fi
