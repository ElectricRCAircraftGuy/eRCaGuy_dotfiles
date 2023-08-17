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


## 3. Enable the Linux-like `python3` executable (called in Python scripts via hash-bangs) in Windows:

1. Create a `~/.bashrc` file in Windows, and put this into the bottom of it:

    ```bash
    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi
    ```

1. Add a `~/bin/python3` executable:

    ```bash
    # create the `~/bin` dir
    mkdir -p ~/bin

    # Create `~/bin/python3` and open it in VSCode for editing
    # - This assumes you have already installed MS VSCode, *and* closed and
    #   reopened all Git Bash terminals, prior to running this command.
    code ~/bin/python3
    ```

    Place this into it:
    ```bash
    #!/usr/bin/env bash

    python "$@"
    ```

    Save and close the file. 

    ```bash
    # Ensure it is executable:
    chmod +x ~/bin/python3
    
    # Re-source your ~/.bashrc file
    . ~/.bashrc
    
    # Test to ensure your new `python3` Bash wrapper executable now works
    python3 --version
    ```

## 4. If running `python` or `python3` in an interactive terminal causes it to freeze, or hang forever...

If you try to run `python` or `python3` interactively in Git Bash, but it just hangs forever, but `python` otherwise works fine in the Command Prompt or Power Shell, then it means you have a small incompatibility with Git Bash. [Read more about that here](https://stackoverflow.com/a/48200434/4561887). To fix it, you need to call `python` through `winpty`, like this: `winpty python`, for proper interactive use in the Git Bash terminal. 

So, make this automatic by adding `alias python='winpty python'` and `alias python3='winpty python'` to the bottom of your `~/.bashrc` file by running these commands:
```bash
# Add these alias entries to your ~/.bashrc file
# These commands create these entries in the bottom of `~/.bashrc`:
#       
#       alias python='winpty python'
#       alias python3='winpty python'
#
# NB: it is *not* a mistake that both aliases point to `python`. That is how it
# is supposed to be!
echo -e "\n" >> ~/.bashrc
echo "alias python='winpty python'" >> ~/.bashrc
echo "alias python3='winpty python'" >> ~/.bashrc

# verify these entries are there now
cat ~/.bashrc

# re-source your ~/.bashrc file to bring in this change
. ~/.bashrc

# show that you can now see these `python` and `python3` aliases in your list of active aliases
alias

# test it to ensure an interactive Python 3 session works now even when called
# inside the Git Bash terminal
python   # then type `exit()` to exit
python3  # then type `exit()` to exit
```

Now, exactly _how_ this works is a little bit tricky, so let me explain: 
- alias////////// - used in terminal
- executable////////// - used otherwise, including by the hashbang
///////////// make this an answer online here: https://stackoverflow.com/q/32597209/4561887 - for those coming from Linux and really struggling with this pain-in-a-butt called Windows. Man, Windows is a pain in the butt. In some ways it is *sooooo* much harder to use than Linux. This is one of those ways!
//////////
```bash
python
python3
./hello_world.py
```

References:
1. The `winpty` alias solution: https://stackoverflow.com/a/36530750/4561887
1. What `winpty` is, and why you need it: https://stackoverflow.com/a/48200434/4561887
1. My own prior knowledge and trial and error.


# Obsolete notes

<!--

**Fix the `python3` alias above so it works too:**

Your `python3` alias may still not work interactively in the Git Bash terminal, however. To fix it, we need to do a few more things. You may see this error when you try running `python3`, for instance: 

> `winpty: error: cannot start '"C:/Program Files/WindowsApps/Microsoft.DesktopAppInstaller_1.20.1881.0_x64__8wekyb3d8bbwe/AppInstallerPythonRedirector.exe"': Access is denied. (error 0x5)`

Fix that by following these instructions here: https://stackoverflow.com/a/70514804/4561887. In short, press the <kbd>Windows</kbd> key and search for "Manage app execution aliases". Check *off* the sliders for the `python.exe` and `python3.exe` entries, as shown here: 

[![image](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/54d6dfa2-2e0d-4a9c-aea1-0de41c5c36ce)](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/assets/6842199/54d6dfa2-2e0d-4a9c-aea1-0de41c5c36ce)

Now, if you run `python3`, you may get this error instead: 

> `winpty: error: cannot start 'python3': Not found in PATH`

We can fix that by adding `~/bin` to our Windows `Path` **environment variables** as follows: right-click on the Windows start menu icon -> System -> click the blue "Advanced system settings" link either on the far right if the window is large, or at the bottom if the window is small -> click the "Advanced" tab -> "Environment Variables..." -> select the `Path` "User variables" entry near the top -> click "Edit..." -> click "New" -> type in `%USERPROFILE%\bin` into the new entry box -> click "OK" -> click "OK" again to close the "Environment Variables" window -> click "OK" again to close the "System Properties" window. Now, close and re-open all of your Git Bash terminals. 

-->
