#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# STATUS: functional and ready-to-use

# This is a simple wrapper around RipGrep (`rg`) to allow in-place find-and-replace, since the
# `rg --replace` option replaces only the stdout, NOT the contents of the file.
# `man rg` under the `--replace` section states: "Neither this flag nor any other ripgrep
# flag will modify your files." This wrapper overcomes that limitation.

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
#   3. `gs_rgr`
#   4. `gs_rg_replace`

# SIMPLE FISH IMPLEMENTATION (not using bins)
# essentially we create a function that executes rg_replace.sh (named rgr.sh in my config) 

# function rgr
#   set -l DOOTFILE_LOC ~/Documents/dotFiles/ # replace to the current location of rg_replace.sh
#   bash "$DOOTFILE_LOC"/rgr.sh "$argv"
# end

# References:
# 1. How to use `rg` to do an in-place replacement in a **single file** at a time:
#    https://learnbyexample.github.io/substitution-with-ripgrep/#in-place-workaround
# 1. My feature request to have `rg` do find and replace natively (post link to this wrapper
#    there when done with it!):
#    https://github.com/BurntSushi/ripgrep/issues/2115
# 1. Advanced bash argument parsing example:
#    https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/blob/master/pdf2searchablepdf.sh#L150-L223
# 1. intro to bash arrays: https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
# 1. ***** "eRCaGuy_hello_world/bash/array_practice.sh"
# 1. See also this simple alternative!:
#    https://github.com/BurntSushi/ripgrep/issues/74#issuecomment-376659557
#       rg 'foo' --files-with-matches | xargs sed -i 's/foo/bar/g'
#       # OR
#       rg 'foo' --files-with-matches | xargs sed -i 's|foo|bar|g'     <========= SIMPLE ALTERNATIVE ==========

# Test commands:
#       eRCaGuy_dotfiles$ rgr foo -R boo
#       eRCaGuy_dotfiles$ rgr foo -R boo --stats "git & Linux cmds, help, tips & tricks - Gabriel.txt"

# TODO:
# ✓ 1. Do advanced bash argument parsing, following the example above, to determine what the regex
#    search pattern is and what the `-r replacement_text` replacement text is. Use this info. to
#    complete the find-and-replace below.
# ✓ 1. Also post here when done: https://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files/580328#580328
#       Done. See: https://unix.stackexchange.com/a/684926/114401

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="false"  # "true" or "false"; can also be passed in as an option: `-d` or `--debug`

# ANSI color codes
# See:
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-diffn.sh#L126-L138
# 1. https://github.com/GNOME/glib/blob/main/gio/gdbus-tool.c#L43-L50
COLOR_MGN="\033[35m" # magenta
COLOR_OFF="\033[m"


SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="rgr ('$SCRIPT_NAME') version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

HELP_STR="\
$VERSION_SHORT_STR

RipGrep Replace (rgr). This program is a wrapper around RipGrep ('rg') in order to allow some
extra features, such as find and replace in-place in files. It doesn't rely on 'sed'. It uses
RipGrep only. Since it's a wrapper around 'rg', it forwards all options to 'rg', so you can use it
as a permanent replacement for 'rg' if you like.

Currently, the only significant new option added is '-R' or '--Replace', which is the same as
RipGrep's '-r' except it MODIFIES THE FILES IN-PLACE ON YOUR FILESYSTEM! This is great! If you
think so too, go and star this project (link below).

USAGE (exact same as 'rg')
    rgr [options] <regex> [paths...]

OPTIONS
    ALL OPTIONS ACCEPTED BY RIPGREP ('rg') ARE ALSO ACCEPTED BY THIS PROGRAM. Here are just a few
    of the options I've amended and/or would like to highlight. Not all Ripgrep options have been
    tested, and not all of them ever will be by me at least.

    -h, -?, --help
        Print help menu
    -v, --version
        Print version information.
    --run_tests
        Run unit tests (none yet).
    -d, --debug
        Turn on debug prints. '-d' is not part of 'rg' but if you use either of these options here
        it will auto-forward '--debug' to 'rg' under-the-hood.
    -r <replacement_text>, --replace <replacement_text>
        Do a dry-run to replace all matches of regular expression 'regex' with 'replacement_text'.
        This only does the replacement in the stdout output; it does NOT modify your disk!
    -R <replacement_text>, --Replace <replacement_text>
        THIS IS THE ONE! Bingo! This is the sole purpose for the creation of this wrapper. This
        option will actually replace all matches of regular expression 'regex' with
        'replacement_text' ON YOUR DISK. It actually modifies your file system! This is great
        for large code-wide replacements when programming in large repos, for instance.
    --stats
        Show detailed statistics about the ripgrep search and replacements made.

    SEE ALSO 'rg -h' AND 'man rg' FOR THE FULL HELP MENU OF RIPGREP ITSELF, WHICH OPTIONS ARE ALSO
    ALLOWED AND PASSED THROUGH BY THIS 'rgr' WRAPPER PROGRAM.

EXAMPLE USAGES:

    rgr foo -r boo
        Do a *dry run* to replace all instances of 'foo' with 'boo' in this folder and down.
    rgr foo -R boo
        ACTUALLY REPLACE ON YOUR DISK all instances of 'foo' with 'boo' in this folder and down.
    rgr foo -R boo file1.c file2.c file3.c
        Same as above, but only in these 3 files.
    rgr foo -R boo -g '*.txt'
        Use a glob filter to replace on your disk all instances of 'foo' with 'boo' in .txt files
        ONLY, inside this folder and down. Learn more about RipGrep's glob feature here:
        https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#manual-filtering-globs
    rgr foo -R boo --stats
        Replace on your disk all instances of 'foo' with 'boo', showing detailed statistics.


Note to self: the only free lowercase letters not yet used by 'rg' as of 3 Jan. 2021 are:
    -d, -k, -y

This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

# A function to do debug prints only if `DEBUG_PRINTS_ON` is set to "true".
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        echo "$@"
    fi
}

# A function to do debug prints only if `DEBUG_PRINTS_ON` is set to "true".
printf_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        printf "$@"
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
    stats_on="false"

    while [ $# -gt 0 ]; do
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
                echo "ACTUAL CONTENT WILL BE REPLACED IN YOUR FILESYSTEM."
                echo "If you'd like to do a dry-run instead, cancel the program and run with '-r' instead of '-R'."

                # See: https://stackoverflow.com/a/226724/4561887
                read -p "Are you sure you'd like to continue? (Y or y to continue; any other key or just Enter to exit) " \
                    yes_or_no
                case "$yes_or_no" in
                    [Yy]* )
                        # nothing to do
                        ;;
                    *)
                        exit $RETURN_CODE_SUCCESS
                        ;;
                esac

                if [ $# -gt 1 ]; then
                    replacement_text="$2"
                    ripgrep_args_array+=("-r" "$replacement_text")
                    shift # past argument
                    shift # past value
                else
                    echo "ERROR: Missing value for argument '-R' or '--Replace'."
                    exit $RETURN_CODE_ERROR
                fi
                ;;
            # Ripgrep Statistics on
            "--stats")
                stats_on="true"
                shift # past argument
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
                if [ $# -gt 1 ]; then
                    ripgrep_args_array+=("$1")
                    ripgrep_args_array+=("$2")
                    shift # past argument
                    shift # past value
                else
                    echo "ERROR: Missing value for Ripgrep argument."
                    exit $RETURN_CODE_ERROR
                fi
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
        rg "${all_args_array[@]}"
        exit $RETURN_CODE_SUCCESS
    fi


    # otherwise, run the special find-and-replace in place

    NUM_STATS_LINES=9  # number of extra lines printed at the end by the ripgrep `--stats` option

    args_array=("${ripgrep_args_array[@]}" "--stats" "-l" "$regex" "${paths_array[@]}")

    filenames_list_and_stats="$(rg "${args_array[@]}")"
    filenames_list="$(printf "%s" "$filenames_list_and_stats" | head -n -$NUM_STATS_LINES)"
    filenames_stats="$(printf "%s" "$filenames_list_and_stats" | tail -n $NUM_STATS_LINES)"

    echo ""
    # echo "TOTAL SUMMARY:"
    # printf "${COLOR_MGN}%s${COLOR_OFF}" "${filenames_list}"
    # echo "$filenames_stats"
    # echo ""

    # Convert list of files to array of files.
    # See:
    # 1. "eRCaGuy_dotfiles/useful_scripts/find_and_replace.sh" for an example of this
    # 1. ***** https://stackoverflow.com/a/24628676/4561887
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS (Internal Field Separator) to newline char
    filenames_array=($filenames_list) # split long string into array, separating by IFS (newline chars)
    IFS=$SAVEIFS   # Restore IFS

    # Now do the replacement one file at a time, using `rg` only! (no need for `sed`)

    args_array_base=("${ripgrep_args_array[@]}" "--passthru" "$regex")
    args_array_base_with_color=("${ripgrep_args_array[@]}" "--stats" "--color" "always" \
        "-n" "$regex")

    for filename in "${filenames_array[@]}"; do
        echo -e "${COLOR_MGN}${filename}${COLOR_OFF}"

        args_array_final=("${args_array_base[@]}" "$filename")
        args_array_final_with_color=("${args_array_base_with_color[@]}" "$filename")

        file_changes_and_stats_in_color="$(rg "${args_array_final_with_color[@]}")"
        file_changes_in_color="$(printf "%s" "$file_changes_and_stats_in_color" | head -n -$NUM_STATS_LINES)"

        file_contents="$(rg "${args_array_final[@]}")"

        if [ "$stats_on" == "true" ]; then
            printf "%s\n\n" "$file_changes_and_stats_in_color"
        else
            printf "%s\n\n" "$file_changes_in_color"
        fi

        # WARNING WARNING WARNING! This is the line that makes the actual changes to your
        # file system!
        printf "%s" "$file_contents" > "$filename"
    done

    # print the summary output one more time so that if the output is really long the user doesn't
    # have to scroll up forever to see it
    filenames_array_len=${#filenames_array[@]}
    if [ "$filenames_array_len" -gt 1 ] && [ "$stats_on" == "true" ]; then
        echo ""
        printf "${COLOR_MGN}%s${COLOR_OFF}" "${filenames_list}"
        echo "$filenames_stats"
    fi
} # main

# ----------------------------------------------------------------------------------------------------------------------
# Main program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main
# main

