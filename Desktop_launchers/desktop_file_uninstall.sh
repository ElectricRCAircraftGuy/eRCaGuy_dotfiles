#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# - See "desktop_file_install.sh"

DESKTOP_FILE_PATH=$1 # relative OR absolute path--whatever the user inputs
DESKTOP_FILE_PATH_ABS="$(realpath $DESKTOP_FILE_PATH)" # absolute path
DESKTOP_FILENAME="basename $DESKTOP_FILE_PATH_ABS" # *.desktop file name

TRASH_PATH="$HOME/.local/share/Trash/files"

echo "UNinstalling desktop file."
echo "Trash location is \"$TRASH_PATH\"."

# Remove from Desktop
DESKTOP_PATH="$HOME/Desktop/$DESKTOP_FILENAME"
echo "Moving Desktop symbolic link (\"$DESKTOP_PATH\") to the Trash."
mv "$DESKTOP_PATH" "$TRASH_PATH"

# Remove from Application menu
APP_PATH="/usr/share/applications/$DESKTOP_FILENAME"
echo "Moving Application Menu symbolic link (\"$APP_PATH\") to the Trash."
mv "$APP_PATH" "$TRASH_PATH"

echo "Done!"
