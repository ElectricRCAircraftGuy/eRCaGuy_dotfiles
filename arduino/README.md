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

//////////`````````````````//////////////////
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


## 3. Chinese CH340/CH341 USB to serial adapter (UART) not working on Linux

Problem: .....

```bash
$ ls /dev/ttyUSB*
ls: cannot access '/dev/ttyUSB*': No such file or directory

$ lsusb | grep -i CH340
Bus 003 Device 075: ID 1a86:7523 QinHeng Electronics CH340 serial converter

sudo dmesg -w

# when plugging it in: 
[386228.874324] usb 3-1.2: new full-speed USB device number 78 using xhci_hcd
[386229.015489] usb 3-1.2: New USB device found, idVendor=1a86, idProduct=7523, bcdDevice= 2.54
[386229.015505] usb 3-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[386229.015509] usb 3-1.2: Product: USB2.0-Serial
[386229.024959] ch341 3-1.2:1.0: ch341-uart converter detected
[386229.026487] usb 3-1.2: ch341-uart converter now attached to ttyUSB0
[386229.555197] usb 3-1.2: usbfs: interface 0 claimed by ch341 while 'brltty' sets config #1
[386229.556470] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
[386229.556518] ch341 3-1.2:1.0: device disconnected
[386229.589971] input: BRLTTY 6.4 Linux Screen Driver Keyboard as /devices/virtual/input/input64
[386229.592985] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1
[386234.592285] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1
[386239.592687] usb 3-1.2: usbfs: interface 0 claimed by usbfs while 'brltty' sets config #1

# when unplugging it: 
[386262.432251] usb 3-1.2: USB disconnect, device number 78


$ locate *brltty*.rules
/usr/lib/udev/rules.d/85-brltty.rules
/usr/share/doc/brltty/examples/brltty-usb-generic.rules
/usr/share/doc/brltty/examples/device.rules
/usr/share/doc/brltty/examples/uinput.rules

sudo subl /usr/lib/udev/rules.d/85-brltty.rules
# search for `1a86:7523` from above, and comment out that line with a `#`
# Save and close the file. 

sudo udevadm control --reload-rules
# See: https://unix.stackexchange.com/questions/670636/unable-to-use-usb-dongle-based-on-usb-serial-converter-chip/670637#comment1285936_680547
sudo udevadm trigger
# from my own notes: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/arduino

############ actually, copy it first: 
sudo cp /usr/lib/udev/rules.d/85-brltty.rules /etc/udev/rules.d/
# edit it here now
sudo subl /etc/udev/rules.d/85-brltty.rules

# then restart udevadm ???????????
sudo systemctl restart systemd-udevd




$ sudo systemctl status brltty
● brltty.service - Braille Device Support
     Loaded: loaded (/lib/systemd/system/brltty.service; disabled; vendor preset: enabled)
     Active: active (running) since Sat 2025-07-12 16:37:26 MST; 7h ago
       Docs: man:brltty(1)
             http://brltty.com/
   Main PID: 536584 (brltty)
      Tasks: 6 (limit: 76502)
     Memory: 5.4M
        CPU: 40.758s
     CGroup: /system.slice/brltty.service
             └─536584 /bin/brltty --no-daemon

Jul 13 00:01:10 gabriel brltty[536584]: USB configuration set error 16: Device or resource busy
Jul 13 00:01:10 gabriel brltty[536584]: brltty: USB configuration set error 16: Device or resource busy
Jul 13 00:01:10 gabriel brltty[536584]: brltty: USB interface in use: 0 (usbfs)
Jul 13 00:01:10 gabriel brltty[536584]: brltty: possible cause: another brltty process may be accessing the same device
Jul 13 00:01:10 gabriel brltty[536584]: brltty: possible cause: the device may be attached to a virtual machine running on this host
Jul 13 00:01:10 gabriel brltty[536584]: brltty: USB interface claim error 16: Device or resource busy
Jul 13 00:01:10 gabriel brltty[536584]: USB interface in use: 0 (usbfs)
Jul 13 00:01:10 gabriel brltty[536584]: possible cause: another brltty process may be accessing the same device
Jul 13 00:01:10 gabriel brltty[536584]: possible cause: the device may be attached to a virtual machine running on this host
Jul 13 00:01:10 gabriel brltty[536584]: USB interface claim error 16: Device or resource busy
$SHLVL:1 


$ sudo systemctl stop brltty
$SHLVL:1 
$ sudo systemctl status brltty
○ brltty.service - Braille Device Support
     Loaded: loaded (/lib/systemd/system/brltty.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
       Docs: man:brltty(1)
             http://brltty.com/

Jul 13 00:01:30 gabriel brltty[536584]: USB interface in use: 0 (usbfs)
Jul 13 00:01:30 gabriel brltty[536584]: possible cause: another brltty process may be accessing the same device
Jul 13 00:01:30 gabriel brltty[536584]: possible cause: the device may be attached to a virtual machine running on this host
Jul 13 00:01:30 gabriel brltty[536584]: USB interface claim error 16: Device or resource busy
Jul 13 00:01:33 gabriel systemd[1]: Stopping Braille Device Support...
Jul 13 00:01:33 gabriel brltty[536584]: select: Interrupted system call
Jul 13 00:01:33 gabriel brltty[536584]: brltty: select: Interrupted system call
Jul 13 00:01:33 gabriel systemd[1]: brltty.service: Deactivated successfully.
Jul 13 00:01:33 gabriel systemd[1]: Stopped Braille Device Support.
Jul 13 00:01:33 gabriel systemd[1]: brltty.service: Consumed 40.892s CPU time.
$SHLVL:1 


sudo cp /etc/brltty.conf /etc/brltty.conf.bak
# edit the file:
sudo subl /etc/brltty.conf
# add this: 
no-usb-devices 1a86:7523

# restart brltty:
sudo systemctl restart brltty


######## still fails 

sudo subl /etc/udev/rules.d/99-arduino.rules
#add
# For the CH340/CH341 USB to serial adapter (UART)
SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="7523", MODE="0666", GROUP="dialout"

sudo udevadm control --reload-rules
sudo udevadm trigger


sudo mv /etc/udev/rules.d/99-arduino.rules /etc/udev/rules.d/50-arduino.rules

sudo udevadm control --reload-rules
sudo udevadm trigger


sudo subl /etc/udev/rules.d/50-arduino.rules
# change to this line:
SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="7523", ENV{ID_USB_INTERFACES}=":ff0000:", GROUP="dialout", MODE="0666", ENV{BRILLO_IGNORE}="true"

sudo udevadm control --reload-rules
sudo udevadm trigger


sudo systemctl stop brltty
sudo systemctl status brltty

$ ps aux | grep -i brltty
gabriel+  593307  2.4  0.0 203528  5908 ?        Ssl  Jul12   1:27 /bin/brltty -b ba -s no -x a2 -N
root      608493  0.2  0.0 547644 12256 ?        S<sl Jul12   0:04 /sbin/brltty -n -p /var/run/brltty.pid
gabriel+  612262  2.2  0.0 203528  6376 ?        Ssl  Jul12   0:41 /bin/brltty -b ba -s no -x a2 -N
root      620773  0.3  0.1 377300 89324 ?        Sl   Jul12   0:05 /opt/sublime_text/sublime_text --detached --fwdargv0 /usr/bin/subl /etc/udev/rules.d/85-brltty.rules
gabriel+  625612  0.0  0.0   9212  2400 pts/0    S+   00:23   0:00 grep --color=auto -i brltty
$SHLVL:1 

$ sudo kill 593307 608493 612262 620773 625612
kill: (625612): No such process


###### 
sudo subl /etc/udev/rules.d/85-brltty.rules
# change to: 
ENV{PRODUCT}=="1a86/7523/*", ENV{BRLTTY_BRAILLE_DRIVER}="bm", GOTO="brltty_usb_end"

$ sudo systemctl start brltty
$SHLVL:1 
$ sudo systemctl status brltty
● brltty.service - Braille Device Support
     Loaded: loaded (/lib/systemd/system/brltty.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2025-07-13 00:32:02 MST; 1s ago
       Docs: man:brltty(1)
             http://brltty.com/
   Main PID: 626955 (brltty)
      Tasks: 6 (limit: 76502)
     Memory: 1.7M
        CPU: 35ms
     CGroup: /system.slice/brltty.service
             └─626955 /bin/brltty --no-daemon

Jul 13 00:32:02 gabriel brltty[626955]: emoji substitutiion won't be performed
Jul 13 00:32:02 gabriel brltty[626955]: BrlAPI Server: release 0.8.3
Jul 13 00:32:02 gabriel brltty[626955]: Linux Screen Driver:
Jul 13 00:32:02 gabriel brltty[626955]: brltty: Linux Screen Driver:
Jul 13 00:32:02 gabriel brltty[626955]: USB configuration set error 16: Device or resource busy
Jul 13 00:32:02 gabriel brltty[626955]: brltty: USB configuration set error 16: Device or resource busy
Jul 13 00:32:02 gabriel brltty[626955]: USB interface in use: 0 (ch341)
Jul 13 00:32:02 gabriel brltty[626955]: brltty: USB interface in use: 0 (ch341)
Jul 13 00:32:02 gabriel brltty[626955]: NoSpeech Speech Driver:
Jul 13 00:32:02 gabriel brltty[626955]: brltty: NoSpeech Speech Driver:
$SHLVL:1 


sudo udevadm control --reload-rules
sudo udevadm trigger

```

https://grok.com/chat/a785ffbb-f8a7-4555-84ad-5efeac573264

References:
1. [Google search for "linux ch340 uart not working"](https://www.google.com/search?q=linux+ch340+uart+not+working&oq=linux+ch340+uart+not+working&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTEwNTQ0ajBqN6gCCLACAQ&sourceid=chrome&ie=UTF-8)
1. [Google search for "linux arduino ch340 brltty"](https://www.google.com/search?q=linux+arduino+ch340+brltty&oq=linux+arduino+ch340+brltty&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDUzOTBqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8)
1. https://forum.arduino.cc/t/port-not-showing-up-ch340-in-ubuntu-solution/1176862
1. https://github.com/arduino/help-center-content/issues/155
1. \*\*\*\*\* [Unix Linux Stack Exchange: Unable to use USB dongle based on USB-serial converter chip](https://unix.stackexchange.com/a/680547/114401)
1. https://bbs.archlinux.org/viewtopic.php?id=269975
1. https://stackoverflow.com/q/70123431/4561887


---

DONE!



