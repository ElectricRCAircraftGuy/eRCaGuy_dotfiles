#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# WORK IN PROGRESS! <===========
# This is a simple wrapper around RipGrep (`rg`) to allow in-place find-and-replace, since the
# `rg --replace` option replaces only the stdout, NOT the contents of the file.
# `man rg` under the `--replace` section states: "Neither this flag nor any other ripgrep
# flag will modify your files."

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

# References:
# 1. How to use `rg` to do an in-place replacement in a **single file** at a time:
#    https://learnbyexample.github.io/substitution-with-ripgrep/#in-place-workaround
# 1. My feature request to have `rg` do find and replace natively (post link to this wrapper
#    there when done with it!):
#    https://github.com/BurntSushi/ripgrep/issues/2115
# 1. Advanced bash argument parsing example:
#    https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/blob/master/pdf2searchablepdf.sh#L150-L223

# TODO:
# 1. Do advanced bash argument parsing, following the example above, to determine what the regex
#    search pattern is and what the `-r replacement_text` replacement text is. Use this info. to
#    complete the find-and-replace below.

DEBUG_PRINTS_ON="false"  # "true" or "false"
EXECUTABLE_NAME="$(basename "$0")"

HELP_STR="\
////////////////////
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
6. Also search hidden files (files that begin with a dot ('.') in Unix or Linux)
        rgf --hidden

- See also my 'sublf' and 'fsubl' aliases in .bash_aliases.
- Run 'rg -h' or 'man rg' if you wish to see the RipGrep help menu.
- Run 'fzf -h' or 'man fzf' if you wish to see the fzf fuzzy finder help menu.

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

# A function to do debug prints only if `DEBUG_PRINTS_ON` is set to "true".
debug_echo() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        echo $@
    fi
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$HELP_STR" | less -RFX
    exit
fi

PASSED_IN_ARGS="$@"

cmd="rg $PASSED_IN_ARGS"
debug_echo "cmd = \"$cmd\""

file_list="$(rg -l $PASSED_IN_ARGS)"
########
file_list="$(rg --stats -l $PASSED_IN_ARGS)"
debug_echo -e "file_list:\n${file_list}"

# Convert list of files to array of files.
# See "eRCaGuy_dotfiles/useful_scripts/find_and_replace.sh" for an example of this.
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
IFS=$'\n'      # Change IFS (Internal Field Separator) to newline char
filenames_array=($file_list) # split long string into array, separating by IFS (newline chars)
IFS=$SAVEIFS   # Restore IFS

# iterate over array; see: https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
debug_echo "============="
for filename in ${filenames_array[@]}; do
    debug_echo "$filename"
    # file_contents="$(rg --stats --passthru 'test' -r 'best' git-changes.sh)" && printf "%s" "$file_contents" > git-changes.sh
    # file_contents_and_stats="$(rg --stats --passthru 'test' -r 'best' git-changes.sh)"
    file_contents_and_stats="$(rg --stats --passthru $PASSED_IN_ARGS)"
    NUM_STATS_LINES=9
    file_contents="$(head -n -$NUM_STATS_LINES "$file_contents_and_stats")"
    stats="$(tail -n $NUM_STATS_LINES "$file_contents_and_stats")"
    printf "%s" "$file_contents" > git-changes.sh
    printf "%s" "$stats"
done
