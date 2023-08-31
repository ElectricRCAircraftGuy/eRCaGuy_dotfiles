This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Windows

I will put content here which is specific to Windows or to [WSL (Windows Subsystem for Linux)](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux).


# Pages

1. [Windows subsystem for Linux (WSL) setup](wsl_setup.md)


# Install Python in Windows

See also: https://programmingwithjim.wordpress.com/2020/09/08/installing-python-3-in-git-bash-on-windows-10/


## 1. Install Python

1. Download the latest version of Python from the offical website here: https://www.python.org/downloads/
1. Run the Windows `.exe` installer. Be sure to check the box for `Add python.exe to PATH` on the opening install page, as shown here!:

    [![image](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/822d66c9-4936-4c52-a1c1-6d1ccd45712d)](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/822d66c9-4936-4c52-a1c1-6d1ccd45712d)

1. Click "Customize installation", and ensure all boxes are checked (mine already were), as shown here:

    [![image](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/7fa8f87b-2242-4547-a7dc-a30779ec2e73)](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/7fa8f87b-2242-4547-a7dc-a30779ec2e73)

1. Click "Next". Check the box for "Install Python 3.11 for all users", and "Download debugging symbols". I now have this:

    [![image](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/286b35ac-31c0-4ad2-aa8d-e7d155ce92fa)](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/286b35ac-31c0-4ad2-aa8d-e7d155ce92fa)

1. Click "Install". 

    If you chose the option to install for all users, above, it will require you to type in your admin username and password. 

1. On the "Setup was successful" page, click "Disable path length limit":

    [![image](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/2a3eeae6-45b1-4891-a22f-ca6efdb50ae3)](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/2a3eeae6-45b1-4891-a22f-ca6efdb50ae3)

    This will require typing in your admin username and password too.

1. Click any of the helpful URLs, then click "Close" when done.

    Here are the generic forms (specific version numbers removed from the URLs) of the official links at the end of the official installer window when installing Python in Windows, from the official `.exe` Python installer [here](https://www.python.org/downloads/):

    1. Official Python tutorial: https://docs.python.org/3/tutorial/index.html
    1. Official Python documentation: https://docs.python.org/3/index.html
    1. What's new in Python: https://docs.python.org/3/whatsnew/
    1. Official documentation on "Using Python on Windows": https://docs.python.org/3/using/windows.html


## 2. Install Git for Windows

Get it here: https://gitforwindows.org/. After installing it, you can use the Git Bash terminal, which is a Linux-like terminal in Windows.

See especially my installation instructions, screenshots, and notes here: 
1. [Adding Git-Bash to the new Windows Terminal](https://stackoverflow.com/a/76950661/4561887)
1. [Installing Git For Windows](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues/26#issuecomment-1687481094)


## 3. Add `python` and `python3` aliases and executables to allow full, Linux-like Python usage in Git Bash

The aliases call `winpty` to prevent freezing/hanging when running interactively inside the Git Bash terminal, and the `python3` executable wrapper enables Linux-style hash-bangs to run your Python scripts directly as executables. 

See my full answer here for setup and details: [Python doesn't work in Git Bash (it just hangs or freezes forever); and getting Linux hash-bangs to work in Windows](https://stackoverflow.com/a/76918262/4561887).

References:
1. My answer: https://stackoverflow.com/a/76918262/4561887
1. The `winpty` alias solution: https://stackoverflow.com/a/36530750/4561887
1. What `winpty` is, and why you need it: https://stackoverflow.com/a/48200434/4561887
1. My own prior knowledge and trial and error.

