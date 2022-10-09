
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
<a id="picocom"></a>
1. `picocom` [my preferred command-line serial terminal program]: a serial terminal command-line program to communicate with serial devices such as Arduinos or embedded Linux boards over serial. Use it as an alternative to [`minicom`](https://linux.die.net/man/1/minicom) or the Arduino Serial Monitor.
    1. https://github.com/npat-efault/picocom
    1. First, add yourself to the `dialout` group so you can access serial devices without using `sudo` or being root. See my instructions here: [../arduino/README.md](../arduino/README.md).
        ```bash
        # Add your user to the "dialout" group
        sudo usermod -a -G dialout $USERNAME
        # Now, log out entirely from Ubuntu, then log back in. You will now have the privileges of
        # this group! Let's verify that. You should see `dialout` as one of the words printed 
        # when you run this:
        groups $USERNAME
        ```
    1. Install & use:
        ```bash
        # 1. Download and build the program

        # cd to wherever you'd like to download the program
        cd ~/GS/dev
        git clone https://github.com/npat-efault/picocom.git
        cd picocom
        make

        # You can now run the program like this. 
        # - To exit, type Ctrl + A, Ctrl + X. See the readme here:
        #   https://github.com/npat-efault/picocom
        # - Ctrl + C does NOT exit the program because you may want Ctrl + C to actually be 
        #   forwarded to your remote serial device instead! So, Ctrl + C gets forwarded to your 
        #   device. Ctrl + A, Ctrl + X, therefore, is required to exit picocom. 
        ./picocom --baud 115200 /dev/ttyUSB0

        # check the version by viewing the first line output by the help menu
        ./picocom --help

        # View the "man" (manual) pages manually like this:
        man ./picocom.1

        # 2. Install the program

        # create the ~/bin dir if it doesn't already exist
        mkdir -p ~/bin
        # add a symlink to the executable
        ln -si "$PWD/picocom" ~/bin
        # add a symlink to the man page so you can do `man picocom`
        # See: https://askubuntu.com/a/244810/327339
        sudo ln -si "$PWD/picocom.1" /usr/local/share/man/man1

        # re-source your bash initialization file; don't know what "source" means? Read my answer
        # here: https://stackoverflow.com/a/62626515/4561887
        . ~/.bashrc

        # now log out and log back in if this is your first time creating the ~/bin dir

        # now you can run the program without specifying the whole path to it
        picocom --baud 115200 /dev/ttyUSB0
        picocom --help
        man picocom
        ```
    1. Logging
        ```bash
        # You can data-log all serial input/output by appending to a log file like this; 
        # see `man picocom` and search for `--logfile` for details
        picocom --baud 115200 --logfile serial_log.txt /dev/ttyUSB0
        ```
    1. Transferring files over serial. 
        1. Transfering files over serial can be done. See: [Unix & Linux: How to get file to a host when all you have is a serial console?](https://unix.stackexchange.com/q/312/114401). The preferred technique would be to use the ZMODEM error-checking protocol (see here: [Wikipedia: ZMODEM](https://en.wikipedia.org/wiki/ZMODEM)) via [`lrzsz`](https://www.ohse.de/uwe/software/lrzsz.html), which provides the `rx`, `rb`, and `rz` modem file receive functions (and [is available on Buildroot too](https://github.com/buildroot/buildroot/tree/master/package/lrzsz)), and the `sx`, `sb`, and `sz` modem file receive functions. 
        1. Or, you could use the [kermit](https://en.wikipedia.org/wiki/Kermit_(protocol)) protocol in case XMODEM (`rx` and `sx`), YMODEM (`rb` and `sb`), and ZMODEM (`rz` and `sz`) are not available. 
        1. However, if neither `lrzsz` nor `kermit` is available, then you can encode binary files into text using `uuencode` (I can't get this to work at all for me) or `base64` (preferred), and then just manually send them over using `picocom` and `cat` or `picocom` and `ascii-xfr`, [as mostly explained by this answer here](https://unix.stackexchange.com/a/296752/114401). 
        1. To install `lrzsz` and `ascii-xfr` on Linux Ubuntu, do this:
            ```bash
            sudo apt update
            # NB: installing `minicom` **alone** includes both `minicom` **and** `lrzsz`!
            # (and `minicom` includes the `ascii-xfr` executable too).
            sudo apt install minicom 

            # Or, to install just `lrzsz`:
            sudo apt install lrzsz
            ```
        1. To learn about the ingenuity of the ZMODEM auto-resend and error-checking protocol, see here: https://en.wikipedia.org/wiki/ZMODEM:
        > ZMODEM replaced the packet number with the actual location in the file, indicated by a 32-bit number. This allowed it to send NAK messages that re-wound the transfer to the point of failure, regardless of how long the file might be. This same feature was also used to re-start transfers if they failed or were deliberately interrupted. In this case, the receiver would look to see how much data had been previously received and then send a NAK with that location, automatically triggering the sender to start from that point.
1. [eRCaGuy_PyTerm](https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm) - a datalogging serial terminal/console program which I wrote, written in Python.
    1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm
    1. Can be used in place of `minicom`, `picocom`, or the Arduino Serial Monitor.
    1. This program works fine, but for general logging, you might consider `picocom`, however, instead. See its logging command just above. 
