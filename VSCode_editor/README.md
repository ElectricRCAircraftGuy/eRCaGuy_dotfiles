**This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles**

This is for the [Microsoft Visual Studio Code (MS VSCode)](https://code.visualstudio.com/) text editor/IDE. 

The `.vscode` dir should be placed at the root of your workspace (ie: the folder you intend to open up via **File --> Open Folder**). You also have a user-level `~/.vscode` dir.

The `settings.json` and `keybindings.json` files should be copy-pasted into this dir: `~/.config/Code/User/`.


## See especially

1. **Installation instructions of my VSCode settings files and extensions: [../home/.config/Code/User/README.md](../home/.config/Code/User/README.md)**


## See also

1. (private for now) [Microsoft Visual Studio Code (MS VSCode) IDE and Editor Setup & Info](https://docs.google.com/document/d/1agYnaN8FYjmitqgNzA7MhLbA0oifkYTQn_axLCTFxAg/edit)


## Common VSCode Extensions/Plugins I like to install

### [Update Sept. 2023: see my "see especially" file just above instead.]

See [.vscode/extensions/extensions.json](.vscode/extensions/extensions.json) for a list of recommendations. Place the `.vscode` folder into the root of your VSCode workspace. Then, in VSCode, go to the Extensions tab and search for "@recommended". This will search this file for the recommendations therein and bring them all up under the "WORKSPACE RECOMMENDATIONS" search results section. Click the little tiny cloud-looking icon to the right of that heading to "Install Workspace Recommended Extensions" automatically for you!

References:  
1. https://tattoocoder.com/recommending-vscode-extensions-within-your-open-source-projects/


## Common VSCode shortcuts I like 

Many of these are very similar to Sublime Text.

1. Ctrl + K, O
    1. Open up the current file into a new window (ex: so you can drag it into a new monitor).
1. Alt + Q
    1. Automatically hard-wrap the current line. Keep pressing it to toggle wrapping at the various rulers you may have set.
    1. Requires the **Rewrap** extension.
1. Alt + O
    1. Toggle jumping back and forth between the C or C++ header .h file and the .c or .cpp source file.
1. Ctrl + P
    1. Search for files and things
1. Ctrl + Shift + P
    1. Command Palette - type commands here
1. Ctrl + F
    1. Search *within* a file
1. Ctrl + Shift + F
    1. File search: ie: search _within_ files.
1. Ctrl + G
    1. Go to line


## Troubleshooting

1. [Still investigating] If `cpptools` sucks up all of your RAM (ex: 32 GB+ of your 64 GB), consider uninstalling the `c/c++` `cpptools` or whatever, and installing `clangd` instead, whatever that is. Someone recommended this to me.

