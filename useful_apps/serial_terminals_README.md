This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [See also](#see-also)
1. [Serial terminal programs](#serial-terminal-programs)
1. [`picocom`](#picocom)
    1. [Background](#background)
    1. [Installation](#installation)
    1. [General Usage](#general-usage)
1. [Transferring files over serial](#transferring-files-over-serial)
    1. [Background](#background-1)

<!-- /MarkdownTOC -->
</details>


<a id="see-also"></a>
# See also

1. [eRCaGuy_dotfiles/useful_apps/README.md](README.md)
1. [../git & Linux cmds, help, tips & tricks - Gabriel.txt](<../git & Linux cmds, help, tips & tricks - Gabriel.txt>) - and search the file for "serial", "Serial terminal tools", "USB, serial, devices, etc.".


<a id="serial-terminal-programs"></a>
# Serial terminal programs

1. [picocom](https://github.com/npat-efault/picocom) [my favorite]
    1. https://github.com/npat-efault/picocom
    1. See my installation instructions & notes below.
1. minicom
1. Arduino Serial Monitor and Serial Plotter
1. [eRCaGuy_PyTerm](https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm) - a datalogging serial terminal/console program which I wrote, written in Python.
    1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm
    1. Can be used in place of `minicom`, `picocom`, or the Arduino Serial Monitor.
    1. This program works fine, but for general logging, you might consider `picocom`, however, instead. See its logging command just above. 


<a id="picocom"></a>
# `picocom`


<a id="background"></a>
## Background

1. `picocom` [my preferred command-line serial terminal program]: a serial terminal command-line program to communicate with serial devices such as Arduinos or embedded Linux boards over serial. Use it as an alternative to [`minicom`](https://linux.die.net/man/1/minicom) or the Arduino Serial Monitor.
1. https://github.com/npat-efault/picocom


<a id="installation"></a>
## Installation

1. First, add yourself to the `dialout` group so you can access serial devices without using `sudo` or being root. See my instructions here: [../arduino/README.md](../arduino/README.md).
    ```bash
    # Add your user to the "dialout" group
    sudo usermod -a -G dialout $USERNAME
    # Now, log out entirely from Ubuntu, then log back in. You will now have the privileges of
    # this group! Let's verify that. You should see `dialout` as one of the words printed 
    # when you run this:
    groups $USERNAME
    ```
1. Install dependencies
    ```bash
    sudo apt update 
    # Install `lrzsz`. This gives you access to the XMODEM, YMODEM,
    # and ZMODEM protocol executables such as `rz` and `sz`, used to send and
    # receive files. More on this below. 
    sudo apt install lrzsz
    # OR (this also installs `lrzsz` automatically as a dependency of minicom)
    sudo apt install minicom
    ```
1. Download, build, & install
    ```bash
    # 1. Download and build the program

    # cd to wherever you'd like to download the program
    cd ~/GS/dev
    git clone https://github.com/npat-efault/picocom.git
    cd picocom
    make  

    # The `picocom` executable has now been created and can be run directly
    # (withOUT "installing" it first) simply by using the appropriate path to
    # it.
    #
    # Examples:
    #
    # View the help menu and the version; the version is listed on the first
    # line
    ./picocom --help
    # View the "man" (manual) pages manually like this:
    man ./picocom.1
    # For more-detailed usage, see the "Usage" section below.

    # 2. Install the program by adding symlinks to it to your PATH variable

    # create the ~/bin dir if it doesn't already exist
    mkdir -p ~/bin
    # add a symlink to the executable
    ln -si "$PWD/picocom" ~/bin
    # add a symlink to the man page so you can do `man picocom`
    # See: https://askubuntu.com/a/244810/327339
    sudo ln -si "$PWD/picocom.1" /usr/local/share/man/man1

    # re-source your bash initialization file; don't know what "source" means?
    # Read my answer here: https://stackoverflow.com/a/62626515/4561887
    . ~/.bashrc

    # now log out and log back in if this is your first time creating the ~/bin
    # dir, and `picocom` will now be in your PATH since Linux Ubuntu's default
    # ~/.profile file adds it to the path like this:
    #
    #       # set PATH so it includes user's private bin if it exists
    #       if [ -d "$HOME/bin" ] ; then
    #           PATH="$HOME/bin:$PATH"
    #       fi
    ```


<a id="general-usage"></a>
## General Usage

```bash
# Run picocom, connecting to serial device "/dev/ttyUSB0" at a baud rate of
# 115200
# - To exit, type Ctrl + A, Ctrl + X. See the readme here:
#   https://github.com/npat-efault/picocom
#   Search that document for "To exit picocom you have to type" and "C-a, C-x".
# - Ctrl + C does NOT exit the program because you may want Ctrl + C to actually
#   be forwarded to your remote serial device instead! So, Ctrl + C gets
#   forwarded to your device. Ctrl + A, Ctrl + X, therefore, is required to
#   exit picocom. 
picocom --baud 115200 /dev/ttyUSB0

# View the help menu and the version; the version is listed on the first line
picocom --help

# Check the man (manual) pages
man picocom

# Logging:
# You can data-log all serial input/output by appending to a log file like this; 
# see `man picocom` and search for `--logfile` for details
picocom --baud 115200 --logfile serial_log.txt /dev/ttyUSB0
```

1. Start running the program with, for instance: 
    ```bash
    picocom --baud 115200 /dev/ttyUSB0
    ```
1. **Exit the program** with <kbd>Ctrl</kbd> + <kbd>A</kbd> then <kbd>Ctrl</kbd> + <kbd>X</kbd>. 
1. Press <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>H</kbd> for the special command **help menu** while running. Here is the full menu displayed when you run this:
    ```
    *** Picocom commands (all prefixed by [C-a])

    *** [C-x] : Exit picocom
    *** [C-q] : Exit without reseting serial port
    *** [C-b] : Set baudrate
    *** [C-u] : Increase baudrate (baud-up)
    *** [C-d] : Decrease baudrate (baud-down)
    *** [C-i] : Change number of databits
    *** [C-j] : Change number of stopbits
    *** [C-f] : Change flow-control mode
    *** [C-y] : Change parity mode
    *** [C-p] : Pulse DTR
    *** [C-t] : Toggle DTR
    *** [C-g] : Toggle RTS
    *** [C-|] : Send break
    *** [C-c] : Toggle local echo
    *** [C-w] : Write hex
    *** [C-s] : Send file
    *** [C-r] : Receive file
    *** [C-v] : Show port settings
    *** [C-h] : Show this message
    ```
    Some of my most-common commands are listed below.
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>B</kbd> = set baud rate (type it in after)
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>U</kbd> = baud rate UP (increase baud rate)
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>D</kbd> = baud rate DOWN (decrease baud rate)
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>C</kbd> = toggle local echo on and off
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>W</kbd> = write hex; ex: type `41 42 43 44` to send the ASCII chars `ABCD`. Delimiting chars you may choose to use, such as spaces or colons, for example, are ignored. So, `41424344` and `41:42:43:44` both send the same thing. Do _not_, however, include the `0x` part before hex. Ex: to send `0x41` just type `41`, _not_ `0x41`. 
    1. See the ASCII table here: https://en.wikipedia.org/wiki/ASCII#Printable_characters.
    1. See also `man picocom` and search for "Write hex".
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>S</kbd> = send a file over serial *to* the remote device.
    1. By default, this requires the ZMODEM `sz` (send) and `rz` (receive) executables to be available on **both** the host computer **and** the remote serial device, in order to work. Those executables are usually part of the `lrzsz` package, and can also be built as part of Buildroot. See more on this below.
    1. See also `man picocom` and search for the section titled "SENDING AND RECEIVING FILES". You can read it (possibly an older version of the man pages?) online here: https://linux.die.net/man/8/picocom.
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>R</kbd> = receive a file over serial *from* the remote device.
    1. Same requirement as the send command, described just above.
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>V</kbd> = show port settings, such as baud rate, flow control, parity, databits, stop bits, etc.


<a id="transferring-files-over-serial"></a>
# Transferring files over serial


<a id="background-1"></a>
## Background

Transfering files over serial can be done via ZMODEM. See: [Unix & Linux: How to get file to a host when all you have is a serial console?](https://unix.stackexchange.com/q/312/114401). The preferred technique would be to use the ZMODEM error-checking protocol (see here: [Wikipedia: ZMODEM](https://en.wikipedia.org/wiki/ZMODEM)) via [`lrzsz`](https://www.ohse.de/uwe/software/lrzsz.html), which provides the `rx`, `rb`, and `rz` modem file receive functions (and [is available on Buildroot too](https://github.com/buildroot/buildroot/tree/master/package/lrzsz)), and the `sx`, `sb`, and `sz` modem file receive functions. 

1. Or, you could use the [kermit](https://en.wikipedia.org/wiki/Kermit_(protocol)) protocol in case XMODEM (`rx` and `sx`), YMODEM (`rb` and `sb`), and ZMODEM (`rz` and `sz`) are not available. 
1. However, if neither `lrzsz` nor `kermit` is available, then you can encode binary files into text using `uuencode` (I can't get this to work at all for me) or `base64` (preferred), and then just manually send them over using `picocom` and `cat` or `picocom` and `ascii-xfr`, [as mostly explained by this answer here](https://unix.stackexchange.com/a/296752/114401). 
1. To install `lrzsz` and `ascii-xfr` on Linux Ubuntu, do this:
    ```bash
    sudo apt update
    # NB: installing `minicom` **alone** includes both `minicom` **and** `lrzsz`!
    # (and `minicom` includes the `ascii-xfr` executable too).
    sudo apt install minicom 

    # Or, to install just `lrzsz`. This gives you access to the XMODEM, YMODEM,
    # and ZMODEM protocol executables such as `rz` and `sz`, used to send and
    # receive files. 
    sudo apt install lrzsz
    ```
1. To learn about the ingenuity of the ZMODEM auto-resend and error-checking protocol, see here: https://en.wikipedia.org/wiki/ZMODEM:
> ZMODEM replaced the packet number with the actual location in the file, indicated by a 32-bit number. This allowed it to send NAK messages that re-wound the transfer to the point of failure, regardless of how long the file might be. This same feature was also used to re-start transfers if they failed or were deliberately interrupted. In this case, the receiver would look to see how much data had been previously received and then send a NAK with that location, automatically triggering the sender to start from that point.

