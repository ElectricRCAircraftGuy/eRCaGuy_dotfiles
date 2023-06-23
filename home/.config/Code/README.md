This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

This folder contains user settings for the Microsoft Visual Studio Code (MS VSCode) IDE/text and code editor.

For more details, and instructions, see: [eRCaGuy_dotfiles/VSCode_editor](../../../VSCode_editor).


## Installation instructions of these VSCode settings files

```bash
# Option 1 (what I do, to keep my dotfiles up to date): symlink the settings files
# - create a symlink to my settings files in my dotfiles repo
cd path/to/eRCaGuy_dotfiles/home/.config/Code/User
ln -si "$(pwd)/keybindings.json" ~/.config/Code/User/
ln -si "$(pwd)/settings.json" ~/.config/Code/User/

# Option 2 (what you should do, to fully customize your settings): copy the symlink files
# - copy the settings files from my dotfiles repo so you can fully edit and customize them
cd path/to/eRCaGuy_dotfiles/home/.config/Code/User
cp -i "$(pwd)/keybindings.json" ~/.config/Code/User/
cp -i "$(pwd)/settings.json" ~/.config/Code/User/
```
