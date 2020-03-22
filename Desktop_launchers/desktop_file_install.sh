#!/bin/bash

# Author: Gabriel Staples

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# desktop_file_install.sh
# - "install" a desktop file by symbolically linking it to:
#   1. The shared user application directory, so it is available from the applications menu and Dock, and 
#   2. The Desktop directory, so it is available on your desktop. If you don't want it here, just delete it
#      from the Desktop when done.
# TODO: find out how what I'm doing here differs from the `desktop-file-install` tool built in to Ubuntu.

# INSTRUCTIONS:
# 1. Create symlinks in ~/bin to these scripts so you can run them from anywhere:
#           cd /path/to/here
#           mkdir -p ~/bin
#           ln -s "${PWD}/desktop_file_install.sh" ~/bin/desktop_file_install
#           ln -s "${PWD}/desktop_file_uninstall.sh" ~/bin/desktop_file_uninstall
#   - NB: this requires that your user's "~/bin" dir ($HOME/bin) be in your PATH variable! If it is not, 
#     and you are running Ubuntu or similar, simply copy this project's .profile file to your home dir and 
#     reboot. Your $HOME/bin directory will now be at the start of your PATH variable!
# 2. Use:
#   - Note that the path to "my_launcher.desktop" can be relative OR absolute!
#   A) Install a *.desktop file:
#     - This will make "my_launcher" become visible both on the Desktop and in the Application Menu, via symlinks,
#       and you can now optionally at its shortcut to the Dock as a "Favorite" by right-clicking its icon in
#       the Application Menu or Dock.
#           desktop_file_install my_launcher.desktop`
#   B) Uninstall a *.desktop file:
#     - This will delete the symlink files created during "install", thereby removing this launcher from
#       both the Application Menu and the Desktop.
#           desktop_file_uninstall my_launcher.desktop

DESKTOP_FILE_PATH="$1" # relative OR absolute path--whatever the user inputs
DESKTOP_FILE_PATH_ABS="$(realpath "$DESKTOP_FILE_PATH")" # absolute path
DESKTOP_FILENAME="$(basename "$DESKTOP_FILE_PATH_ABS")" # *.desktop file name

echo "Installing desktop file from \"$DESKTOP_FILE_PATH_ABS\"."

# Ensure it is executable
echo "Ensuring desktop file is executable."
chmod +x "$DESKTOP_FILE_PATH_ABS"

# Add to Desktop
DESKTOP_PATH="$HOME/Desktop/$DESKTOP_FILENAME"
echo "Adding symbolic link to the desktop at \"$DESKTOP_PATH\"."
ln -s "$DESKTOP_FILE_PATH_ABS" "$DESKTOP_PATH"

# Add to Application menu
APP_PATH="/usr/share/applications/$DESKTOP_FILENAME"
echo "Adding symbolic link to the Application Menu at \"$APP_PATH\"."
sudo ln -s "$DESKTOP_FILE_PATH_ABS" "$APP_PATH"

echo "Done!"