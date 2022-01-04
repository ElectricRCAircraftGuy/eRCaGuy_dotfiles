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
# 1. Also post here when done: https://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files/580328#580328

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="true"  # "true" or "false"; can also be passed in as an option: `-d` or `--debug`

SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="rgr ('$SCRIPT_NAME') version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

HELP_STR="\
$VERSION_SHORT_STR

possible letters (these are the only free lowercase single-letter 'rg' options as of 3 Jan. 2021):
    -d, -k, -y,


    -d, --in-place
        Replace in-place. '-i' was taken, so think of '-d' as meaning it will 'd'elete
        the original file and replace it with a new one.


////////////////////
This ('$SCRIPT_NAME') is a RipGrep interactive fuzzy finder of content in files!

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
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "DEBUG: "
        echo "$@"
    fi
}

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Unit Tests
# Cmd: `<this_script_name> --run_tests`
run_tests() {
    echo "Running unit tests"
    # todo; ex: `rg_replace_unit_tests.sh`
}

parse_args() {
    # For advanced argument parsing help and demo, see:
    # https://stackoverflow.com/a/14203146/4561887

    if [ $# -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        exit $RETURN_CODE_ERROR
    fi

    all_args_array=("$@")  # See: https://stackoverflow.com/a/70572787/4561887
    regex=""  # regular expression search pattern to look for
    replacement_text=""
    overwrite_file="false"
    paths_array=()  # array of paths to search in for the `regex` pattern
    ripgrep_args_array=()  # arguments to always be passed to ripgrep

    while [[ $# -gt 0 ]]; do
        arg="$1"
        # first letter of `arg`; see: https://stackoverflow.com/a/10218528/4561887
        first_letter="${arg:0:1}"

        case $arg in
            # --------------------------------------------------------------------------------------
            # 1. Parse options handled by this rgr wrapper
            # --------------------------------------------------------------------------------------

            # Help menu
            "-h"|"-?"|"--help")
                print_help
                exit $RETURN_CODE_SUCCESS
                ;;
            # Version
            "-v"|"--version")
                print_version
                exit $RETURN_CODE_SUCCESS
                ;;
            # Unit tests
            "--run_tests")
                run_tests
                exit $RETURN_CODE_SUCCESS
                ;;
            # Debug prints on
            "-d"|"--debug")
                DEBUG_PRINTS_ON="true"
                ripgrep_args_array+=("--debug")  # also forward this arg to ripgrep
                shift # past argument
                ;;
            # Replacement text; perform in-place to overwrite file
            "-R"|"--Replace")
                overwrite_file="true"
                replacement_text="$2"
                shift # past argument
                shift # past value
                ;;

            # --------------------------------------------------------------------------------------
            # 2. Parse Ripgrep options
            # --------------------------------------------------------------------------------------

            # All ripgrep arguments which require a value after the option (see `rg -h`)
            "-A"|"--after-context"| \
            "-B"|"--before-context"| \
            "--color"| \
            "--colors"| \
            "-C"|"--context"| \
            "--context-separator"| \
            "--dfa-size-limit"| \
            "-E"|"--encoding"| \
            "--engine"| \
            "-f"|"--file"| \
            "-g"|"--glob"| \
            "--iglob"| \
            "--ignore-file"| \
            "-M"|"--max-columns"| \
            "-m"|"--max-count"| \
            "--max-depth"| \
            "--max-filesize"| \
            "--path-separator"| \
            "--pre"| \
            "--pre-glob"| \
            "--regex-size-limit"| \
            "-e"|"--regexp"| \
            "-r"|"--replace"| \
            "--sort"| \
            "--sortr"| \
            "-j"|"--threads"| \
            "-t"|"--type"| \
            "--type-add"| \
            "--type-clear"| \
            "-T"|"--type-not")
                ripgrep_args_array+=("$1")
                ripgrep_args_array+=("$2")
                shift # past argument
                shift # past value
                ;;


            # All other '-' or '--' options (ie: unmatched in the switch cases above)
            -*|--*)
                ripgrep_args_array+=("$1")
                shift # past argument
                ;;

            # --------------------------------------------------------------------------------------
            # 3. Parse positional arguments (regex_search_pattern, and paths)
            # --------------------------------------------------------------------------------------

            # All positional args (ie: unmatched in the switch cases above)
            *)
                # The first positional arg is the regex search pattern
                if [ -z "$regex" ]; then
                    regex="$1"
                # All other positional args are paths to search in
                else
                    paths_array+=("$1")
                fi

                shift # past argument
                ;;
        esac
    done

    # Print argument stats

    all_args_array_len=${#all_args_array[@]}
    echo_debug "Total number of args = $all_args_array_len"
    echo_debug "all_args_array contains:"
    for path in "${all_args_array[@]}"; do
        echo_debug "    $path"
    done

    echo_debug "regex = '$regex'"
    echo_debug "replacement_text = '$replacement_text'"
    echo_debug "overwrite_file = '$overwrite_file'"

    paths_array_len=${#paths_array[@]}
    echo_debug "Number of paths = $paths_array_len"
    echo_debug "paths_array contains:"
    for path in "${paths_array[@]}"; do
        echo_debug "    $path"
    done

    ripgrep_args_array_len=${#ripgrep_args_array[@]}
    echo_debug "Number of general ripgrep args = $ripgrep_args_array_len"
    echo_debug "ripgrep_args_array contains:"
    for arg in "${ripgrep_args_array[@]}"; do
        echo_debug "    $arg"
    done
} # parse_args

main() {
    echo_debug "Running 'main'."

    if [ "$overwrite_file" == "false" ]; then
        # There are no special things this wrapper program needs to do, so just run regular ripgrep!

        # restore original arguments; see: https://stackoverflow.com/a/70572787/4561887
        # set -- "${all_args_array[@]}"
        # rg "$@"
        # rg $(printf '"%s" ' "${all_args_array[@]}")
        # for arg in "${all_args_array[@]}"; do
        #     echo_debug "  $arg"
        # done
        exit $RETURN_CODE_SUCCESS
    fi

    # otherwise, run the special find-and-replace in-place
    file_list="$(rg --stats -l $PASSED_IN_ARGS)"
} # main

# ----------------------------------------------------------------------------------------------------------------------
# Main program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main
# main

