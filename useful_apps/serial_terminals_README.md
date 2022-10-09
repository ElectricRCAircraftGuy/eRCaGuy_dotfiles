This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [See also](#see-also)
1. [Serial terminal programs](#serial-terminal-programs)
1. [`picocom`](#picocom)

<!-- /MarkdownTOC -->
</details>


<a id="see-also"></a>
# See also

1. [eRCaGuy_dotfiles/useful_apps/README.md](README.md)
1. [../git & Linux cmds, help, tips & tricks - Gabriel.txt](<../git & Linux cmds, help, tips & tricks - Gabriel.txt>) - and search the file for "serial", "Serial terminal tools", "USB, serial, devices, etc.".


<a id="serial-terminal-programs"></a>
# Serial terminal programs

1. picocom [my favorite]
    1. See my installation instructions & notes: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/useful_apps#picocom
    1. Source code: https://github.com/npat-efault/picocom
1. minicom
1. Arduino Serial Monitor and Serial Plotter
1. [eRCaGuy_PyTerm](https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm) - a datalogging serial terminal/console program which I wrote, written in Python.
    1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_PyTerm
    1. Can be used in place of `minicom`, `picocom`, or the Arduino Serial Monitor.
    1. This program works fine, but for general logging, you might consider `picocom`, however, instead. See its logging command just above. 


<a id="picocom"></a>
# `picocom`


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

