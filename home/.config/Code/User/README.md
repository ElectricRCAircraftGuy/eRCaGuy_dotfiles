This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

This folder contains user settings for the Microsoft Visual Studio Code (MS VSCode) IDE/text and code editor.

For more details, and instructions, see: [eRCaGuy_dotfiles/VSCode_editor](../../../../VSCode_editor), in particular, the [README.md](../../../../VSCode_editor/README.md) file there.


## Installation instructions of these VSCode settings files

UPDATE/WORK-AROUND: OPTION 1 BELOW NO LONGER WORKS, DUE TO A BUG/CHANGE IN VSCODE. See my "pre-git-status" work-around in my comment here, instead: [How to write custom git hooks to automatically copy the changed VSCode `settings.json` and `keybindings.json` files whenever they change](https://github.com/microsoft/vscode/issues/195539#issuecomment-1763255597).

```bash
# UPDATE: FOR OPTION 1, USE MY GIT HOOK WORK-AROUND IN THE LINK ABOVE INSTEAD.
# Option 1 (what I do, to keep my dotfiles up to date): symlink the settings files; ie: 
# - Create a symlink in the "~/.config/Code/User/" directory which points to the actual settings 
#   files in my dotfiles repo.
cd path/to/eRCaGuy_dotfiles/home/.config/Code/User
ln -si "$(pwd)/keybindings.json" ~/.config/Code/User/
ln -si "$(pwd)/settings.json" ~/.config/Code/User/

# OPTION 2: (what you should do, to fully customize your settings): copy the files
# - copy the settings files from my dotfiles repo to your home dir so you can fully edit and
#   customize them
cd path/to/eRCaGuy_dotfiles/home/.config/Code/User
cp -i "$(pwd)/keybindings.json" ~/.config/Code/User/
cp -i "$(pwd)/settings.json" ~/.config/Code/User/
```

## VSCode extensions

See my list of extensions here: [../../../../VSCode_editor/install_vscode_extensions.sh](../../../../VSCode_editor/install_vscode_extensions.sh)

See this answer: [How can you export the Visual Studio Code extension list?](https://stackoverflow.com/a/49398449/4561887)

```bash
# 1. Back up a list of all extensions
cd path/to/eRCaGuy_dotfiles/VSCode_editor
code --list-extensions | xargs -L 1 echo code --install-extension | tee install_vscode_extensions.sh

# 2. Install all of the backed-up extensions
cd path/to/eRCaGuy_dotfiles/VSCode_editor
bash install_vscode_extensions.sh
```

Share the `install_vscode_extensions.sh` file with a friend if they want to install all of the same extensions.


## Notes

#### FAILED "Option 1" installation instructions above

It turns out that using hard links does *not* fix the issue! See my bug report here: [Saving the settings.json file in VSCode mistakenly wipes and recreates the file with a new inode number, breaking symlinks and hard links to it](https://github.com/microsoft/vscode/issues/195539).

```bash
# OPTION 1: (what I do, to keep my dotfiles up to date): **hard**link the settings files in this
# repo to the settings files where VSCode keeps them. 
# - NB: prior to ~12 Oct. 2023, I used to use symlinks, but I switched to hardlinks because trial
#   and error tells me that the latest version of VSCode (v1.83.0) now overwrites symlinked setting
#   files in the "~/.config/Code/User/" dir every time you change your settings in the VSCode GUI.
#   This is irritating. This means it wipes out my symlinks, and replaces them with new, regular
#   files which are not in my dotfiles repo, so I lose my git tracking of the settings. Hard links
#   solve this problem. Read about them here:
#   https://www.cbtnuggets.com/blog/certifications/open-source/linux-hard-links-versus-soft-links-explained
#
# Make the settings files in this repo become **hard** links to the main VSCode settings files in my
# home dir. 
# - Note: take care not to point a hard link to a symlink in this case, or you will still have the
#   same problem. The VSCode settings files in the home dir must be actual files, or possibly hard
#   links, but NOT symlinks.
cd path/to/eRCaGuy_dotfiles/home/.config/Code/User
ln -i ~/.config/Code/User/keybindings.json .
ln -i ~/.config/Code/User/settings.json .
# Ensure it worked:
# 1. `stat` should show the status of the files as now having a "Links" value of 2. 
#    This indicates that 2 hard links now share the same inode number, indicating that the hard link
#    creation was successful.
stat *.json
# 2. `ls -li` should show the same inode number for both files, indicating that the hard link
#    creation was successful.
ls -li *.json
ls -li ~/.config/Code/User/*.json
```

