**This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles**


# Nemo action files

...to add right-click menu options to Nemo.


# Notes:

1. Install Nemo: follow my instructions here: [How to install Nemo and set it as the default file manager in Ubuntu 22.04](https://askubuntu.com/a/1446372/327339).
1. To activate a right-click menu Nemo action, simply copy or symlink your desired `*.nemo_action` file into the `~/.local/share/nemo/actions` dir:
    ```bash
    # Option 1 (my preference): symlink file "my.nemo_action" to "~/.local/share/nemo/actions/"
    ln -si "path/to/my.nemo_action" ~/.local/share/nemo/actions/ 

    # Option 2: copy file "my.nemo_action" to "~/.local/share/nemo/actions/"
    cp -i "path/to/my.nemo_action" ~/.local/share/nemo/actions/
    ```
1. Find many example `*.nemo_action` files or scripts (including in Python) in your local directory here, _after_ installing Nemo: [/usr/share/nemo/actions](/usr/share/nemo/actions).
    1. [sample.nemo_action](sample.nemo_action) was copied from there: `/usr/share/nemo/actions/sample.nemo_action`.
    1. See all of these online in Nemo's/Linux Mint's official GitHub repo too!:
        1. https://github.com/linuxmint/nemo/tree/master/files/usr/share/nemo/actions
        1. https://github.com/linuxmint/nemo/blob/master/files/usr/share/nemo/actions/sample.nemo_action
1. See the answer I helped edit/write too: [How to configure Nemo's right-click "Open in Terminal" to launch "gnome-terminal"](https://unix.stackexchange.com/a/582462/114401)
