#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Install all scripts!
# - Edit this file manually, as desired, if you only want to install some scripts. 
# - Just comment out what you don't want to install.

# Goal: Have this script automatically install (by creating symlinks in ~/bin) all scripts herein!
# For the sake of making it super easy to find all custom scripts, prepend each symbolic link in ~/bin with 
# the user's initials, like this: "gs_myscript".

# Optional: this will be prepended to every symbolic link created in ~/bin in order to make it super easy to 
# find all of your custom scripts. I recommend you set it to your initials, followed by an underscore. Set it
# to "" to not prepend anything.
PREPEND_STR="gs_" # set to your initials
# PREPEND_STR="" # or use this one to use nothing

# See my own ans here: https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself/60157372#60157372
THIS_PATH="$(realpath $0)"
echo "Path to this install script = \"$THIS_PATH\""
THIS_DIR="$(dirname "$THIS_PATH")"
# echo "THIS_DIR = \"$THIS_DIR\"" # for debugging 

mkdir -p ~/bin
cd "$THIS_DIR"

echo    "-----------------------------------------------------------------------------------------"
echo -e "Beginning installation. Note that if it asks if you'd like to \"overwrite\" or \"replace\"\n"\
"a file, simply pressing Enter will default to \"No\", which is the safe option to take."
echo    "-----------------------------------------------------------------------------------------"

# Desktop_launchers
echo "Copying \"Desktop_launchers\" files to ~/Desktop_launchers"
cp -ri Desktop_launchers/*.desktop ~/Desktop_launchers
cp -ri Desktop_launchers/*.md ~/Desktop_launchers
echo "Installing \"desktop_file_install\" & \"desktop_file_uninstall\" scripts"
ln -si "$PWD/Desktop_launchers/desktop_file_install.sh" ~/bin/${PREPEND_STR}desktop_file_install
ln -si "$PWD/Desktop_launchers/desktop_file_uninstall.sh" ~/bin/${PREPEND_STR}desktop_file_uninstall

