#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# find_and_replace.sh
# - find and replace a string across multiple files, using regular expressions
#   - excellent for variable replacements when writing software, for instance

# TODO: ADD THIS TO THE MAIN INSTALLATION SCRIPT AS PART OF THE MAIN INSTALLATION PROCESS!
# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/find_and_replace.sh" ~/bin/gs_find_and_replace
# 2. Now you can use the `gs_find_and_replace` command directly anywhere you like.

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

print_help() {
    echo ''
    echo "find_and_replace version $VERSION"
    echo '- Find and replace a string across multiple files based on matching regular expressions'
    echo '  for both the filename and the string to replace.'
    echo ''
    echo 'Note: see here for regular expression (regex) testing & help: https://regex101.com/'
    echo ''
    echo 'Usage:'
    echo '`find_and_replace <path> <filename_regex> <string_regex> <replacement_str> [-w]`'
    echo ''
    echo '  path            = directory to search for files in; ex: "~/Documents"; this may be'
    echo '                    a path to single file if you want to search only in one file'
    echo '  filename_regex  = regular expression to filter which filenames you'"'"'d like to search in;'
    echo '                    use "" or ".*" to match any filename'
    echo '  string_regex    = regular expression for the string to replace in each file'
    echo '  replacement_str = string to overwrite on top of the matching string; NOT a regular'
    echo '                    expression!' 
    echo '  -w              = do only '"'"'w'"'"'hole word matches when searching for `string_regex`'
    echo '                    by surrounding the user'"'"'s input `string_regex` with word break'
    echo '                    `\b` characters'
    echo '`find_and_replace`    = print help menu'
    echo '`find_and_replace -h` = print help menu'
    echo '`find_and_replace -?` = print help menu'
    echo '`find_and_replace -v` = print author & version'
    echo ''
    echo 'Example 1: `find_and_replace "~/development" ".*(\.ino$|\.cpp$)" "serial\.print" "Serial.print"`'
    echo '           = searching in all files in directory ~/development which end in .ino or .cpp, replace'
    echo '           all instances of serial.print with Serial.print'
    echo ''
    echo 'Example 2: `find_and_replace "~/development/my_file.ino" "" "serial\.print" "Serial.print" -w`'
    echo '           = searching in only this one file: ~/development/my_file.ino, replace'
    echo '           all instances of serial.print with Serial.print, matching whole words only'
    echo ''
    echo 'Example 3: `find_and_replace "~/development/" "\.txt" "hello how are you" "sup dude"`'
    echo '           = searching in all files in directory ~/development/ which end in .txt, replace'
    echo '           all instances of "hello how are you" with "sup dude"'
    echo ''
    echo 'This program is part of: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles'
    echo ''
}

print_version() {
    echo "find_and_replace version $VERSION"
    echo "Author = $AUTHOR"
    echo 'See `find_and_replace -h` for more info.'
}

WHOLE_WORD=false
parse_args() {
    if [ $# -lt 1 ]; then
        echo "ERROR: Not enough arguments supplied"
        print_help
        exit $EXIT_ERROR
    fi

    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        print_help
        exit $EXIT_SUCCESS
    fi

    # Version
    if [ "$1" == "-v" ]; then
        print_version
        exit $EXIT_SUCCESS
    fi

    if [ $# -lt 4 ]; then
        echo "ERROR: Not enough arguments supplied"
        print_help
        exit $EXIT_ERROR
    fi

    # -w
    if [ $# -eq 5 ]; then
        # Do a whole word search!
        WHOLE_WORD=true
    fi

    DIR_PATH="$1"
    FILENAME_REGEX="$2"
    STRING_REGEX="$3"
    REPLACEMENT_STR="$4"
}

# # Count the number of string matches in a file
# count_str_matches() {
#     # do the replacement
#     grep -E "$FILENAME_REGEX" | xargs sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g"

#     # export num_replacements=7 #$(xargs grep -c "my_search_str" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)
#     # echo "num = $num"
# }

main() {
    num_files=0
    num_replacements=0

    if [ "$WHOLE_WORD" == "true" ]; then
        # Match only whole words by surrounding the STRING_REGEX with \b regular expression escape
        # chars
        echo "Matching just whole words, not substrings."
        STRING_REGEX="\b${STRING_REGEX}\b"
    else 
        # Matching substrings is OK
        echo "Matching substrings, not just whole words."
    fi

    files="$(find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX")"
    echo "files = $files"

    # WORKS!
    # num_files="$(find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | wc -l)"
    # num_replacements="$(find "$DIR_PATH" -type f | xargs grep -c "$STRING_REGEX" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)"

    num_files="$(echo "$files" | wc -l)"

    ###### NEXT: SPLIT STRING INTO BASH ARRAY BASED ON NEWLINE CHARS, THEN ITERATE OVER THE ARRAY!
    # https://stackoverflow.com/a/24628676/4561887

    num_replacements="$(echo "$files" | grep -o ":[1-9]")" # | tr -d ':' | paste -sd+ | bc)"


    # find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | xargs sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g"



    # if [ "$WHOLE_WORD" == "true" ]; then
    #     # Match only whole words by surrounding the STRING_REGEX with \b regular expression escape
    #     # chars
    #     echo "Matching just whole words, not substrings."
    #     find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | xargs sed -i "s|\b${STRING_REGEX}\b|${REPLACEMENT_STR}|g"
    # else 
    #     # Matching substrings is OK
    #     echo "Matching substrings, not just whole words."
    #     # find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | xargs sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g"
    #     num_replacements=$(find "$DIR_PATH" -type f | tee >(count_str_matches) | xargs grep -c "my_search_str" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)
    # fi

    # FILES="$(find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX")"
    # echo "$FILES"

    # for file in "$FILES"; do 
    #     echo "file = $file"
    # done

    # echo "$FILES" | xargs sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g"

    # if [ "$WHOLE_WORD" == "true" ]; then
    #     # Match only whole words by surrounding the STRING_REGEX with \b regular expression escape
    #     # chars
    #     echo "Matching just whole words, not substrings."
    #     find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | xargs sed -i "s|\b${STRING_REGEX}\b|${REPLACEMENT_STR}|g"
    # else 
    #     # Matching substrings is OK
    #     echo "Matching substrings, not just whole words."
    #     # find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX" | xargs sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g"
    #     num_replacements=$(find "$DIR_PATH" -type f | tee >(count_str_matches) | xargs grep -c "my_search_str" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)
    # fi

    # num_replacements=$(find "$DIR_PATH" -type f | xargs grep -c "$STRING_REGEX" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)
    # num_replacements=$(find "$DIR_PATH" -type f | xargs grep -c "$STRING_REGEX" | grep -o ":[1-9]" | tr -d ':' | paste -sd+ | bc)

    echo "Done! ${num_replacements} string replacements in ${num_files} files."
}


# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main
