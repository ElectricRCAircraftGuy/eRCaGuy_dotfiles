#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# This program allows you to quickly open up any file you want in Sublime Text by selecting files
# with the `fzf` fuzzy finder and then passing them to `subl`. Just run it and you'll see what I
# mean!

# STATUS: WORK-IN-PROGRESS! It works, but it needs some massive cleanup in the comments and I need
# to generally clean up and refactor the code as necessary. It does work though, so feel free
# to use it.

####### sample alias
# see also: https://stackoverflow.com/a/69830768/4561887
# alias sublf_custom='sublf -not \( -path "./build*" -prune \)'

# INSTALLATION INSTRUCTIONS:
# 1. Install RipGrep: https://github.com/BurntSushi/ripgrep#installation
# 2. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/rg_replace.sh" ~/bin/rgr            # required
#       ln -si "${PWD}/rg_replace.sh" ~/bin/rg_replace     # required
#       ln -si "${PWD}/rg_replace.sh" ~/bin/gs_rgr         # optional; replace "gs" with your initials
#       ln -si "${PWD}/rg_replace.sh" ~/bin/gs_rg_replace  # optional; replace "gs" with your initials
# 3. Now you can use this command directly anywhere you like in any of these ways:
#   1. `rgr`
#   2. `rg_replace`
#   1. `gs_rgr`
#   3. `gs_rg_replace`

# This opens the fzf fuzzy finder tool (see: https://github.com/junegunn/fzf#usage), then allows
# you to multiselect (`-m`) files with the TAB key. Press ENTER when done to open them all in
# Sublime Text. Be sure to install fzf first for this to work.
# - Watch this YouTube video too for additional help using fzf: https://youtu.be/qgG5Jhi_Els?t=147
#       alias sublf='subl $(fzf -m)'
# Even better: also echo the selected files to the screen!
# USAGE:
#   Run `sublf`. Type to fuzzy search. Press TAB to select a file. Once you have selected all the
#   files you'd like to open, press ENTER to print their paths to the terminal and then open them
#   all up in Sublime Text!
# See also:
# 1. How to show hidden files in the filename search:
#    https://github.com/junegunn/fzf/issues/337#issuecomment-136383876
#
# Development errors:
# If you see this:
#       bash: /home/gabriel/.bash_aliases: line 311: syntax error near unexpected token `('
#       bash: /home/gabriel/.bash_aliases: line 311: `sublf() {'
# Then it's because it still thinks `sublf` is the old alias it used to be! So, run this:
#       unalias sublf
#
# Exclude any ".git" or "..git" dir at any level in the search path.
# Sample usage:
#       sublf     # start the search in the current directory
#       # Or
#       sublf ..  # start the search in the dir up one level
#
#       #### EXCELLENT! Parenthesis force precedence! See the man pages for `man find`; search for "\(" with "\\\("
#       sublf -not \( -path './output/*' -prune \)
########### MAKE THIS A STAND-ALONE FUNCTION IN MY USEFUL_SCRIPTS DIR!
# SEE ALSO MY ANSWER HERE: https://stackoverflow.com/a/70658963/4561887


# Note: to skip this script and quickly search for files, do this:
#       find | fzf -m
# Then, use the arrow keys to move the selector up and down. Press Tab to toggle
# a file selection on and off. Press Enter to return from the program and print
# out the paths to your selected files. Open these manually in whatever editor
# you see fit.
#
# OR, run `sublf`, below, to do all this for you, automatically opening them up
# in Sublime Text or the editor of your choice.

sublf() {
    echo "DEBUG: all args = $@"  # FOR DEBUGGING

    search_path="."
    if [ $# -gt 0 ]; then
        search_path="$1"
        shift  # remove $1 from input args array
    fi

    all_find_args_array=()
    all_find_args_array+=("$search_path")
    all_find_args_array+=("$@")  # pass through all other args to `find`
    # Exclude some dirs we never want to search.
    # For the most-correct `find -not`... syntax, see:
    #   1. https://stackoverflow.com/a/16595367/4561887
    #   2. and my answer here: https://stackoverflow.com/a/69830768/4561887
    all_find_args_array+=(-not \( -path "*/.git/*" -prune \))
    all_find_args_array+=(-not \( -path "*/..git/*" -prune \))

    # Add additional custom user args or excludes
    additional_find_args_or_excludes=()
    if [ -f ~/.sublf_config.sh ]; then
        . ~/.sublf_config.sh
    fi
    all_find_args_array+=("${additional_find_args_or_excludes[@]}")

    echo "DEBUG: all_find_args_array = ${all_find_args_array[@]}"  # FOR DEBUGGING

    files_selected="$(find "${all_find_args_array[@]}" | fzf -m)"

    if [ -z "$files_selected" ]; then
        echo "No files selected."
        exit
    fi

    # Convert list of files to array of files.
    # See:
    # 1. "eRCaGuy_dotfiles/useful_scripts/find_and_replace.sh" for an example of this
    # 1. ***** https://stackoverflow.com/a/24628676/4561887
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS (Internal Field Separator) to newline char
    files_selected_array=($files_selected) # split long string into array, separating by IFS (newline chars)
    IFS=$SAVEIFS   # Restore IFS

    echo "Opening these files or folders in Sublime Text:"
    num_files="${#files_selected_array[@]}"
    i=1
    for file in "${files_selected_array[@]}"; do
        printf "  %2i/%-2i: %s\n" "$i" "$num_files" "$file"
        ((i++))
    done

    # See: https://stackoverflow.com/a/70572787/4561887
    subl "${files_selected_array[@]}"
}
# # aliases to the same thing
# alias fsubl='sublf'
# alias gs_sublf="sublf"
# alias gs_fsubl="fsubl"
# # SEE ALSO the Ripgrep fuzzy finder wrapper in "useful_scripts/rgf.sh".

# Main program entry point
sublf "$@"


###################
#UPDATE MY FIND ANSWER! Explain how to search for "\(" in the man pages like this: "\\\("

# ANSWER THIS!: https://stackoverflow.com/questions/48891543/how-to-make-ctrlc-cancel-a-whole-command-when-interacting-with-a-subshell-comma
# Show 3 ways: 1) trap the signal, 2) check the return code, 3) store the files in a variable and check the length
################
