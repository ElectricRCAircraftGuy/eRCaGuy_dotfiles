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


# Installation & setup

_Tested in Windows 10 Pro, Version 22H2, build 19045.3208._


## Install WSL

See mostly: https://learn.microsoft.com/en-us/windows/wsl/install

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
