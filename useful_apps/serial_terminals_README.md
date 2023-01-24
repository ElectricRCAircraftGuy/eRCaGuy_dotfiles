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
1. [Scripting the sending and receiving of commands over serial](#scripting-the-sending-and-receiving-of-commands-over-serial)
1. [Transferring files over serial](#transferring-files-over-serial)
    1. [Background](#background-1)
    1. [Scenario 1: computer to bare-metal or RTOS-based microcontroller](#scenario-1-computer-to-bare-metal-or-rtos-based-microcontroller)
    1. [Scenario 2: Linux to Linux as plain text withOUT ZMODEM](#scenario-2-linux-to-linux-as-plain-text-without-zmodem)
    1. [Scenario 3: Linux to Linux WITH ZMODEM](#scenario-3-linux-to-linux-with-zmodem)
    1. [References](#references)

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
    1. Manual pages:
        1. `man` format: [picocom.1](https://github.com/npat-efault/picocom/blob/master/picocom.1)
        1. HTML: [picocom.1.html](https://github.com/npat-efault/picocom/blob/master/picocom.1.html)
        1. Markdown [my preference]: [picocom.1.md](https://github.com/npat-efault/picocom/blob/master/picocom.1.md)
        1. PDF: [picocom.1.pdf](https://github.com/npat-efault/picocom/blob/master/picocom.1.pdf)


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
    # --------------------------------------------------------------------------
    # 1. Download and build the program
    # --------------------------------------------------------------------------

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
    # See just the version line from the help menu
    picocom -h | head -n 1

    # For more-detailed usage, see the "General Usage" section I wrote below.
    
    # View the "man" (manual) pages manually like this:
    man ./picocom.1
    # See just the version line from the man pages
    man picocom | tail -n 1

    # --------------------------------------------------------------------------
    # 2. Install the program by adding symlinks to it to your PATH variable
    # --------------------------------------------------------------------------

    # create the ~/bin dir if it doesn't already exist
    mkdir -p ~/bin
    # add a symlink to the executable
    ln -si "$PWD/picocom" ~/bin

    # re-source your ~/.profile file; don't know what "source" means?
    # Read my answer here: https://stackoverflow.com/a/62626515/4561887
    . ~/.profile

    # `picocom` will now be in your PATH since Linux Ubuntu's default
    # ~/.profile file adds it to the path like this:
    #
    #       # set PATH so it includes user's private bin if it exists
    #       if [ -d "$HOME/bin" ] ; then
    #           PATH="$HOME/bin:$PATH"
    #       fi

    # --------------------------------------------------------------------------
    # 3. Install the man (manual) pages for the program
    # [keywords: how to install man pages; installing man pages installation]
    # --------------------------------------------------------------------------

    # add a symlink to the man page so you can do `man picocom`
    # See: https://askubuntu.com/a/244810/327339
    sudo mkdir -p /usr/local/share/man/man1
    sudo ln -si "$PWD/picocom.1" /usr/local/share/man/man1/

    # Update `man`'s internal database
    sudo mandb

    # Verify the new manpage, with the new `picocom` version at the very bottom,
    # is now properly installed and working!
    man picocom

    # The version numbers here should now match:
    # 1. See just the version line from the help menu
    picocom -h | head -n 1
    # 2. See just the version line from the man pages
    man picocom | tail -n 1
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
    1. See also `man picocom` and search for the section titled "SENDING AND RECEIVING FILES". You can read the latest version of the man pages online here: https://github.com/npat-efault/picocom/blob/master/picocom.1.md.
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>R</kbd> = receive a file over serial *from* the remote device.
    1. Same requirement as the send command, described just above.
1. <kbd>Ctrl</kbd> + <kbd>A</kbd>, <kbd>Ctrl</kbd> + <kbd>V</kbd> = show port settings, such as baud rate, flow control, parity, databits, stop bits, etc.


<a id="scripting-the-sending-and-receiving-of-commands-over-serial"></a>
# Scripting the sending and receiving of commands over serial

See here for starters: [How to write automated scripts for `picocom`](https://github.com/npat-efault/picocom/issues/76#issuecomment-354186674). See this link and more info. in my "References" section below too.

WIP:

ATTEMPT 2: WORKS! (but ONLY if picocom is open in another terminal 1st) (update: it just works now since I added the sleep 0.1!)
This is a pretty complicated synchronization problem. You need to: 
start listening, wait a moment, send the cmd, wait a moment, stop listening, block on sending to the pipe, have the first thread read from the pipe after the 2nd thread blocks on writing to it. Done.
```bash
#!/usr/bin/env bash

# some test commands to automatically send over serial (and receive the replies)
cmds_array=()
cmds_array+=("ls /sys")
cmds_array+=("uname")
cmds_array+=("pwd")

response_array=()

# First, configure, open, and leave open the serial port
picocom --noreset --exit --quiet --baud 115200 /dev/ttyUSB0

if [ ! -p "/tmp/serial_pipe" ]; then
    mkfifo /tmp/serial_pipe
fi

read_serial_response_and_pipe_it_back() {
    # see my new answer here: https://unix.stackexchange.com/a/720853/114401
    response_str="$(timeout 0.5 cat /dev/ttyUSB0)"
    printf "%s" "$response_str"
    printf "%s" "$response_str" > /tmp/serial_pipe
}

# send all commands and receive all their responses
for i in "${!cmds_array[@]}"; do
    read_serial_response_and_pipe_it_back &
    sleep 0.1  # ensure the cmd above has time to start reading before we continue

    cmd="${cmds_array["$i"]}"
    printf "%s\n" "$cmd" > /dev/ttyUSB0
    # printf "%s\n" "ls /" > /dev/ttyUSB0
    sleep 0.5

    response_array+=("$(cat /tmp/serial_pipe)")
done

# print all responses
for response_str in "${response_array[@]}"; do
    printf "==start==\n%s\n==end==\n\n" "$response_str"
done
```





ATTEMPT 1:
```bash
#!/usr/bin/env bash

# some test commands to automatically send over serial (and receive the replies)
cmds_array=()
cmds_array+=("ls /sys")
cmds_array+=("uname")
cmds_array+=("pwd")

response_array=()

# First, configure, open, and leave open the serial port
picocom --noreset --exit --quiet --baud 115200 /dev/ttyUSB0
# make a pipe we will need below for some basic inter-process communication
# (IPC)
if [ ! -p "/tmp/serial_pipe" ]; then
    mkfifo /tmp/serial_pipe
fi

# send all commands and receive all their responses
for i in "${!cmds_array[@]}"; do
    # 1. spawn a background process to start listening for the serial response, 
    # passing the response to a pipe to be read by this process
    cat /dev/ttyUSB0 > /tmp/serial_pipe &
    spawned_pid="$!"

    # 2. send the cmd; the response will get received by the spawned process
    # above and then piped back to this process
    cmd="${cmds_array["$i"]}"
    printf "%s\n" "$cmd" > /dev/ttyUSB0

    # 3. delay a bit to let the spawned process receive the command, then read
    # from the pipe and kill the spawned process above
    sleep 0.5
    response_array+="$(cat "/tmp/serial_pipe")"
    kill "$spawned_pid"
done

# print all responses
for response_str in "${response_array[@]}"; do
    printf "=====\n%s\n=====\n" "$response_str"
done
```


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


<a id="scenario-1-computer-to-bare-metal-or-rtos-based-microcontroller"></a>
## Scenario 1: computer to bare-metal or RTOS-based microcontroller

**Transferring a file over serial from a Linux or other computer to a _custom bare-metal or RTOS-based microcontroller_ such as Arduino or STM32:**

In other words: the target serial device does NOT have access to the Linux tools such as `cat` or `rz` or `sz` which we will use in the other scenarios below.

You'll have to do this all custom. Modelling your approach after how [ZMODEM](https://en.wikipedia.org/wiki/ZMODEM) (see quote from this link just above) works would be a great idea. You'll have to write a custom application on both the remote serial device *as well as* on your local host machine. 

1. Write a Python, C, or C++ program to send serial data from your host computer to the serial device. 
1. Start out by sending a CLI command such as `send_file` to the remote serial device. Have this make it switch from an "ASCII CLI-interface" mode to a "binary file receive" mode. 
1. The remote device will then send a NAK (negative acknowledgement) to the host machine specifying that it needs the host machine to begin sending the file at byte 0. 
    1. The NAK will contain a `uint32_t i_file` index which specifies the index location in the file which it would like to receive next, and at which point the sender (host machine) should start sending.
    1. Make this a binary packet with header, payload, trailer. In C++, that might look like this:
        ```cpp
        // NB: the NAK packet is a **fixed size** packet.

        // Magic numbers to mark the start and end of a NAK packet.
        constexpr uint32_t PACKET_NAK_START = 1234567890;
        constexpr uint32_t PACKET_NAK_END = 987654321;

        #define FILENAME_MAX_LEN 20

        struct __attribute__ ((__packed__)) HeaderNak
        {
            /// A unique, random 4-byte number to indicate the start of this
            /// type of packet
            const uint32_t packet_start = PACKET_NAK_START;
            /// A NAK packet counter to help detect missed packets
            uint32_t packet_counter = 0;
            /// A timestamp of the time at which this was sent from the sender
            uint64_t timestamp_ns;
        };

        struct __attribute__ ((__packed__)) PayloadNak
        {
            /// Name of the file requested
            char filename[FILENAME_MAX_LEN];
            /// The file index at which point the device would like the sender
            /// to begin sending the file data again
            uint32_t i_file;
        };

        struct __attribute__ ((__packed__)) TrailerNak
        {
            /// Some sort of packet integrity checksum, such as an XOR, CRC,
            /// MD5, SHA256, etc, over the header and payload portions of the
            /// packet.
            /// - Make this a CMAC or HMAC, which is basically just
            /// a SHA256 hash over the whole packet plus a pre-shared key, 
            /// if you'd like to also ensure packet authenticity to ensure the
            /// packet came from a trusted source.
            uint32_t checksum;
            /// A unique, random 4-byte number to indicate the end of this 
            /// type of packet.
            const uint32_t packet_end = PACKET_NAK_END;
        };

        struct __attribute__ ((__packed__)) PacketNak
        {
            HeaderNak header;
            PayloadNak payload;
            TrailerNak trailer;
        };
        ```
1. The NAK packet will be identified and parsed by the magic starting number, known size, magic ending number, and checksum. 
1. The host machine will then begin sending over the file to the remote serial device using a packet structure which might look like this in C++:
    ```cpp
    // NB: the FILE data packet is a **variable size** packet, with a payload of
    // perhaps 1 to 512 bytes or so. This means that the number of bytes
    // actually serialized and sent over the wire can vary, but the 
    // `sizeof(PacketFile)` is fixed and known at compile-time. 

    constexpr uint16_t MAX_NUM_BYTES = 512;
        
    // Magic numbers to mark the start and end of a FILE contents packet.
    constexpr uint32_t PACKET_FILE_START = 5555567890;
    constexpr uint32_t PACKET_FILE_END = 987655555;

    struct __attribute__ ((__packed__)) HeaderFile
    {
        /// A unique, random 4-byte number to indicate the start of this 
        /// type of packet
        const uint32_t packet_start = PACKET_FILE_START;
        /// A File packet counter to help detect missed packets
        uint32_t packet_counter = 0;
        /// A timestamp of the time at which this was sent from the sender
        uint64_t timestamp_ns;
    };

    struct __attribute__ ((__packed__)) PayloadFile
    {
        /// Name of the file being sent
        char filename[FILENAME_MAX_LEN];
        /// The total number of bytes in this file being sent.
        uint32_t file_size;
        /// The file index at which point the bytes being sent in this packet
        /// begin.
        uint32_t i_file;
        /// The number of bytes (actually used and sent over serial) in the data
        /// array below, for this packet.
        uint16_t num_bytes;
        /// An array of the file bytes being sent over by this packet. 
        /// NB: this array must be sized to hold up to `MAX_NUM_BYTES` for 
        /// processing on each end, even though only **num_bytes** of it 
        /// will actually be serialized and sent over the serial wire!
        uint8_t bytes[MAX_NUM_BYTES];
    };

    struct __attribute__ ((__packed__)) TrailerFile
    {
        /// Some sort of packet integrity checksum, such as an XOR, CRC,
        /// MD5, SHA256, etc, over the header and payload portions of the
        /// packet.
        /// - Make this a CMAC or HMAC, which is basically just
        /// a SHA256 hash over the whole packet plus a pre-shared key, 
        /// if you'd like to also ensure packet authenticity to ensure the
        /// packet came from a trusted source.
        uint32_t checksum;
        /// A unique, random 4-byte number to indicate the end of this 
        /// type of packet.
        const uint32_t packet_end = PACKET_FILE_END;
    };

    struct __attribute__ ((__packed__)) PacketFile
    {
        HeaderFile header;
        PayloadFile payload;
        TrailerFile trailer;
    };
    ```
1. You may need to make the sender wait a bit after sending each file packet. 
    1. Depending on the baud rate and processing speed of the recipient (ie: if the baud rate is too high and/or the processing speed of the recipient too slow), you may need to make the sender delay a small amount after sending each file chunk packet, to give the receiver time to process the new packet, including computing the hash, ensuring the packet is valid, etc.
1. Since each packet contains the `file_size`, the `i_file` index at which point in the file this data begins, and the `num_bytes` of the file sent in this packet, the remote serial device receiving the file can easily know when the while file has been received. 
    1. If it ever detects a corrupted or missing packet, it will send a NAK packet to the sender to indicate where it needs the sender to begin sending again, and then it will pick up from there, reconstructing the file with the newly-received data.


That's the gist of it! Go make it happen. :)

Packetizing and error-checking serial data is actually pretty fun, I think. It's one of the more-enjoyable aspects of embedded software, to me. I love using sophisticated techniques like that described above to send complex data over primitive interfaces. I enjoy that challenge. 


<a id="scenario-2-linux-to-linux-as-plain-text-without-zmodem"></a>
## Scenario 2: Linux to Linux as plain text withOUT ZMODEM

**Transferring a file over serial from a Linux computer to a Linux computer where the destination computer DOES have `cat` but does NOT have access to the `sz` and `rz` ZMODEM protocol executables:**

If you don't have access to a good binary file transfer program like ZMODEM's `sz` and `rz` programs, then you can either:
1. Write your own, following my layout in Scenario 1 above (hard), OR
1. Just send the file over as encoded text using common Linux tools (easy).

I'll cover how to do the latter: 

**How to send a file over serial as encoded text using common Linux tools:**

1. On your local machine, install [picocom](https://github.com/npat-efault/picocom). Follow my instructions above. In short:
    ```bash
    # cd to wherever you'd like to download the program
    cd ~/GS/dev
    git clone https://github.com/npat-efault/picocom.git
    cd picocom
    make  

    # create the ~/bin dir if it doesn't already exist
    mkdir -p ~/bin
    # add a symlink to the executable
    ln -si "$PWD/picocom" ~/bin
    # add a symlink to the man page so you can do `man picocom`
    sudo ln -si "$PWD/picocom.1" /usr/local/share/man/man1

    # re-source your ~/.profile file; don't know what "source" means?
    # Read my answer here: https://stackoverflow.com/a/62626515/4561887
    . ~/.profile

    # `picocom` will now be in your PATH since Linux Ubuntu's default
    # ~/.profile file adds it to the path like this:
    #
    #       # set PATH so it includes user's private bin if it exists
    #       if [ -d "$HOME/bin" ] ; then
    #           PATH="$HOME/bin:$PATH"
    #       fi

    # Try running `picocom --help`. If it doesn't work and show the version you
    # just installed at the top of the help menu, log out and log back in to
    # finish adding ~/bin to your PATH, and then try `picocom --help` again.
    ```
1. 

WIP

```bash
# prepare file on sending side
split
# encode
base64

# connect on picocom
cat > file  # on destination
pv # the file over to see a progress bar; OR:
cat file > /dev/ttyUSB0  # from sender

# Ctrl + C the receiver
sha256sum # verify it


# decode
# recombine
# done!

# Improvements:
# 1. increase baud rate until you start to see errors
#  For me, on a device capable of 3 Mbaud, the highest I could go without errors was the one just above 115200
# If using an error-checking scheme such as Scenario 1 or Scenario 3, you could probably go much higher baud rate.
# 2. cross-compile lrzsz using Buildroot, send it over, then move to Scenario 3 for bigger file (ex: 80 MB)
```



<a id="scenario-3-linux-to-linux-with-zmodem"></a>
## Scenario 3: Linux to Linux WITH ZMODEM 

**Transferring a file over serial from a Linux computer to a Linux computer where the destination computer DOES have `cat`, AND the `sz` and `rz` ZMODEM protocol executables:**

WIP


<a id="references"></a>
## References

I absolutely could not have solved Scenario 2 nor Scenario 3 above without help from these answers here. I had never even heard of ZMODEM, nor did I know `cat` could be used to receive data over `stdin` like this, prior to reading them. These answers were invaluable to me.

1. \*\*\*\*\* [Unix & Linux: How to get file to a host when all you have is a serial console?--by @J. M. Becker](https://unix.stackexchange.com/a/296752/114401)
1. \*\*\*\*\* [Unix & Linux: How to get file to a host when all you have is a serial console?--by @Warren Young](https://unix.stackexchange.com/a/431/114401)
1. The content in this _question itself_ was also very useful: [Unix & Linux: How do I use a serial port on Linux like a pipe or netcat?](https://unix.stackexchange.com/q/96718/114401)
1. [Unix & Linux: What is the complementary command to 'rx' for xmodem transfer?](https://unix.stackexchange.com/a/186723/114401) - taught me about the existence of XMODEM (the first), YMODEM (an improvement), and ZMODEM (the best!)
1. Binary transfer script for minicom, as a GitHub gist: https://gist.github.com/cstrahan/5796653 - where I first learned of the `pv` command to track file transfer speed and progress (percent complete). Ex: `pv -B 10K file_to_send.txt > /dev/ttyUSB0`
1. [Unix & Linux: How do I use a serial port on Linux like a pipe or netcat?](https://unix.stackexchange.com/q/96718/114401) - **excellent** content in the question itself, including how to create and use a local pipe (an inter-process communication (IPC) mechanism) via `mkfifo`, which is really cool.
    1. I've added an answer here too: https://unix.stackexchange.com/a/720397/114401
1. [SuperUser: What is the fastest and most reliable way to split a 50GB binary file into chunks of 5GB or less, and then reassemble it later?](https://superuser.com/a/160367/425838) - how to `split` large files, then recombine them using `cat`.
1. [How to write automated scripts for `picocom`](https://github.com/npat-efault/picocom/issues/76#issuecomment-354186674) - very useful! Use `picocom -rX -b 115200 /dev/ttyUSB0` or `picocom --noreset --exit --baud 115200 /dev/ttyUSB0` (same thing) to simply configure the serial port, in place of `stty`, then exit, leaving the serial port open, configured, and connected so you can `cat` or otherwise manually write to or read from it.
1. [Difference between "cat" and "cat <"](https://unix.stackexchange.com/a/258932/114401) - difference between `cat somefile` and `cat < somefile`
1. https://linux.die.net/man/1/rz - `man rz`
1. lrzsz: free x/y/zmodem implementation official page: https://www.ohse.de/uwe/software/lrzsz.html
1. lrzsz package in Buildroot: https://github.com/buildroot/buildroot/tree/master/package/lrzsz

