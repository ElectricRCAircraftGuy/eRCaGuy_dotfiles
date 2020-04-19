#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# find_and_replace.sh
# - find and replace a string across multiple files, using regular expressions
#   - excellent for mass variable replacements/variable renaming when writing software, for instance

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere:
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/find_and_replace.sh" ~/bin/gs_find_and_replace
# 2. Now you can use the `gs_find_and_replace` command directly anywhere you like.

# References:
# 1. I used my "PDF2SearchablePDF" bash-based project as a model for how to write good bash scripts
#    and code when wiriting this program. Here is the file of mine I was referencing:
#    https://github.com/ElectricRCAircraftGuy/PDF2SearchablePDF/blob/master/pdf2searchablepdf.sh
# 1. Regex learning & quick reference (on right side of pg): https://regexone.com/
# 1. Regex tester online: https://regex101.com/

EXIT_SUCCESS=0
EXIT_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

# TODO list: 
# 1. Make the option parsing much more robust, and add a `--dry-run` / `-d` option to just show
# what *would be* replaced without actually replacing anything!
# 2. Make this a stand-alone repository, perhaps, as I think it would get more usage and 
# exposure that way.
# 3. ADD THIS TO THE MAIN DOTFILES INSTALLATION SCRIPT AS PART OF THE MAIN INSTALLATION PROCESS!
# 4. 


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
    if [ $# -eq 5 ] && [ "$5" == "-w" ]; then
        # Do a whole word search!
        echo '"-w" flag captured'
        WHOLE_WORD=true
    fi

    DIR_PATH="$1"
    FILENAME_REGEX="$2"
    STRING_REGEX="$3"
    REPLACEMENT_STR="$4"
}

main() {
    if [ "$WHOLE_WORD" == "true" ]; then
        # Match only whole words by surrounding the STRING_REGEX with \b regular expression escape
        # chars
        echo "Matching just whole words, not substrings."
        STRING_REGEX="\b${STRING_REGEX}\b"
    else 
        # Matching substrings is OK
        echo "Matching substrings, not just whole words."
    fi

    echo -e "\nSearching in \"${DIR_PATH}\" for filenames which match"\
            "the regex pattern \"${FILENAME_REGEX}\":"

    # Obtain a long multi-line string of paths to all files whose names match the FILENAME_REGEX
    # regular expression; there will be one line per filename path. It is important that we run
    # the `find` command ONLY ONCE, since it takes the longest amoung of time of all of the 
    # commands we use in this script! So, we must run it once & store its output into a variable.
    filenames="$(find "$DIR_PATH" -type f | grep -E "$FILENAME_REGEX")"
    # echo -e "===============\nfilenames = \n${filenames}\n===============" # for debugging

    # Count the number of files by counting the number of lines in the `filenames` variable, since
    # there is one line per filename path
    num_files="$(echo "$filenames" | wc -l)"

    # Convert the long `filenames` string to a Bash array, separated by new-line chars; see:
    # 1. https://stackoverflow.com/questions/24628076/bash-convert-n-delimited-strings-into-array/24628676#24628676
    # 2. https://unix.stackexchange.com/questions/184863/what-is-the-meaning-of-ifs-n-in-bash-scripting/184867#184867
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS to new line
    filenames_array=($filenames) # split long string into array, separating by IFS (newline chars)
    IFS=$SAVEIFS   # Restore IFS

    # Debugging: print all filename paths one by one to make sure this worked
    # See here for how to print a Bash array: 
    # https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
    # for filename in ${filenames_array[@]}; do
    #     echo "  filename = \"${filename}\""
    # done

    # Count the number of string replacements by grepping for the STRING_REGEX in each of these 
    # files
    num_matches_total=0
    for filename in ${filenames_array[@]}; do

        num_lines_matched=$(grep -c -E "$STRING_REGEX" "$filename")
        # echo "num_lines_matched = $num_lines_matched" # for debugging
        # Here is the old way to do it (avoid this way so we don't have to run the slow `find`
        # command again!):
        # num_lines_matched=$(find "$DIR_PATH" -type f | xargs grep -c "$STRING_REGEX" | grep -o ":[1-9]*" | tr -d ':' | paste -sd+ | bc)
        
        # Count number of matches too, in case there are multiple matches per line; see: 
        # https://superuser.com/questions/339522/counting-total-number-of-matches-with-grep-instead-of-just-how-many-lines-match/339523#339523
        num_matches=$(grep -o -E "$STRING_REGEX" "$filename" | wc -l)
        # echo "num_matches = $num_matches" # for debugging

        if [ "$num_matches" -gt 0 ]; then
            # Update `num_matches_total`; see here for how do add numbers in Bash: 
            # https://stackoverflow.com/questions/6348902/how-can-i-add-numbers-in-a-bash-script/6348941#6348941
            num_matches_total=$((num_matches_total + num_matches))

            echo -e "\n${num_matches} matches found on ${num_lines_matched} lines in file"\
                    "\"${filename}\":"
            # Now show these exact matches with their corresponding line 'n'umbers in the file
            grep -n --color=always -E "$STRING_REGEX" "$filename"
            # Now actually DO the string replacing on the files 'i'n place using the `sed` 's'tream 'ed'itor!
            sed -i "s|${STRING_REGEX}|${REPLACEMENT_STR}|g" "$filename"
        fi
    done
    # echo -e "\nnum_matches_total = $num_matches_total" # For debugging

    ############
    # ALSO SHOULD POST THIS SCRIPT AS AN ANSWER HERE!
    # https://stackoverflow.com/questions/15433058/how-to-check-if-the-sed-command-replaced-some-string
    # 
    # and update the readme here to mention this since it is super useful!
    # AND ADD THE TEST FOLDER TO THE REPO SO OTHERS CAN RUN THIS TEST!
    # make stand-alone project; use description: "linux multi-file find and replace script"
    # post here: https://unix.stackexchange.com/questions/159367/using-sed-to-find-and-replace
    # and here: https://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files
    #
    # TODO: also allow input a file containing a list of dirs to search in, and a file 
    # containing a list of replacement strings to process in those dirs
    ###########

    echo -e "\nDone! ${num_matches_total} string replacements in ${num_files} matching files."
    echo "Replaced all regex matches for \"${STRING_REGEX}\" with string \"${REPLACEMENT_STR}\"."
    echo -e "\nTime required:"

    # echo ""
    # echo "Done! Replaced all regex matches for \"${STRING_REGEX}\" with string \"${REPLACEMENT_STR}\"."
    # echo "${num_matches_total} string replacements in ${num_files} matching files."
    # echo -e "\nTime required:"
}


# ----------------------------------------------------------------------------------------------------------------------
# Program entry point
# ----------------------------------------------------------------------------------------------------------------------

parse_args "$@"
time main


# Multiline comment hack; see: https://linuxize.com/post/bash-comments/
<< 'MULTILINE-COMMENT'

SAMPLE OUTPUT:

Run 1: notice the `-w` I used:

    $ gs_find_and_replace test_folder/ "\.txt" "bo" "do" -w
    "-w" flag captured
    Matching just whole words, not substrings.

    Searching in "test_folder/" for filenames which match the regex pattern "\.txt":

    Done! 0 string replacements in 3 matching files.
    Replaced all regex matches for "\bbo\b" with string "do".

    Time required:

    real    0m0.037s
    user    0m0.021s
    sys 0m0.029s

Run 2: withOUT the `-w`:

    $ gs_find_and_replace test_folder/ "\.txt" "bo" "do"
    Matching substrings, not just whole words.

    Searching in "test_folder/" for filenames which match the regex pattern "\.txt":

    9 matches found on 6 lines in file "test_folder/test2.txt":
    1:hey how are you boing today
    2:hey how are you boing today
    3:hey how are you boing today
    4:hey how are you boing today  hey how are you boing today  hey how are you boing today  hey how are you boing today
    5:hey how are you boing today
    6:hey how are you boing today?

    7 matches found on 7 lines in file "test_folder/test3.txt":
    1:hey how are you boing today
    2:hey how are you boing today
    3:hey how are you boing today
    4:hey how are you boing today
    5:hey how are you boing today
    6:hey how are you boing today
    7:hey how are you boing today?

    5 matches found on 5 lines in file "test_folder/test.txt":
    1:hey how are you boing today
    2:hey how are you boing today
    3:hey how are you boing today
    4:hey how are you boing today
    5:hey how are you boing today?

    Done! 21 string replacements in 3 matching files.
    Replaced all regex matches for "bo" with string "do".

    Time required:

    real    0m0.043s
    user    0m0.020s
    sys 0m0.035s

MULTILINE-COMMENT

