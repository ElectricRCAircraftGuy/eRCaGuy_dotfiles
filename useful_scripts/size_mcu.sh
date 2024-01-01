#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# GS
# Jan. 2024

# DESCRIPTION:
#
# Get the size (RAM and Flash) used by a microcontroller program, as obtained from its .elf file.
# This is similar to the output of the Arduino IDE, and is based on my answer here:
# https://electronics.stackexchange.com/a/598163/26234.
# - This should (hopefully) work for any type of microcontroller .elf file, including PIC32, STM32,
# etc.

# INSTALLATION INSTRUCTIONS:
#
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#    Note that "gs" is my initials.
#    I do these versions with "gs_" in them so I can find all scripts I've written really easily
#    by simply typing "gs_" + Tab + Tab, or "git gs_" + Tab + Tab.
#
#       cd /path/to/here
#       mkdir -p ~/bin
#       . ~/.profile
#       ln -si "${PWD}/size_mcu.sh" ~/bin/size_mcu     # required
#       ln -si "${PWD}/size_mcu.sh" ~/bin/gs_size_mcu  # optional; replace "gs" with your initials
#
# 2. Now you can use this command directly anywhere you like in any of these 5 ways:
#
#       size_mcu -h
#       gs_size_mcu -h

# REFERENCES:
#
# 1. *****+ My answer: https://electronics.stackexchange.com/a/598163/26234
# 1. My repo where you can compile some sample PIC32 project .elf files, such as in this project:
#    `harmony_projects/firmware/harmony_test1.X`:
#    https://github.com/ElectricRCAircraftGuy/eRCaGuy_MPLABX
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh
#    - for advanced argument parsing in Bash
#

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1

VERSION="0.1.0"
AUTHOR="Gabriel Staples"

DEBUG_PRINTS_ON="false"  # "true" or "false"; can also be passed in as an option: `-d` or `--debug`

SCRIPT_NAME="$(basename "$0")"
VERSION_SHORT_STR="'$SCRIPT_NAME' version $VERSION"
VERSION_LONG_STR="\
$VERSION_SHORT_STR
Author = $AUTHOR
See '$SCRIPT_NAME -h' for more info.
"

HELP_STR="\
$VERSION_SHORT_STR

Show the size info. (RAM and Flash usage) of your microcontroller (PIC32, STM32, AVR, etc.) program.
This is very similar to the output of the Arduino IDE at the end of the compilation process.
This program is based on my original work here: https://electronics.stackexchange.com/a/598163/26234

USAGE:
    $SCRIPT_NAME [options] <path/to/my/size/exectutable> <path/to/my_program.elf>

OPTIONS
    -h, -?
        Print help menu
    -v, --version
        Print version information.
    -d, --debug
        Turn on debug prints.

    -F <chip Flash in bytes>, --flash <chip Flash in bytes>
        Optional: specify the flash size of your chip in bytes. Used to calculate a percentage of
        flash used, if specified.
    -R <chip RAM in bytes>, --ram <chip RAM in bytes>
        Optional: specify the RAM size of your chip in bytes. Used to calculate a percentage of
        RAM used, if specified.

EXAMPLE USAGES:

    $SCRIPT_NAME -h
        Print help menu.

    $SCRIPT_NAME xc32-size \"path/to/my_pic32_program.elf\" --flash 2097152 --ram 524288
        Show the program size info of my_pic32_program as obtained by the PIC32 'xc32-size'
        executable. This requires that 'xc32-size' is in your PATH.
        Also, specify the flash and RAM sizes of your chip in bytes, so that a percentage of
        flash and RAM used can be calculated.
        - Here the flash size is 2 MiB (2097152 bytes) and the RAM size is 512 KiB (524288 bytes).

    $SCRIPT_NAME xc32-size \"path/to/my_pic32_program.elf\"
        Show the program size info of my_pic32_program as obtained by the PIC32 'xc32-size'
        executable. This requires that 'xc32-size' is in your PATH.

    $SCRIPT_NAME /opt/microchip/xc32/v4.35/bin/xc32-size \"path/to/my_pic32_program.elf\"
        Same as above, except 'xc32-size' does not have to be in your PATH.

    $SCRIPT_NAME \"\$(which xc32-size)\" \"path/to/my_pic32_program.elf\"
        Same as above.

    $SCRIPT_NAME arm-none-eabi-size \"path/to/my_program.elf\"
        Show the program size info of my_program as obtained by the ARM 'arm-none-eabi-size'
        executable. This requires that 'arm-none-eabi-size' is in your PATH.
        Works for ARM-core STM32 mcus, for instance.
        See my answer here: https://electronics.stackexchange.com/a/598163/26234


This program is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
by Gabriel Staples.
"

# A function to do echo-style debug prints only if `DEBUG_PRINTS_ON` is set to "true".
echo_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        echo "$@"
    fi
}

echo_error() {
    printf "%s" "ERROR: "
    echo "$@"
}

# A function to do printf-style debug prints only if `DEBUG_PRINTS_ON` is set to "true".
printf_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        printf "%s" "DEBUG: "
        # See: https://github.com/koalaman/shellcheck/wiki/SC2059
        # shellcheck disable=SC2059
        printf "$@"
    fi
}

print_help() {
    echo "$HELP_STR" | less -RFX
}

print_version() {
    echo "$VERSION_LONG_STR"
}

# Print a regular bash "indexed" array, passed by reference
# See:
# 1. my answer: https://stackoverflow.com/a/71060036/4561887 and
# 1. my answer: https://stackoverflow.com/a/71060913/4561887
print_array() {
    local -n array_reference="$1"

    if [ "${#array_reference[@]}" -eq 0 ]; then
        echo "No elements found."
    fi

    for element in "${array_reference[@]}"; do
        echo "  $element"
    done
}

# Print a regular bash "indexed" array, passed by reference, only if `DEBUG_PRINTS_ON` is set
# to "true".
print_array_debug() {
    if [ "$DEBUG_PRINTS_ON" = "true" ]; then
        print_array "$1"
    fi
}

# Print all arguments, for debugging.
debugging_print_all_args() {
    # echo "$1"  # debugging

    echo "All args:"
    i=0
    for arg in "$@"; do
        ((i++))
        echo "arg${i} = $arg"
    done
}

parse_args() {
    # For advanced argument parsing help and demo, see:
    # 1. https://stackoverflow.com/a/14203146/4561887
    # 2. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/argument_parsing__3_advanced__gen_prog_template.sh

    if [ "$#" -eq 0 ]; then
        echo "No arguments supplied"
        print_help
        echo "Exiting..."
        exit $RETURN_CODE_ERROR
    fi

    # All possible input arguments we expect to see.

    # Note: pre-declaring these variables like this is NOT required in bash. This is optional, and
    # is only done for human-readability and "aesthetic" purposes, to remind us that all of these
    # variables 1) **exist**, and 2) **are empty by default** if not written to below.
    # 1. Optional args
    FLASH_BYTES=""
    RAM_BYTES=""
    # 2. Positional args
    SIZE_EXE=""
    ELF_FILE=""

    ALL_ARGS_ARRAY=("$@")  # See: https://stackoverflow.com/a/70572787/4561887
    POSITIONAL_ARGS_ARRAY=()
    while [ "$#" -gt 0 ]; do
        arg="$1"
        # get first letter of `arg`; see: https://stackoverflow.com/a/10218528/4561887
        # This is a form of bash "array slicing", treating the string like an array of chars,
        # so see also my answer about array slicing here:
        # https://unix.stackexchange.com/a/664956/114401
        first_letter="${arg:0:1}"

        case $arg in
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
            # Debug prints on
            "-d"|"--debug")
                echo_debug "Debug on."
                DEBUG_PRINTS_ON="true"
                shift # past argument
                ;;
            # Flash
            "-F"|"--flash")
                echo_debug "flash passed in"
                FLASH_BYTES="$2"
                echo_debug "FLASH_BYTES = $FLASH_BYTES"
                shift # past argument (`$1`)
                shift # past value (`$2`)
                ;;
            # RAM
            "-R"|"--ram")
                echo_debug "ram passed in"
                RAM_BYTES="$2"
                echo_debug "RAM_BYTES = $RAM_BYTES"
                shift # past argument (`$1`)
                shift # past value (`$2`)
                ;;
            # All positional args (ie: unmatched in the switch cases above)
            *)
                # error out for any unexpected options passed in
                if [ "$first_letter" = "-" ]; then
                    echo_error "Invalid optional argument ('$1'). See help menu for valid options."
                    echo "Exiting..."
                    exit $RETURN_CODE_ERROR
                fi

                POSITIONAL_ARGS_ARRAY+=("$1")  # save positional arg into array
                shift # past argument (`$1`)
                ;;
        esac
    done

    SIZE_EXE="${POSITIONAL_ARGS_ARRAY[0]}"
    ELF_FILE="${POSITIONAL_ARGS_ARRAY[1]}"

    # Do debug prints of all argument stats

    all_args_array_len="${#ALL_ARGS_ARRAY[@]}"
    echo_debug "Total number of args = $all_args_array_len"
    echo_debug "ALL_ARGS_ARRAY contains:"
    print_array_debug ALL_ARGS_ARRAY
    echo_debug ""

    positional_args_array_len="${#POSITIONAL_ARGS_ARRAY[@]}"
    echo_debug "Number of positional args = $positional_args_array_len"
    echo_debug "POSITIONAL_ARGS_ARRAY contains:"
    print_array_debug POSITIONAL_ARGS_ARRAY
    echo_debug ""
    echo_debug "SIZE_EXE = '$SIZE_EXE'"
    echo_debug "ELF_FILE = '$ELF_FILE'"
    echo_debug ""
} # parse_args

print_size_info() {
    # In older XC32 compilers, such as v1.42, the output of `xc32-size` has these columns:
    #    text	 rodata	   data	    bss	    dec	    hex	filename
    # In newer XC32 compilers, such as v4.35, the output of `xc32-size` has these columns:
    #    text	   data	    bss	    dec	    hex	filename
    # In ARM compilers, such as `arm-none-eabi-size`, the output is the same as in the newer
    # XC32 compilers, such as v4.35, above.
    #
    # The "text" section of the latter case = the "text" + "rodata" sections of the former case.

    size_info=$("$SIZE_EXE" "$ELF_FILE")
    if [ "$?" -ne 0 ]; then
        echo "ERROR: $SIZE_EXE failed. Is this a valid executable?"
        echo "size_info = $size_info"
        echo "Exiting..."
        exit $RETURN_CODE_ERROR
    fi

    line1="$(echo "$size_info" | head -n 1)"
    line2="$(echo "$size_info" | head -n 2 | tail -n 1)"

    header="$line1"
    data="$line2"

    col1_heading="$(echo "$header" | awk '{print $1}')"
    col2_heading="$(echo "$header" | awk '{print $2}')"
    col3_heading="$(echo "$header" | awk '{print $3}')"
    col4_heading="$(echo "$header" | awk '{print $4}')"
    col5_heading="$(echo "$header" | awk '{print $5}')"
    col6_heading="$(echo "$header" | awk '{print $6}')"
    col7_heading="$(echo "$header" | awk '{print $7}')"

    # distinguish between the new and old compiler formats by looking at just the column 2 heading
    col2_heading="$(echo "$header" | awk '{print $2}')"
    if [[ "$col2_heading" == "rodata" ]]; then
        # old format

        # verify all headings
        if [[ "$col1_heading" != "text" ]] || \
           [[ "$col2_heading" != "rodata" ]] || \
           [[ "$col3_heading" != "data" ]] || \
           [[ "$col4_heading" != "bss" ]] || \
           [[ "$col5_heading" != "dec" ]] || \
           [[ "$col6_heading" != "hex" ]] || \
           [[ "$col7_heading" != "filename" ]]; then
            echo "ERROR 1: unrecognized 'size' format!"
            echo "size_info = $size_info"
            echo "Exiting..."
            exit $RETURN_CODE_ERROR
        fi

        text=$(echo "$data" | awk '{print $1}')
        rodata=$(echo "$data" | awk '{print $2}')
        data=$(echo "$data" | awk '{print $3}')
        bss=$(echo "$data" | awk '{print $4}')

        flash=$(($text + $rodata + $data))
        sram=$(($bss + $data))

    elif [[ "$col2_heading" == "data" ]]; then
        # new format

        # verify all headings
        if [[ "$col1_heading" != "text" ]] || \
           [[ "$col2_heading" != "data" ]] || \
           [[ "$col3_heading" != "bss" ]] || \
           [[ "$col4_heading" != "dec" ]] || \
           [[ "$col5_heading" != "hex" ]] || \
           [[ "$col6_heading" != "filename" ]]; then
            echo "ERROR 2: unrecognized 'size' format!"
            echo "size_info = $size_info"
            echo "Exiting..."
            exit $RETURN_CODE_ERROR
        fi

        text=$(echo "$data" | awk '{print $1}')
        data=$(echo "$data" | awk '{print $2}')
        bss=$(echo "$data" | awk '{print $3}')

        flash=$(($text + $data))
        sram=$(($bss + $data))

    else
        echo "ERROR 3: unrecognized 'size' format!"
        echo "size_info = $size_info"
        echo "Exiting..."
        exit $RETURN_CODE_ERROR
    fi

    echo -e "size_info = '$SIZE_EXE $ELF_FILE' = \n\n$size_info\n"

    # Calculate percentages of flash and RAM used, if the user specified the flash and RAM sizes of
    # their chip. For an example of the Arduino output as a comparison/model, see the screenshot
    # snippet at the top of my question here: https://electronics.stackexchange.com/q/363931/26234.

    flash_percent_info=""
    sram_percent_info=""

    if [[ ! -z "$FLASH_BYTES" ]]; then
        flash_used_percent="$(echo "scale=6; $flash / $FLASH_BYTES * 100" | bc)"
        # round to 3 decimal places
        flash_used_percent="$(printf "%7.3f" "$flash_used_percent")"

        flash_remaining_bytes="$(($FLASH_BYTES - $flash))"
        # format to 7 digits
        flash_remaining_bytes="$(printf "%7d" "$flash_remaining_bytes")"
        flash_remaining_percent="$(echo "scale=6; 100 - $flash_used_percent" | bc)"
        # round to 3 decimal places
        flash_remaining_percent="$(printf "%7.3f" "$flash_remaining_percent")"

        # format to 7 digits
        FLASH_BYTES="$(printf "%7d" "$FLASH_BYTES")"

        flash_percent_info=" ($flash_used_percent%). Remaining is $flash_remaining_bytes bytes"
        flash_percent_info+=" ($flash_remaining_percent%). "
        # add extra specing for alignment with the SRAM info below, only if
        # the RAM info is also provided
        if [[ ! -z "$RAM_BYTES" ]]; then
            flash_percent_info+=". . . . . . . . . . . . . . . . . ."
            flash_percent_info+=" . . . . . .  "
        fi
        flash_percent_info+="Max is $FLASH_BYTES bytes"
    fi

    if [[ ! -z "$RAM_BYTES" ]]; then
        sram_used_percent="$(echo "scale=6; $sram / $RAM_BYTES * 100" | bc)"
        # round to 3 decimal places
        sram_used_percent="$(printf "%7.3f" "$sram_used_percent")"

        sram_remaining_bytes="$(($RAM_BYTES - $sram))"
        # format to 7 digits
        sram_remaining_bytes="$(printf "%7d" "$sram_remaining_bytes")"
        sram_remaining_percent="$(echo "scale=6; 100 - $sram_used_percent" | bc)"
        # round to 3 decimal places
        sram_remaining_percent="$(printf "%7.3f" "$sram_remaining_percent")"

        # format to 7 digits
        RAM_BYTES="$(printf "%7d" "$RAM_BYTES")"

        sram_percent_info=" ($sram_used_percent%). Remaining is $sram_remaining_bytes bytes"
        sram_percent_info+=" ($sram_remaining_percent%) for local (stack) variables or RTOS "
        sram_percent_info+="stack & heap. Max is $RAM_BYTES bytes"
    fi

    flash_percent_info+="."
    sram_percent_info+="."

    # format the bytes to 7 digits
    flash="$(printf "%7d" "$flash")"
    sram="$(printf "%7d" "$sram")"

    # Print it out
    echo "FLASH used . . . . . . . . .  = $flash bytes$flash_percent_info"
    echo "SRAM used by global variables = $sram bytes$sram_percent_info"
}

main() {
    print_size_info "$@"
}

# Determine if the script is being sourced or executed (run).
# See:
# 1. "eRCaGuy_hello_world/bash/if__name__==__main___check_if_sourced_or_executed_best.sh"
# 1. My answer: https://stackoverflow.com/a/70662116/4561887
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # This script is being run.
    __name__="__main__"
else
    # This script is being sourced.
    __name__="__source__"
fi

# ----------------------------------------------------------------------------------------------------------------------
# Main program entry point
# ----------------------------------------------------------------------------------------------------------------------

# Only run `main` if this script is being **run**, NOT sourced (imported).
# - See my answer: https://stackoverflow.com/a/70662116/4561887
if [ "$__name__" = "__main__" ]; then
    parse_args "$@"
    # time main "$@"
    main "$@"
    exit $RETURN_CODE_SUCCESS
fi
