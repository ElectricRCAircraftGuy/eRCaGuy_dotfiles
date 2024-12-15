This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Remote-controllable power supplies

There are a variety of power supplies that can be controlled remotely. They might be controlled over Ethernet, serial, WiFi, or USB, for example. You could then remote into a machine via ssh, NoMachine, RDP (or Remmina), etc., and control the power supply from there.

Here are two that I've used:


## 1. Teledyne LeCroy T3PS3000 

See: $815: https://www.digikey.com/en/products/detail/teledyne-lecroy/T3PS3000/9598577

Works over TCP/IP Ethernet, port 5025. 

Example commands:
```bash
# Turn channel 1 OFF
printf '%s' 'output ch1,off' | timeout 0.2 nc 192.168.0.1 5025  

# Turn channel 1 ON
printf '%s' 'output ch1,on' | timeout 0.2 nc 192.168.0.1 5025  
```

For many more examples and details, see this file: [`../git & Linux cmds, help, tips & tricks - Gabriel.txt`](<../git & Linux cmds, help, tips & tricks - Gabriel.txt>), and search the file for "T3PS3000" and "5025".


## 2. PowerUSB

See: $120\~$180: https://pwrusb.com/collections/all

Ex: 
1. Basic: https://pwrusb.com/collections/all
1. Digital IO: https://pwrusb.com/products/powerusb-digital-io

All of the devices on the main page are controlled over USB. I think they may register themselves as USB HID devices (similar to keyboards, mice, joysticks, game controllers, etc.). They provide a GUI and command-line tool to control them. Get the software here: https://pwrusb.com/pages/downloads. They support Windows, Mac, and Linux. 

Ex: for Windows: 

Download the "Windows software", extract it, and run `Setup.exe` to install it. It installs into `C:\Program Files (x86)\PowerUSB`. A bunch of PDF user manuals also get placed there. The command-line tool is here: `C:\Program Files (x86)\PowerUSB\PwrUsbCmd.exe`. A `powerusb` GUI tool is also installed into the Start menu. 

For example usage, see: [`power_supply_PowerUSB_Windows_cycle_power.sh`](power_supply_PowerUSB_Windows_cycle_power.sh). 

That Bash script, as well as the commands below, are meant to be run on Windows in a Linux-like terminal such as Git Bash or MSYS2. See [my MSYS2 setup instructions here](https://stackoverflow.com/a/77407282/4561887).

Note that the `PwrUsbCmd.exe` tool is pretty clunky and non-standard. But, it works.

Here are some example commands. For all commands below, you must first run this in your terminal:
```bash
PwrUsbCmd="/c/Program Files (x86)/PowerUSB/PwrUsbCmd.exe"
```

Help menu:

```bash
# help menu: type this command and then press Enter **twice** (which is odd)
"$PwrUsbCmd"
```

Example help menu output:
```
Usage: pwrusbcmd [0,1] [0,1] [0,1] p c (0 for off and 1 for on)
Up to 15 outlets. Must be multiple of 3 for up to 5 PowerUSBs
'p' for pause at the end of command
'c' for power consumed in primary PowerUSB unit
Eg. pwrusbcmd 1 0 0 (will switch on outlet1 and switch off outlet2 & 3)
Eg. pwrusbcmd 1 1 1 c (will siwtch-on all outlets and report power consumption
pwrusbcmd s [1-5] [1-3] [0,1] (Single port on-off. [Unit] [Port] [On-Off])
Eg. pwrusbcmd s 2 2 1 (will switch on the outlet 2 in PowerUSB unit 2)
WATCHDOG: pwrusbcmd w [x] [y] [z] (Will not work with other parameters)
x=Time between heartbeats(hb), y:Number of hb misses. z:cpu reset time(sec)
Starts watchdog and start sending hb. Esc to stop monitor and quit
Eg. pwrusbcmd w 60 3 20. (Send hb every 60sec. Reset for 20 sec if 3 hb fail
DIGITAL IO PLC Controller Options
Output: pwrusbcmd o [0,1] [0,1] [0,1].(Sets the 3 Digial Output States)
Input : pwrusbcmd i. (Returns the status of 4 digital inputs. 0 or 1)
Trig  : pwrusbcmd t [0 or 1-4] [0,1] [-3-32000]..(6 time) [2222]..(6 time)
Sets trigger actions. Cannot use with other params. See manual for details
First Param: 0-Clear Table, -1-OffPLC, -2-OnPLC, 1-4: Input Port Action
Action: -3-noAction -2-toggle -1-on 0-off 1-32K-secs on
Addional Condition [2222] 2-dont care, 1-has to be on, 0-has to be off
Eg. pwrusbcmd o 1 0 1. (Sets outlet 1 & 3 on and outlet 2 to off
Eg. pwrusbdmd i (Will return 1 1 0 0, if outlet 1 & 2 are on and 3 & 4 are off
Enter to continue
```

Basic outlet control commands:  

```bash
# Note that you can control up to 15 outlets via 5 connected PowerUSB devices
# (3 outlets per device).

"$PwrUsbCmd" 0 0 0  # outlet1 outlet2 outlet3  OFF

"$PwrUsbCmd" 1 1 1  # outlet1 outlet2 outlet3  ON

"$PwrUsbCmd" c  # read the power 'c'onsumed
# Example output:
#
#       PowerUSB Connected. Number of Devices:1 Model: 2. Version:3.3
#       Power Consumed now(ma):250. Total Power Consumed(kwh)(120VAC):  3.417
```

That's the gist of it. For more info, look inside the `PowerUSB-Basic-UserManual.pdf`, which is inside of the extracted `WindowsFiles.zip` file, as well as inside the installed location here: `C:\Program Files (x86)\PowerUSB\PowerUSB-Basic-UserManual.pdf`. See especially the section titled **"3. COMMAND-LINE APPLICATION"**. 

There are a bunch of other commands, as shown in the help menu above too.

Also look at [`power_supply_PowerUSB_Windows_cycle_power.sh`](power_supply_PowerUSB_Windows_cycle_power.sh).


## 3. Digital Loggers, Inc. (DLI) Web Power Switch Pro

Purchase: 
1. $189: https://dlidirect.com/products/new-pro-switch
1. $189 on Amazon: https://amzn.to/4gBBnoe

REST API to remotely control it: https://www.digital-loggers.com/rest.html

Use `curl` on Linux, or via Git Bash on Windows, to control it via a bash shell script.


The Amazon listing above says: 

> Secure web server with SSL, SSH, HTTPS, SNMP, REST API, MODBUS

So, you may be able to use `ssh` commands to control it too, in addition to the REST API. Not sure. I'll need to investigate more later. 
