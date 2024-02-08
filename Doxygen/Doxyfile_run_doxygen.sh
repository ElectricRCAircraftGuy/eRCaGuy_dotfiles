#!/usr/bin/env bash

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

cd "$SCRIPT_DIRECTORY"

DOXYFILE="Doxyfile"  # name/path of the doxygen configuration file
OUTPUT_DIRECTORY="$(grep "^OUTPUT_DIRECTORY" "$DOXYFILE" | cut -d "=" -f 2 | tr -d " ")"

echo "Generating Doxygen documentation..."
time doxygen "$DOXYFILE"

echo ""
echo "Doxygen documentation generated in \"$OUTPUT_DIRECTORY\"." 
echo "Opening the Doxygen documentation in the Google Chrome web browser..."
echo "Running cmd:  google-chrome \"$OUTPUT_DIRECTORY/html/index.html\""
echo ""
google-chrome "$OUTPUT_DIRECTORY/html/index.html"
