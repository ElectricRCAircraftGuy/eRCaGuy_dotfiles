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

## VSCode extensions

See my list of extensions here: [../../../VSCode_editor/install_vscode_extensions.sh](../../../VSCode_editor/install_vscode_extensions.sh)

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
