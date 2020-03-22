#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTRUCTIONS:
# - See "desktop_file_install.sh"

DESKTOP_FILE_PATH="$1" # relative OR absolute path--whatever the user inputs
DESKTOP_FILE_PATH_ABS="$(realpath "$DESKTOP_FILE_PATH")" # absolute path
DESKTOP_FILENAME="$(basename "$DESKTOP_FILE_PATH_ABS")" # *.desktop file name

TRASH_PATH="$HOME/.local/share/Trash/files"
TIMESTAMP="$(date "+%Y%m%d-%H%Mhrs-%S.%Nsec")"

echo "UNinstalling desktop file named \"$DESKTOP_FILENAME\"."
echo "Trash location is \"$TRASH_PATH\"."

# Remove from Desktop
DESKTOP_PATH="$HOME/Desktop/$DESKTOP_FILENAME"
# Move to trash, appending ".DESK_" and a uniqe timestamp to ensure you don't overwrite anything already in the trash.
DESKTOP_PATH_TRASH="$TRASH_PATH/${DESKTOP_FILENAME}.DESK_${TIMESTAMP}"
echo -e "Moving Desktop symbolic link (\"$DESKTOP_PATH\") to the Trash\n  (\"$DESKTOP_PATH_TRASH\")."
mv -i "$DESKTOP_PATH" "$DESKTOP_PATH_TRASH"

# Remove from Application menu
APP_PATH="/usr/share/applications/$DESKTOP_FILENAME"
# Move to trash, appending ".APP_" and a uniqe timestamp to ensure you don't overwrite anything already in the trash.
APP_PATH_TRASH="$TRASH_PATH/${DESKTOP_FILENAME}.APP_${TIMESTAMP}"
echo -e "Moving Application Menu symbolic link (\"$APP_PATH\") to the Trash\n  (\"$APP_PATH_TRASH\")."
sudo mv -i "$APP_PATH" "$APP_PATH_TRASH"

echo "Done!"
