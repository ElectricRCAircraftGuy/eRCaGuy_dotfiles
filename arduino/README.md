**This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles**


# Arduino Readme


## See also
1. [serial_terminals_README.md](../useful_apps/serial_terminals_README.md)


## Download & Install:

Download the Arduino IDE here: https://www.arduino.cc/en/Main/Software

More recent versions of the IDE include a Linux Install script, `install.sh`, and uninstall script, `uninstall.sh`. Use them. The alternative is fine too: just use the arduino desktop file included in this project to create shortcuts, as the executable is ready to use simply by decompressing the Arduino download.

FOR OFFICIAL HELP FROM ARDUINO ON USING IT ON LINUX, read this article here: https://www.arduino.cc/en/guide/linux.


## 1. Problem uploading to board / need to add user to dialout group [<== DO THIS!]:

**If you get this error when uploading:**

```
avrdude: ser_open(): can't open device "/dev/ttyUSB0": Permission denied
Problem uploading to board.  See http://www.arduino.cc/en/Guide/Troubleshooting#upload for suggestions.
```

**Then do the following:**

1. First, see which group has permissions on this device. Be sure to replace "ttyUSB0" with whatever ttyUSB number you see in the error above.

    ```bash
    ls -alF /dev/ttyUSB0
    ```

    You might see something like this as an output:

    ```bash
    $ ls -alF /dev/ttyUSB0
    crw-rw---- 1 root dialout 188, 0 Dec 19 10:27 /dev/ttyUSB0
    ```

    This means that this device is owned by the "root" user, which has read-write (rw) privileges and is part of the "dialout" group, which also has rw privileges. So, we just need to add our user to this group!

2. Add your user to the "dialout" group:
    ```bash
    sudo usermod -a -G dialout $USERNAME
    ```

3. Now, log out entirely from Ubuntu, then log back in. You will now have the privileges of this group! Let's verify that:
    ```bash
    groups $USERNAME
    ```

    This shows which groups your username is a part of. You should now see `dialout` as one of the groups printed. If so, uploading to boards should work now.


## 2. USBasp: add udev rule to allow the "dialout" group to use this programmer

**References:**

1. Good, full instructions: https://andreasrohner.at/posts/Electronics/How-to-fix-device-permissions-for-the-USBasp-programmer/
2. Good info about restarting udev to refresh the rules we just added: 
    1. https://askubuntu.com/questions/1048870/permission-denied-to-non-root-user-for-usb-device/1187646#1187646
    2. [My own ans!] https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot/567996#567996
3. Downloads for the USBasp programmer (including the latest firmware and a sample "usbasp.2011-05-28/bin/linux-nonroot/99-USBasp.rules" udev .rules file which doesn't quite work for me on Ubuntu): https://www.fischl.de/usbasp/

**My instructions:**

1. The USBasp comes with its own udev rules file in `eRCaGuy_dotfiles/arduino/USBasp_programmer/usbasp.2011-05-28/bin/linux-nonroot/99-USBasp.rules`, but IT DIDN'T WORK FOR ME! Let's use a slightly modified rules file instead, stored in `eRCaGuy_dotfiles/etc/udev/rules.d/99-USBasp.rules`, that I created essentially per the instructions in link 1 just above. 

    Copy this rules file to your "/etc/udev/rules.d" directory and be done!
    ```bash
    sudo cp -i "eRCaGuy_dotfiles/etc/udev/rules.d/99-USBasp.rules" /etc/udev/rules.d
    ```

1. Refresh udev (as described per links 2.1 and 2.2 above):
    ```bash
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    ```

1. Now unplug and plug back in the USBasp programmer!

    **SO LONG AS YOU ALREADY ADDED YOURSELF TO THE "dialout" group as described above**, you should now be able to burn bootloaders or program chips from the Arduino IDE with this programmer! Go burn a bootloader to make sure it works.


## 3. Chinese CH340/CH341 USB to serial adapter (UART) not working on Linux...

...due to the `brltty` (Braille serial device) service taking it over.

_Last tested in Ubuntu 22.04 LTS with Arduino IDE 2.3.6._

#### 1. Problem

You plug in a Chinese CH340/CH341 USB to serial adapter (UART) and it does not show up as a serial port in the Arduino IDE, or you get an error like this when trying to upload to a board, because the Arduino IDE cannot find the serial port to use and you have accidentally selected the wrong port:

```
avrdude: stk500_recv(): programmer is not responding
avrdude: stk500_getsync() attempt 1 of 10: not in sync: resp=0x00
```

#### 2. Diagnosis

1. The CH340/CH341 UART doesn't show up as a `/dev/ttyUSB*` device:
    Run this: 
    ```bash
    ls /dev/ttyUSB*
    ```

    The output should be `/dev/ttyUSB0` or similar, but you see this instead:
    ```
    $ ls /dev/ttyUSB*
    ls: cannot access '/dev/ttyUSB*': No such file or directory
    ``` 

1. You *can* find the device with `lsusb`, however:
    ```bash
    lsusb | grep -i CH340
    ```

    The output shows a line like this, indicating that the CH340/CH341 USB to serial adapter *is* in fact connected and "working", even though it is not showing up as a serial port you can use:
    ```
    Bus 003 Device 009: ID 1a86:7523 QinHeng Electronics CH340 serial converter
    ```

1. The device gets taken over by the `brltty` service, as shown by `dmesg -w` when you unplug it and plug it back in: 
    Run this: 
    ```bash
    sudo dmesg -w
    ```

    You see output like this when you unplug it:
    ```
    [386262.432251] usb 3-1.2: USB disconnect, device number 78
    ```

    ...and like this when you plug it back in. Notice the parts I marked with `<=== 1` where the CH341 UART got connected to `/dev/ttyUSB0`, and the parts I marked with `<=== 2` where it was then disconnected and taken over by `brltty`:
    ```
    [386228.874324] usb 3-1.2: new full-speed USB device number 78 using xhci_hcd
    [386229.015489] usb 3-1.2: New USB device found, idVendor=1a86, idProduct=7523, bcdDevice= 2.54
    [386229.015505] usb 3-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
    [386229.015509] usb 3-1.2: Product: USB2.0-Serial
    [386229.024959] ch341 3-1.2:1.0: ch341-uart converter detected
    [386229.026487] usb 3-1.2: ch341-uart converter now attached to ttyUSB0                      <=== 1
    [386229.555197] usb 3-1.2: usbfs: interface 0 claimed by ch341 while 'brltty' sets config #1 <=== 2
    [386229.556470] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0       <=== 1
    [386229.556518] ch341 3-1.2:1.0: device disconnected                                         <=== 2
    [386229.589971] input: BRLTTY 6.4 Linux Screen Driver Keyboard as /devices/virtual/input/input64 <=== 2
    [386229.592985] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1 <=== 2
    [386234.592285] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1 <=== 2
    [386239.592687] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1 <=== 2
    ```

#### 3. Solution

These attempted solution steps are in the order of *least intrusive* first, to *most intrusive* last:

1. **Edit the `brltty` udev rules file to ignore the CH340/CH341 device.**

    First, find the rules file:
    ```bash
    locate *brltty*.rules
    ```

    You should see something like this, which is the path to the .rules file:
    ```
    /usr/lib/udev/rules.d/85-brltty.rules
    ```

    Copy the file to the `/etc/udev/rules.d` directory so that an overriding copy of it can be edited without affecting the original file, which is managed by the package manager:
    ```bash
    sudo cp -i /usr/lib/udev/rules.d/85-brltty.rules /etc/udev/rules.d/85-brltty.rules
    ```

    Now, edit this new file with `sudo`. Here, `subl` is the Sublime Text editor, but you can use any text editor you like, such as `nano` or `vim`:
    ```bash
    sudo subl /etc/udev/rules.d/85-brltty.rules
    ```

    Search for the line that contains `1a86:7523` (the ID for the CH340/CH341, as shown in the output of `lsusb | grep -i CH340`) and comment it out by adding a `#` at the beginning of the line. Save and close the file.

    Then, reload the udev rules:
    ```bash
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    ```

    Now, unplug the CH340/CH341 USB to serial adapter and plug it back in.

    Run `ls/dev/ttyUSB*` again to see if it shows up now:
    ```bash
    ls /dev/ttyUSB*
    ```

    If it does, then you are done with the "Soluton" section! Skip down to the "Verify the fix" section below to verify that it works. You can now open the Arduino IDE and select the serial port under Tools --> Port, then upload code to your board. 

    This "fix", however, did *not* work for me, so I continued on to the next step below.

1. **Disable the `brltty` braille device service**: This service is taking over the CH340/CH341 UART device, so we need to stop it and disable it from starting up again.

    ```bash
    # Stop the brltty service for this session:
    sudo systemctl stop brltty
    # Disable it from starting up again on boot:
    sudo systemctl disable brltty
    # Check the status of the brltty service to ensure it is stopped and disabled: 
    sudo systemctl status brltty
    ```

    If it is disabled, you'll see this output from the status command. Notice the `; disabled; ` part:
    ```
    ○ brltty.service - Braille Device Support
        Loaded: loaded (/lib/systemd/system/brltty.service; disabled; vendor preset: enabled)
        Active: inactive (dead)
        Docs: man:brltty(1)
                http://brltty.com/
    ```

    This *did* work for me (meaning: the "Verify the fix" section below then passed for me), so I could stop wth the "Soluton" section here. 

1. If you still have problems, just uninstall `brltty` entirely:
    ```bash
    sudo apt remove brltty
    ```

    This will remove the `brltty` service and all its associated files, which should allow the CH340/CH341 UART to work normally again.

#### 4. Verify the fix

1. Plug in the CH340/CH341 USB to serial adapter again and check if it shows up as a `/dev/ttyUSB*` device:

    ```bash
    ls /dev/ttyUSB*
    ```

    Exmple output:
    ```
    /dev/ttyUSB0
    ```

1. You can also check `dmesg -w`: 
    ```bash
    sudo dmesg -w
    ```

    Now unplug the device and plug it back in and you'll see the following dmesg output. Notice where I marked with a `<===` that it got attached to `/dev/ttyUSB0`: 
    ```
    [ 1474.421832] hub 3-1:1.0: USB hub found
    [ 1474.422171] hub 3-1:1.0: 5 ports detected
    [ 1475.129895] usb 3-1.2: new full-speed USB device number 18 using xhci_hcd
    [ 1475.271960] usb 3-1.2: New USB device found, idVendor=1a86, idProduct=7523, bcdDevice= 2.54
    [ 1475.271974] usb 3-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
    [ 1475.271978] usb 3-1.2: Product: USB2.0-Serial
    [ 1475.280746] ch341 3-1.2:1.0: ch341-uart converter detected
    [ 1475.281817] usb 3-1.2: ch341-uart converter now attached to ttyUSB0        <===
    [ 1475.346698] usb 3-1.5: new high-speed USB device number 19 using xhci_hcd
    [ 1475.426445] usb 3-1.5: New USB device found, idVendor=2109, idProduct=8818, bcdDevice= 0.01
    [ 1475.426448] usb 3-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
    [ 1475.426449] usb 3-1.5: Product: USB Billboard Device   
    [ 1475.426450] usb 3-1.5: Manufacturer: VIA Labs, Inc.         
    [ 1475.426451] usb 3-1.5: SerialNumber: 0000000000000001
    ```

1. Finally, open the Arduino IDE and ensure it shows up in the list of serial ports in the menu under Tools --> Port after selecting an Arduino board. 

    Upload code to the board via this port.

#### 5. References

1. Chat with the Grok AI: [non-public link for my own reference]: https://grok.com/chat/a785ffbb-f8a7-4555-84ad-5efeac573264
1. [Google search for "linux ch340 uart not working"](https://www.google.com/search?q=linux+ch340+uart+not+working&oq=linux+ch340+uart+not+working&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTEwNTQ0ajBqN6gCCLACAQ&sourceid=chrome&ie=UTF-8)
1. [Google search for "linux arduino ch340 brltty"](https://www.google.com/search?q=linux+arduino+ch340+brltty&oq=linux+arduino+ch340+brltty&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDUzOTBqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8)
1. https://forum.arduino.cc/t/port-not-showing-up-ch340-in-ubuntu-solution/1176862
1. https://github.com/arduino/help-center-content/issues/155
1. \*\*\*\*\* [Unix Linux Stack Exchange: Unable to use USB dongle based on USB-serial converter chip](https://unix.stackexchange.com/a/680547/114401)
    1. [My comment below it, because it did not work for me](https://unix.stackexchange.com/questions/670636/unable-to-use-usb-dongle-based-on-usb-serial-converter-chip/680547#comment1533955_680547)
1. https://bbs.archlinux.org/viewtopic.php?id=269975
1. https://stackoverflow.com/q/70123431/4561887


#### 6. See also

1. Where I first posted this in my [eRCaGuy_dotfiles](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles) repo: [arduino/README.md](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/arduino).
1. My corresponding answer on Unix & Linux Stack Exchange: [Unable to use USB dongle based on USB-serial converter chip](https://unix.stackexchange.com/q/670636/114401)


---

DONE!
