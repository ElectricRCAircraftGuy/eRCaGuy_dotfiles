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

    avrdude: ser_open(): can't open device "/dev/ttyUSB0": Permission denied
    Problem uploading to board.  See http://www.arduino.cc/en/Guide/Troubleshooting#upload for suggestions.

**Then do the following:**

1. First, see which group has permissions on this device. Be sure to replace "ttyUSB0" with whatever ttyUSB number you see in the error above.

        ls -alF /dev/ttyUSB0

    You might see something like this as an output:

        $ ls -alF /dev/ttyUSB0
        crw-rw---- 1 root dialout 188, 0 Dec 19 10:27 /dev/ttyUSB0

    This means that this device is owned by the "root" user, which has read-write (rw) privileges and is part of the "dialout" group, which also has rw privileges. So, we just need to add our user to this group!

2. Add your user to the "dialout" group:

        sudo usermod -a -G dialout $USERNAME

3. Now, log out entirely from Ubuntu, then log back in. You will now have the privileges of this group! Let's verify that:

        groups $USERNAME

    This shows which groups your username is a part of. You should now see "dialout" as one of the groups printed. If so, uploading to boards should work now.


## 2. USBasp: add udev rule to allow the "dialout" group to use this programmer

**References:**

1. Good, full instructions: https://andreasrohner.at/posts/Electronics/How-to-fix-device-permissions-for-the-USBasp-programmer/
2. Good info about restarting udev to refresh the rules we just added: 
    1. https://askubuntu.com/questions/1048870/permission-denied-to-non-root-user-for-usb-device/1187646#1187646
    2. [My own ans!] https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot/567996#567996
3. Downloads for the USBasp programmer (including the latest firmware and a sample "usbasp.2011-05-28/bin/linux-nonroot/99-USBasp.rules" udev .rules file which doesn't quite work for me on Ubuntu): https://www.fischl.de/usbasp/

**My instructions:**

1. The USBasp comes with its own udev rules file in "eRCaGuy_dotfiles/arduino/USBasp_programmer/usbasp.2011-05-28/bin/linux-nonroot/99-USBasp.rules", but IT DIDN'T WORK FOR ME! Let's use a slightly modified rules file instead, stored in "eRCaGuy_dotfiles/etc/udev/rules.d/99-USBasp.rules", that I created essentially per the instructions in link 1 just above. 

Copy this rules file to your "/etc/udev/rules.d" directory and be done!

        sudo cp -i "eRCaGuy_dotfiles/etc/udev/rules.d/99-USBasp.rules" /etc/udev/rules.d

2. Refresh udev (as described per links 2.1 and 2.2 above):

        sudo udevadm control --reload-rules
        sudo udevadm trigger

3. Now unplug and plug back in the USBasp programmer!

    **SO LONG AS YOU ALREADY ADDED YOURSELF TO THE "dialout" group as described above**, you should now be able to burn bootloaders or program chips from the Arduino IDE with this programmer! Go burn a bootloader to make sure it works.


DONE!



