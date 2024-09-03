This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Readme & Install Info.

There are 2 ways to install these \*.desktop files, as described below.


## 1. (Recommended--is a little easier) Automated Install/Uninstall of Desktop Files:

Install desktop file `new_launcher.desktop`:

```bash
eRCaGuy_dotfiles/Desktop_launchers/desktop_file_install.sh new_launcher.desktop
```

Uninstall desktop file `new_launcher.desktop`:

```bash
eRCaGuy_dotfiles/Desktop_launchers/desktop_file_uninstall.sh new_launcher.desktop
```


## 2. (Works just fine too) Manual Install/Uninstall of Desktop Files:

See my answer here also: https://askubuntu.com/questions/64222/how-can-i-create-launchers-on-my-desktop/1014261#1014261.
 
1. Ensure the `~/Desktop_launchers` directory exists:
    ```bash
    mkdir -p ~/Desktop_launchers
    ```
2. Copy a \*.desktop file to `~/Desktop_launchers` & ensure it is executable.
    ```bash
    cd /path/to/here
    cp -i new_launcher.desktop ~/Desktop_launchers
    chmod +x ~/Desktop_launchers/new_launcher.desktop
    ```
3. Manually edit the file to update the display "Name", "Exec" executable path, and "Icon". 
    1. Note that many system icons can be found in `/usr/share/icons`. If you find an icon you like, you can frequently just access it by its file name withOUT the file extension and withOUT the full path. Example: I found this icon I like here: `/usr/share/icons/gnome/16x16/devices/input-touchpad.png`. So, if I just set the Icon to `Icon=input-touchpad` inside my \*.desktop file, it turns out it works just fine! See this answer here, as well as my comment underneath it: [AskUbuntu.com: Where are the .desktop icon files stored?](https://askubuntu.com/a/217339/327339).
    
    ```bash
    # open in gedit GUI editor, then edit & save
    gedit ~/Desktop_launchers/new_launcher.desktop
    ```
4. Make a symbolic link to the above desktop file, on the Desktop, so you can launch it by double-clicking on it on the Desktop: 
    1. Command Format: `ln -s /path/to/file /path/to/symlink_to_make`.

    ```bash
    ln -s ~/Desktop_launchers/new_launcher.desktop ~/Desktop/new_launcher.desktop
    ```
5. Make a symbolic link to the desktop file on the Application menu so you can launch it from the Application Menu or Ubuntu Dock too. 
    1. Notes:
        - Application .desktop files are stored in: `/usr/share/applications`.
        - The .desktop files in the applications directory, unlike on the Desktop, don't need to be marked executable to work.

    ```bash
    sudo ln -s ~/Desktop_launchers/new_launcher.desktop /usr/share/applications/new_launcher.desktop
    ```
6. Done! Now if you ever need to update the desktop file, update it directly in only one place: at `~/Desktop_launchers/new_launcher.desktop`, and the changes will automatically be recognized by the symlinks on the Desktop and in `/usr/share/applications`. If the Desktop icon doesn't update after changing it, click on the Desktop then hit either **F5** or **Ctrl** + **R** to refresh the Desktop icons.
7. To remove the shortcuts, simply delete the symlinks from the Desktop and from `/usr/share/applications` folder as follows:
    ```bash
    rm ~/Desktop/new_launcher.desktop
    sudo rm /usr/share/applications/new_launcher.desktop
    ```


# Icon locations (see also my notes about icons in the manual instructions above):

On Ubuntu systems, apparently desktop file icons can be found in the following places. See:

1. https://askubuntu.com/questions/476233/how-to-include-environment-variable-in-launcher-for-icon/476710#476710
1. https://askubuntu.com/questions/6009/where-are-icons-stored/6010#6010
1. https://askubuntu.com/questions/217331/where-are-the-desktop-icon-files-stored/217339#217339

```bash
$HOME/.icons
$HOME/.local/share/icons
/usr/local/share/icons
/usr/share/icons
/usr/share/pixmaps
```

Example:

An excellent place to search for application icons is `/usr/share/icons/gnome/256x256/apps`. 

The following setting for `Icon` in a .desktop file is valid, since the icon named `terminal` is found in one of the above locations:

```bash
Icon=terminal
```

You can find the potential location of this `terminal` icon like this:
```bash
find \
    $HOME/.icons \
    $HOME/.local/share/icons \
    /usr/local/share/icons \
    /usr/share/icons \
    /usr/share/pixmaps \
    -iname "terminal.*"
```

One of the output locations in the results from the find command just above is `/usr/share/icons/gnome/256x256/apps/terminal.png`. 

Search that `/usr/share/icons/gnome/256x256/apps` directory for more application icons.
