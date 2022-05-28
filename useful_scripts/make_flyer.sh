#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# June 2019 to May 2022

# STATUS: functional and ready-to-use

# Example:
#       make_flyer "path/to/inputpdf1.pdf" "path/to/inputpdf2.pdf"

# GENERAL LINUX INSTALLATION INSTRUCTIONS:
# 0. First, install `texlive-extra-utils`, which contains `pdfnup`:
#       sudo apt update
#       sudo apt install texlive-extra-utils
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/make_flyer.sh" ~/bin/make_flyer     # required
#       ln -si "${PWD}/make_flyer.sh" ~/bin/gs_make_flyer  # optional; replace "gs" with your initials
# 3. Now you can use this command directly anywhere you like in any of these ways:
#   1. `make_flyer`
#   1. `gs_make_flyer`

# References:
# 1. [my answer with this code] https://superuser.com/a/1452008/425838


RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

SCRIPT_NAME="$(basename "$0")"

HELP_STR="\
Turn a PDF into a flyer with 2 pages on each side of the paper.

USAGE:
    $SCRIPT_NAME <path/to/pdf1.pdf> [path/to/pdf2.pdf ...]

DETAILED DESCRIPTION:

Outputs a landscape-oriented flyer pdf(\"my/pdf/input--flyer.pdf\") for each 1
or more pg input pdf(\"my/pdf/input.pdf\").

  - 1-pg input PDFs are converted to a 1-sided landscape, printable flyer
    that you cut down the center to make 2 flyers.
  - 2-pg input PDFs are converted to a 2-sided landscape, printable flyer
    (flip on short edge when printing double-sided), and also cut down the
    middle to make 2 flyers.
  - **3+ pg input PDFs**: using 'pdfnup' directly in this case would make
    more sense, since this function will otherwise unnecessarily create 2
    copies.
  - 3 and 4-pg input PDFs are converted to a single piece of paper,
    double-sided, flipped on short edge, x 2 copies. No cutting is necessary.
  - 5+ pg input PDFs simply require half as much paper to print is all since
    you get 2 pages per side of paper; they do NOT print like booklets, but
    rather just as a landscape-printed, flipped-on-short-edge bundle of pages
    (like a deck of slides). You get *2 copies* per print though, so just
    print half of the total number of pages.

EXAMPLES:
    $SCRIPT_NAME \"path/to/inputpdf.pdf\"
        Create a landscape-side-by-side flyer version
        called \"inputpdf--flyer.pdf\" *in your present working directory*
        from a 1 or 2 pg input PDF called \"path/to/inputpdf.pdf\".

  You can pass multiple PDF arguments at once. Ex:

    $SCRIPT_NAME \"path/to/inputpdf1.pdf\" \"path/to/inputpdf2.pdf\" \"inputpdf3.pdf\"
        Create 3 separate \"flyer\"-printable PDFs in your present working
        directory:
        - inputpdf1--flyer.pdf
        - inputpdf2--flyer.pdf
        - inputpdf3--flyer.pdf

Source Code:
https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/make_flyer.sh
"

print_help() {
    echo "$HELP_STR" | less -RFX
}

make_flyer() {
    # PARSE ARGUMENTS
    # For more-advanced argument parsing help and demo, see:
    # 1. [my code]
    #    https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
    # 1. https://stackoverflow.com/a/14203146/4561887

    # help menu
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        print_help
        exit $RETURN_CODE_SUCCESS
    fi

    # No arguments
    if [ $# -eq 0 ]; then
        echo "No arguments supplied. Printing help menu:"
        print_help
        exit $RETURN_CODE_ERROR
    fi

    # see: https://stackoverflow.com/questions/4423306/how-do-i-find-the-number-of-arguments-passed-to-a-bash-script/4423321#4423321
    num_args=$#
    suffix="flyer"

    loop_cnt=0
    for inputpdf in "$@"
    do
        ((loop_cnt++))
        echo "==== CONVERTING PDF $loop_cnt OF $num_args ===="
        echo "     INPUT:  \"$inputpdf\""

        # Strip off the .pdf extension from the input path, while retaining the
        # rest of the path
        # - See: https://stackoverflow.com/questions/12152626/how-can-i-remove-the-extension-of-a-filename-in-a-shell-script/32584935#32584935
        input_path_base="$(echo "$inputpdf" | rev | cut -f 2- -d '.' | rev)"
        input_file_base="$(basename "$inputpdf" .pdf)"
        temp_pdf="${input_path_base}-.pdf" # is "input_path_base-.pdf"

        echo "     OUTPUT: \"$(pwd)/${input_file_base}--${suffix}.pdf\""

        # Convert a single 1-pg pdf into a temporary 2-pg pdf
        pdfunite "$inputpdf" "$inputpdf" "$temp_pdf"

        # Lay out the temporary 2-pg pdf into a side-by-side 1-sided flyer to
        # print; creates "input_path_base--flyer.pdf" Note that `pdfnup` places
        # the output from this operation in the location from where you call
        # this script(ie: in your `pwd` [Present Working Directory])!--NOT the
        # location where temp_pdf is located!
        pdfnup "$temp_pdf" --suffix $suffix

        # Delete the temporary 2-pg pdf, called "input_path_base-.pdf", thereby
        # leaving only the original
        # "input_path_base.pdf" and the new "input_path_base--flyer.pdf"
        rm "$temp_pdf"
    done
}

# Set the global variable `run` to "true" if the script is being **executed**
# (not sourced) and `main` should run, and set `run` to "false" otherwise. One
# might source this script but intend NOT to run it if they wanted to import
# functions from the script.
# See:
# 1. *****https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
# 1. my answer: https://stackoverflow.com/a/70662049/4561887
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/check_if_sourced_or_executed.sh
run_check() {
    # This is akin to `if __name__ == "__main__":` in Python.
    if [ "${FUNCNAME[-1]}" == "main" ]; then
        # This script is being EXECUTED, not sourced
        run="true"
    fi
}

# ------------------------------------------------------------------------------
# Main program entry point
# ------------------------------------------------------------------------------

# Only run main function if this file is being executed, NOT sourced.
run="false"
run_check
if [ "$run" == "true" ]; then
    make_flyer "$@"
fi
