This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [See also](#see-also)
1. [Useful Applications](#useful-applications)

<!-- /MarkdownTOC -->
</details>


<a id="see-also"></a>
# See also

1. [serial_terminals_README.md](serial_terminals_README.md)
1. [../useful_startup_programs.md](../useful_startup_programs.md)


<a id="useful-applications"></a>
# Useful Applications

In addition to my [useful_scripts](../useful_scripts), such as [`touchpad_toggle.sh`](../useful_scripts/touchpad_toggle.sh) and [`open_programming_tools.sh`](../useful_scripts/open_programming_tools.sh), the following are some of the applications, in no particular order, I find really useful that I like to set up and configure after each new Ubuntu install:

1. `nemo` file manager - MUCH better than the default `nautilus` file manager which comes with Ubuntu!
    1. See my answer here: https://askubuntu.com/questions/1066752/how-to-set-nemo-as-the-default-file-manager-in-ubuntu-18-04/1173861#1173861
    1. Adding actions to nemo's right-click menu. See here:
        1. ["open_in_terminator.nemo_action" custom Nemo right-click menu action](../nemo/open_in_terminator.nemo_action)
        1. https://unix.stackexchange.com/questions/336368/how-to-configure-nemos-right-click-open-in-terminal-to-launch-gnome-terminal/582462#582462
        1. https://github.com/linuxmint/nemo/blob/master/files/usr/share/nemo/actions/sample.nemo_action
        1. Also: open the Nemo "Files" program --> Edit --> Preferences --> "Context Menus" tab in the left-hand pane --> check the box for "Make Link". This adds an entry to the right-click menu for "Make Link", which makes a symlink to the selected file or folder. 

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
1. Sublime Text 3 - a powerful GUI text and code editor
1. `micro` - a poweful mouse-supported CLI text and code editor
    1. For configuring its settings, see here: [eRCaGuy_dotfiles/home/.config/micro/README.md](../home/.config/micro/README.md)
    1. https://micro-editor.github.io/
    1. https://github.com/zyedidia/micro#installation
    1. My installation process:
        ```bash
        mkdir -p ~/bin 
        # download the `micro` executable and move it to ~/bin
        curl https://getmic.ro | bash
        mv micro ~/bin
        # re-source shell configuration to add ~/bin to your PATH variable if in Ubuntu and
        # using the default ~/.profile file
        . ~/.profile
        ```
1. LibreOffice
1. `terminator` terminal - allows easy splitting and tiling of multiple terminals in one single window! A good *local terminal* alternative to `gnome-terminal` + `tmux` for splitting windows. You can right-click in the terminal and split the window horizontally or vertically.
    1. *Config settings to change:* 
        1. See my notes here: [eRCaGuy_dotfiles/home/.config/terminator/README.md](../home/.config/terminator/README.md)
            1. See especially my comments here and below it: [GitHub: micro: Fixed: how to disable interfering shortcut keys in `terminator`](https://github.com/zyedidia/micro/issues/2688#issuecomment-1404008312)
        1. Get my config settings direcly from here: [eRCaGuy_dotfiles/home/.config/terminator/config](../home/.config/terminator/config)
    1. https://gnome-terminator.org/
    1. Install
        ```bash
        sudo apt install terminator
        ```
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
    1. To use the _built-in logger in terminator_: see my own ans. here: [How to activate Automatic Logging in Terminator?](https://stackoverflow.com/a/62493626/4561887)
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
    1. See my detailed installation, setup, and usage instructions here: https://stackoverflow.com/questions/37040798/how-do-you-use-youtube-dl-to-download-live-streams-that-are-live/66838396#66838396. 
    1. See also this really great quick setup tutorial here, by Kezz Bracey on 25 Jul 2020, where I learned how to use it and set it up, and learned how to write my instructions above: https://photography.tutsplus.com/tutorials/obs-for-screen-recording-quick-start--cms-28549
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
1. `git sizer`: analyze your git repos for size; this is an official tool used and supported by GitHub to help enforce repo size limits.
    1. Install info: https://github.com/github/git-sizer#getting-started
    1. GitHub's official repo size documentation: https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github
    1. [my ans] https://stackoverflow.com/questions/38768454/repository-size-limits-for-github-com/70427664#70427664
1. Ookla `speedtest` CLI. 
    1. For full installation instructions, see the [main readme's "Misc. Install Instructions" section](../README.md#misc-install-instructions).
1. Serial terminals
    1. See also: 
        1. \*\*\*\*\* [serial_terminals_README.md](serial_terminals_README.md)
        1. [../git & Linux cmds, help, tips & tricks - Gabriel.txt](<../git & Linux cmds, help, tips & tricks - Gabriel.txt>) - and search the file for "serial", "Serial terminal tools", "USB, serial, devices, etc.".
    1. [`picocom`](https://github.com/npat-efault/picocom) [my favorite!]
        1. My installation instructions: [serial_terminals_README.md#picocom](serial_terminals_README.md#picocom)
    1. `minicom`
    1. Arduino Serial Monitor and Serial Plotter
    1. [eRCaGuy_PyTerm](https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm)

1. Potential file syncrhonization tools to try out:
    1. See my notes: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues/24#issuecomment-1401223948
    1. https://github.com/syncthing/syncthing - very highly-rated
    1. https://github.com/lsyncd/lsyncd
    1. My answer, mentioning my `git`-based sync script: https://stackoverflow.com/a/61109889/4561887

1. Potential terminal emulators to use:
    1. alacritty - a new terminal emulator which supports the OSC 52 terminal clipboard needed to make `micro`'s copy/paste features work easily over ssh. 
        1. https://github.com/alacritty/alacritty
        1. https://github.com/alacritty/alacritty/blob/master/INSTALL.md
        1. Why one might consider using the alacritty terminal in the first place (it supports copy/paste operations in the `micro` editor over ssh): [see my comment here--see also the discussion just above my comment]: https://github.com/zyedidia/micro/issues/538#issuecomment-1406713447

1. Potential mouse-enabled CLI file managers to use:
    1. [Google search for "linux mouse enabled cli file manager"](https://www.google.com/search?q=linux+mouse+enabled+cli+file+manager&oq=linux+mouse+enabled+cli+file+manager&aqs=chrome..69i57.8975j0j7&sourceid=chrome&ie=UTF-8)
        1. \*\*\*\*\* https://www.tecmint.com/linux-terminal-file-managers/
    1. `mc` - GNU Midnight Commander - seems really good!
        ```bash
        sudo apt install mc  
        mc
        ```
        - Open the program with `mc`.  
        - Once in the program, press **Ctrl+o** to toggle back and forth between the main terminal and Midnight Commander, or press **F10** to exit.
        - show a compact type view by going to Left/Right --> Listing mode... --> "Brief file list"
    1. `ranger`
        ```bash
        sudo apt install ranger
        ranger
        ```
        - Ctrl+C, then Q, to quit.
