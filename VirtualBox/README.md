**This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles**

This is for the [VirtualBox](https://www.virtualbox.org/) Virtual Machine (VM).


## Setup

1. Download the software. 

    Example low-level downloads page: https://download.virtualbox.org/virtualbox/7.0.12/index.html

    OR, go here: https://www.virtualbox.org/wiki/Downloads --> 
    1. Under "platform packages", click on the link for "Linux distributions", and get it.
    2. Under "VirtualBox Extension Pack", download the extension pack. 

1. Install VirtualBox:
    ```bash
    # remove the old one, if necessary
    sudo dpkg -r virtualbox-6.1

    # install the new one
    sudo dpkg -i virtualbox-7.0_7.0.12-159484~Ubuntu~focal_amd64.deb
    ```

    Double-click the extension pack for VirtualBox to open and have you install it. Ex: file `Oracle_VM_VirtualBox_Extension_Pack-7.0.12.vbox-extpack`. 

1. Add your username to the `vboxusers` group (OR always run VirtualBox as root, which is not recommended), so that you can access USB devices from within the VM:
    
    ```bash
    sudo usermod -a -G vboxusers $USER
    ```

    See my answer here: https://askubuntu.com/a/1455145/327339

    Log out of Ubuntu and log back for the new group to take effect. When you are back in Ubuntu, run this to ensure the group was successfully added:

    ```bash
    groups
    ```

1. Download the latest version of Windows (ex: Windows 11) straight from Microsoft, and install it into the VM. 

    Ex: https://www.microsoft.com/software-download/windows11

