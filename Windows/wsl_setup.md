This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Windows subsystem for Linux (WSL) setup


# References

1. https://learn.microsoft.com/en-us/windows/wsl/install - Install Linux on Windows with WSL
1. https://learn.microsoft.com/en-us/windows/wsl/setup/environment - best practices to "Set up a WSL development environment"
1. https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps - Run Linux GUI apps on the Windows Subsystem for Linux
1. https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux - Wikipedia
1. https://github.com/Microsoft/WSL - official, Microsoft-supported *issues-reporting* site for WSL
1. https://learn.microsoft.com/en-us/windows/wsl/basic-commands - Basic commands for WSL
1. https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#1-overview - Ubuntu's version of WSL installation instructions
1. [Google search for "wsl connect network interfaces"](https://www.google.com/search?q=wsl+connect+network+interfaces&oq=wsl+connect+network+interfaces&aqs=chrome..69i57.4359j0j7&sourceid=chrome&ie=UTF-8)
    1. https://learn.microsoft.com/en-us/windows/wsl/networking - Accessing network applications with WSL

        Port forwarding from Windows to WSL Linux:
        ```bash
        netsh interface portproxy add v4tov4 listenport=<yourPortToForward> listenaddress=0.0.0.0 connectport=<yourPortToConnectToInWSL> connectaddress=(wsl hostname -I)
        ```


# Installation & setup

_Tested in Windows 10 Pro, Version 22H2, build 19045.3208._


## Install WSL

See mostly: https://learn.microsoft.com/en-us/windows/wsl/install


See: https://github.com/microsoft/WSL/issues/9420#issuecomment-1620249197 //////////
Open command prompt as admin. Run: 

```bash
netsh winsock reset
# restart the computer
```


Open a _cmd prompt_ as your _regular domain user_, *not* as a local administrator, and run the following. You will get some popup windows at some point requesting an admin username and password. Simply type in your admin username and password when requested. 

```bash
# see which online WSL distributions you can install
wsl --list --online
#
# Example output:
#
#   C:\WINDOWS\system32>wsl --list --online
#   The following is a list of valid distributions that can be installed.
#   Install using 'wsl --install -d <Distro>'.
#   
#   NAME                                   FRIENDLY NAME
#   Ubuntu                                 Ubuntu
#   Debian                                 Debian GNU/Linux
#   kali-linux                             Kali Linux Rolling
#   Ubuntu-18.04                           Ubuntu 18.04 LTS
#   Ubuntu-20.04                           Ubuntu 20.04 LTS
#   Ubuntu-22.04                           Ubuntu 22.04 LTS
#   OracleLinux_7_9                        Oracle Linux 7.9
#   OracleLinux_8_7                        Oracle Linux 8.7
#   OracleLinux_9_1                        Oracle Linux 9.1
#   openSUSE-Leap-15.5                     openSUSE Leap 15.5
#   SUSE-Linux-Enterprise-Server-15-SP4    SUSE Linux Enterprise Server 15 SP4
#   SUSE-Linux-Enterprise-15-SP5           SUSE Linux Enterprise 15 SP5
#   openSUSE-Tumbleweed                    openSUSE Tumbleweed

# Update your WSL system first
wsl --update

# Then install the default (Ubuntu)
# Notes: 
# - This installed Ubuntu 22.04.2 for me, so apparently "Ubuntu" must default to
#   the latest version available in the output above, I'm guessing, which is
#   good.
# - This is surprisingly fast! It takes like 1 or 2 minutes is all, which is
#   really quite amazing. 
# - You'll be required to create a Linux username and password. It can be
#   anything you want. It does *not* have to match your Windows username or
#   password.
wsl --install
```

If you ever get a `Catastrophic failure` warning during the above, it's probably because you have a regular domain user account, and a local admin user account, and you ran the command prompt as an admin. Don't do that. Just run it as your normal domain user instead. See [this issue, and my comment here](https://github.com/microsoft/WSL/issues/9420#issuecomment-1670527539). 

When done installing, you'll now have an "Ubuntu" start menu entry. Run it, and you'll get a Linux terminal. In your new WSL Linux terminal, check your installed version with [`lsb_release -a`](https://linuxize.com/post/how-to-check-your-ubuntu-version/). Here is my run and output. As you can see, WSL installed Ubuntu 22.04.2 for me, which is the latest Ubuntu LTS release out right now:

```bash
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.2 LTS
Release:        22.04
Codename:       jammy
```

Here are some more things to check in the WSL Linux terminal:

```bash
# check the IP address of your Linux distribution installed via WSL; see:
# https://learn.microsoft.com/en-us/windows/wsl/basic-commands#identify-ip-address
# Ex: `127.0.1.1`
hostname -i
# You can ping this address from WSL
ping 127.0.1.1

# see "the IP address of the Windows machine as seen from WSL 2 (the WSL 2 VM)"
cat /etc/resolv.conf

# see WSL's IP address
ifconfig
# Note: in a Windows command prompt, you can `ping` that IP address
```

Your Windows `C:\` drive is found in WSL Linux at `/mnt/c`. See here for details on how to manually mount your own drive: https://learn.microsoft.com/en-us/windows/wsl/wsl2-mount-disk#differences-between-mounting-an-external-drive-with-windows-formatting-versus-linux-formatting. 


## Run Linux GUI apps in WSL

See mostly: https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps

> You will need to be on Windows 10 Build 19044+ or Windows 11 to access this feature.

1. First, identify your video card:

    In Windows, press Ctrl + Alt + Delete --> click on "Task Manager" --> "Performance" tab --> click on the "GPU 0" entry in the left column. At the top-right, above the graphs, you'll see the name of your GPU. Ex: "Intel(R) Iris(R) Xe Graphics". 

    Choose your link for "Intel", "AMD", or "NVIDIA" GPU driver here: https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps#prerequisites

    ...and install that driver in Windows. In my case, I need to choose the "Intel" link, and then download and install the recommended driver.

1. In a normal, *non*-admin *command prompt*, run the following. Type in an admin username and password in any popup windows requesting it:

    ```bash
    wsl --update
    ```

    If you see this: 

    > The most recent version of Windows Subsystem for Linux is already installed.

    ...then you already have this GUI feature in WSL, and you are done! 

    If you see something else, and it upgrades WSL, then you must shutdown WSL and start it up again. 

    First, in a regular command prompt, run:
    ```bash
    wsl --shutdown
    ```

    Once it finishes, re-open "Ubuntu" from your start menu. 

    You can now install and run GUI applications from the Linux terminal, and they will open up and work like normal.


## Other setup

#### Install & configure Windows Terminal

Install it from here: https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701

Open it. Click the down arrow at the top --> select "Ubuntu" to open up WSL. You can also choose Power Shell, Command Prompt, etc. 

Features:
- Ctrl + Shift + T = open up a new tab
- Ctrl + Shift + 4 = open up an Ubuntu WSL tab
- etc--click the down arrow at the top to see more
- Ctrl + Shift + W = close the current tab

Change your settings: 
1. Click the dropdown arrow at the top --> Settings. Left-hand pane settings:
    1. Click "Startup" in the left-hand pane. Change:
        1. "Default profile" to "Ubuntu"
        1. "Default terminal application" to "Windows Terminal"
        1. "When Terminal starts" to "Open windows from a previous session"
    1. "Profiles" --> "Ubuntu"
        1. "Appearance" --> Font size --> change from 12 to 10. 
    1. "Actions"
        1. "Next tab" --> set to Ctrl + PgDown --> click the checkmark to save this setting.
        1. "Previous tab" --> set to Ctrl + PgUp --> click the checkmark to save this setting.
        1. Reference: https://georgik.rocks/how-to-switch-tabs-in-windows-terminal/
1. Click "Save" at the bottom. Click the "X" in the top-right of this "Settings" tab to close it. 

#### Add minimize, maximize, and close buttons to all GUI windows opened in WSL

Run this:
```bash
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
```
See:
1. https://askubuntu.com/a/1443935/327339
    1. My comment: https://askubuntu.com/questions/1443927/maximize-and-restore-button-not-visible-in-wsl-gui-window#comment2594499_1443935
1. This excellent answer: https://askubuntu.com/a/651349/327339

#### Open the Windows firewall on the "Public network" to allow the WSL Linux system to ping/talk to Windows

//////
https://superuser.com/a/1752574/425838


#### Install commonly-needed tools

```bash

```




