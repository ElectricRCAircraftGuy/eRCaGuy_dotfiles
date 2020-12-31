
# Useful Applications

In addition to my [useful_scripts](../useful_scripts), such as [`touchpad_toggle.sh`](../useful_scripts/touchpad_toggle.sh) and [`open_programming_tools.sh`](../useful_scripts/open_programming_tools.sh), the following are some of the applications, in no particular order, I find really useful that I like to set up and configure after each new Ubuntu install:

1. `nemo` file manager - MUCH better than the default `nautilus` file manager which comes with Ubuntu!
    1. See my answer here: https://askubuntu.com/questions/1066752/how-to-set-nemo-as-the-default-file-manager-in-ubuntu-18-04/1173861#1173861
    1. Adding actions to nemo's right-click menu. See here:
        1. ["open_in_terminator.nemo_action" custom Nemo right-click menu action](../nemo/open_in_terminator.nemo_action)
        1. https://unix.stackexchange.com/questions/336368/how-to-configure-nemos-right-click-open-in-terminal-to-launch-gnome-terminal/582462#582462
        1. https://github.com/linuxmint/nemo/blob/master/files/usr/share/nemo/actions/sample.nemo_action
1. `thunar` file manager and its accompanying "Bulk Rename" application
    1. `sudo apt install thunar`
    1. Very useful for its "Bulk Rename" application alone!
1. `pcmanfm` light-weight file manager for seeing folders nicely sorted
1. `shutter` screenshot tool
    1. `sudo apt install shutter`
    1. See here to re-enable its "Edit" toolbar tool once you've installed it: https://askubuntu.com/questions/1029085/how-to-enable-the-edit-button-in-shutter/1029101#1029101
1. Color pickers:
    1. See: https://www.fossmint.com/color-picking-tools-for-linux/
    1. %%%%%+ `gpick` - [USE THIS ONE!] FANTASTIC color picker, with a zoomable preview to show you *exactly* where you are looking at pixels on the screen!
        1. `sudo apt install gpick`
    1. `color-picker` - it's OK; alternative to the above; may have some other features worth looking into perhaps
        1. `sudo snap install color-picker`
1. `gimp`
1. `inkscape`
1. VLC Media Player
1. Super Tux 2 (Super Nintendo Mario-like game)
1. Super Tux Kart (N64 Super Mario Kart-type racing game) - https://supertuxkart.net/Main_Page
1. `gsmartcontrol` - for checking the disk health of HDDs (Hard Disk Drives) and SSDs (Solid-State Drives).
1. eclipse - see my PDF in the [eclipse folder here](eclipse) for full setup instructions
1. Arduino
1. Sublime Text 3
1. LibreOffice
1. `terminator` terminal - allows easy splitting and tiling of multiple terminals in one single window! A good *local terminal* alternative to gnome-terminal + tmux.
    
        sudo apt install terminator

    1. Add the "Open in Terminator" right-click menu option to the Nemo GUI file manager! See the `nemo` section above.
    1. To change your default terminal application now between `gnome-terminal` and `terminator`, see: 
        1. https://askubuntu.com/questions/1096329/how-to-change-my-default-terminal-to-gnome-terminal-rather-than-terminator/1096331#1096331
        1. https://unix.stackexchange.com/questions/336368/how-to-configure-nemos-right-click-open-in-terminal-to-launch-gnome-terminal/336587#336587
    1. [DO this] Now set Ctrl + Alt + T to open terminator:

            gsettings set org.gnome.desktop.default-applications.terminal exec terminator

    1. [Do NOT do: optional--actually, do NOT do this! Instead, add the additional right-click menu to Nemo to "Open in Terminator"--see `nemo` section above!] To make the right-click option in Nemo for "Open in Terminal" open terminator instead of gnome-terminal:

            # Don't do this: set terminator as the default right-click terminal option in nemo
            gsettings set org.cinnamon.desktop.default-applications.terminal exec terminator
            # Do this instead: keep gnome-terminal as the default right-click option in nemo
            gsettings set org.cinnamon.desktop.default-applications.terminal exec gnome-terminal

    1. [Do NOT do: no need to do this] Some answers talk about doing this too, but it's also NOT necessary: `sudo update-alternatives --config x-terminal-emulator` - then choose the desired option from the CLI menu. Instead, do the Ctrl + Alt + T setting above, and add terminator to the right-click menu in nemo following the directions in the nemo setion above.
    1. [DO this] COLORS: the default colors in terminator are kind of ugly. Make the background and font colors the same as gnome-terminal instead. Using `gpick`, I determined the gnome-terminal colors are as follows:
        1. text:        #FEFFFF (rgb(254, 255, 255): almost white--ever-so-slightly cyan)
        1. background:  #2D0922 (rgb(45, 9, 34): dark purplish/magenta-ish-grey)
        1. SET THESE COLORS IN TERMINATOR: Right-click --> Preferences --> "Profiles" tab --> "Colors" sub-tab --> choose "Custom" from the "Built-in schemes" drop-down menu --> 
            1. --> click the "Text color" color swatch --> click the "+" under the "Custom" section to create a custom color --> type "#FEFFFF" into the box --> press Tab to make it show up --> click the "Select" button.
            1. --> click the "Background color" color swatch --> click the "+" under the "Custom" section to create a custom color --> type "#2D0922" into the box --> press Tab to make it show up --> click the "Select" button.
            1. --> when done with both steps above, click "Close". Done!
    1. To use the built-in logger in terminator: see my own ans. here: https://stackoverflow.com/questions/34472973/how-to-activate-automatic-logging-in-terminator/62493626#62493626
    1. [DO THESE THINGS TOO!]
        1. **Enable the Terminal bell sound:** right-click on the terminator screen --> Preferences --> click the "Profiles" tab at the top --> ensure the "General" sub-tab is chosen --> check the box for "Audible beep" under the "Terminal bell" section in the bottom-right. See my ans here: https://askubuntu.com/questions/1253799/terminator-terminal-wont-play-bell-sound/1253800#1253800.
        1. **Disable the window dimming when the terminator terminal is not in focus:** right-click on the terminator screen --> Preferences --> click the "Global" tab at the top --> in the center-left under the "Appearance" section drag the slider for "Unfocused terminal font brightness" to the far right (from 80% to 100%) --> click "Close".
        1. **Increase scrolling/number of scroll-back lines:** right click on screen --> Preferences --> "Profiles" tab at the top --> "Scrolling" sub-tab --> either increase the lines from 500 to like 50000 or 500000, or check the box for "Infinite Scrollback" [my preferred choice]. Source: https://askubuntu.com/questions/618464/unlimited-scroll-in-terminator/618469#618469.
1. `tmux` remote terminal tool - keeps remote sessions alive even after disconnecting or closing the local terminal window
1. NoMachine - for graphical remote desktop connections to a remote server or computer
1. Remmina - for graphical remote desktop connections, including to Windows rdp hosts
1. PuTTY - for tunneling, reverse tunneling, and SOCKS 5 proxy forwarding
    1. OpenSSH should also work fine (the default `ssh`-related series of terminal commands which [come pre-installed on Ubuntu](https://stackoverflow.com/questions/47079224/how-do-i-check-if-openssh-is-installed-on-ubuntu/58617302#58617302)), but sometimes the GUI setup in PuTTY is nice, even on Linux
1. Shotcut - excellent video editor. Download the latest Linux portable tar or Linux AppImage straight from their website here: https://shotcut.org/.
1. OBS Studio (Open Broadcaster Software) - a really good, cross-platform, and free and open source _screen recorder_ and screencasting/streaming tool for making video tutorials! https://obsproject.com/. 
1. `mediainfo-gui` - very useful tool to quickly see video or audio file metadata, such as bitrates and sample rates of audio, and video resolution, as well as encoding information.
    1. Install the GUI version with `sudo apt install mediainfo-gui`, or the CLI version with `sudo apt install mediainfo`. 
    1. Then, right-click on any video or audio file in your file manager (ex: nemo) --> Open With --> MediaInfo. 
    1. See here: https://www.fosslinux.com/1860/find-metadata-info-of-audio-and-video-files-using-mediainfo.htm
    1. Note that for _images_ or _pictures_ in nemo, just use nemo's built-in photo properties information instead of mediainfo-gui. Just Right Click --> Properties --> click on the "Image" tab for image information.
1. `exiftool` - useful CLI tool to read, write, and update the metadata of various file types, including PDF, audio, video, and images. See: https://linuxhint.com/get_filea_metadata_exif_tool/.
    1. Install: `sudo apt install libimage-exiftool-perl`
    1. Use: `exiftool <filename>`. Ex: `exiftool my_video.mp4`.
    1. This tool shows far more information than `mediainfo-gui` above!
1. `git gui`: `sudo apt update && sudo apt install git-gui` - useful for adding changes to be committed in git, graphically in a GUI, _line-by-line_ or code _chunk-by-chunk_, rather than just _file-by-file_. 
