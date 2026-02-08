#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Feb. 2026

# See also:
# 1. My answer here: https://stackoverflow.com/a/76794738/4561887
# 2. My repo here: https://github.com/ElectricRCAircraftGuy/eRCaGuy_PathShortener

# Find and fix all files and folders with Windows-illegal characters in their names.
# Illegal characters: \ : * ? " < > |
# These will be replaced with underscores.

# (Optional) Installation
# ```bash
# cd path/to/here
# mkdir -p ~/bin
# ln -s "$(pwd)/fix_windows_illegal_filenames.sh" ~/bin/fix_windows_illegal_filenames
# ln -s "$(pwd)/fix_windows_illegal_filenames.sh" ~/bin/gs_fix_windows_illegal_filenames
# . ~/.bashrc
# ```

# Usage:
# ```bash
# # dry-run mode
# path/to/useful_scripts/fix_windows_illegal_filenames
# # force mode (actually rename files)
# path/to/useful_scripts/fix_windows_illegal_filenames -f
# ```

# Default to dry-run. Only do the replacement if `-f` is passed as an argument to "force" the
# renaming.
if [[ "$1" != "-f" ]]; then
    echo "DRY-RUN MODE: no files will actually be renamed. To rename files, run with '-f' argument."
    echo "Example: $0 -f"
    echo ""
    force="false"
else
    echo "FORCE MODE: files will be renamed. To do a dry-run, run without the -f argument."
    echo "Example: $0"
    echo ""
    force="true"
fi

# Process files depth-first (deepest files first) to avoid renaming parent directories
# before their children
find . -depth -name '*[\\:\*?\"<>|]*' | while IFS="" read -r filepath; do
    # Get directory and filename separately
    dir="$(dirname "$filepath")"
    filename="$(basename "$filepath")"

    # Replace illegal characters with underscores, using parameter expansion to handle each
    # character
    new_filename="$filename"
    new_filename="${new_filename//\\/_}"  # backslash
    new_filename="${new_filename//:/_}"   # colon
    new_filename="${new_filename//\*/_}"  # asterisk
    new_filename="${new_filename//\?/_}"  # question mark
    new_filename="${new_filename//\"/_}"  # double quote
    new_filename="${new_filename//</_}"   # less than
    new_filename="${new_filename//>/_}"   # greater than
    new_filename="${new_filename//|/_}"   # pipe

    # Only rename if the name actually changed
    if [ "$filename" != "$new_filename" ]; then
        new_filepath="$dir/$new_filename"
        echo "Renaming: $filepath"
        echo "      to: $new_filepath"

        if [[ "$force" == "true" ]]; then
            # Use `-n` to avoid overwriting existing files
            mv -n "$filepath" "$new_filepath"
        fi
    fi
done

echo ""
echo "Done fixing Windows-illegal filenames."
