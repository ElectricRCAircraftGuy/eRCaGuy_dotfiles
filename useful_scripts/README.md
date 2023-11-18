This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# See also

1. [../useful_startup_programs.md](../useful_startup_programs.md)
1. [power_supply_README.md](power_supply_README.md) - Remote-controllable power supplies, and commands and scripts to control them
1. [README_git-diffn.md](README_git-diffn.md) - `git diffn`
1. [README_git-sync_repo_from_pc1_to_pc2.md](README_git-sync_repo_from_pc1_to_pc2.md) - `sync_git_repo_from_pc1_to_pc2.sh`
    1. [sync_git_repo_from_pc1_to_pc2--notes.md](sync_git_repo_from_pc1_to_pc2--notes.md) - my scratch notes
1. [README_ros_readbagfile.md](README_ros_readbagfile.md) - `ros_readbagfile`


# eRCaGuy_dotfiles/useful_scripts

Each script herein has detailed installation and usage information commented in the top of it. So, look inside each file for details. For any script which I'd really like to highlight or explain, however, I've provided additional details below. 

1. **git-diffn.sh**
    1. **[README_git-diffn.md](README_git-diffn.md)**
    1. `git diff` with line numbers
1. **git-blametool.sh**
    1. See my answer and demo about `git blametool` here: [StackOverflow: Is there git blame gui similar to bzr qannotate?](https://stackoverflow.com/a/66433627/4561887).
    1. [![](https://i.stack.imgur.com/5D4oE.jpg)](https://i.stack.imgur.com/5D4oE.jpg)
1. **PC-to-PC Git-based Folder/Project Sync Script**
    1. **[README_git-sync_repo_from_pc1_to_pc2.md](README_git-sync_repo_from_pc1_to_pc2.md)**
    1. git-based sync script to re-sync gigabytes of data over a cell phone hot spot in 1 minute and with 50 MB data usage
1. **ros_readbagfile.py**
    1. **[README_ros_readbagfile.md](README_ros_readbagfile.md)**
    1. Read [ROS (Robot Operating System)](http://wiki.ros.org/) messages on certain topics from within a pre-recorded ROS bag file.
        1. Tutorial I wrote: [Reading messages from a bag file](http://wiki.ros.org/ROS/Tutorials/reading%20msgs%20from%20a%20bag%20file)
1. **rgf.sh**
    1. Ripgrep fuzzy finder: this ('rgf') is a RipGrep interactive fuzzy finder of content in files! It is a simple wrapper script around Ripgrep and the [fzf fuzzy finder](https://github.com/junegunn/fzf#3-interactive-ripgrep-integration) that turns RipGrep ('rg') into an easy-to-use interactive fuzzy finder to find content in any files. VERY USEFUL AND EASY TO USE!
1. **rg_replace.sh** (`rgr`)
    1. Ripgrep Replace: this is a wrapper around Ripgrep which allows you to do full find-and-replace on your disk. See [rg_replace.sh](rg_replace.sh). Installation instructions are in the top of the file. Sample help menu from it (`rgr -h`): https://github.com/BurntSushi/ripgrep/issues/74#issuecomment-1004583171


# Generic Linux Ubuntu "installation" instructions for literally any executable or script in the world


## INSTALLATION INSTRUCTIONS
1. Create a symlink in `~/bin` to this script so you can run it from anywhere.
    ```bash
    cd /path/to/myscript_dir
    mkdir -p ~/bin
    # Required
    ln -si "${PWD}/myscript.sh" ~/bin/myscript
    # Optional: prefix the script with your initials; replace `gs` with your
    # initials
    ln -si "${PWD}/myscript.sh" ~/bin/gs_myscript
    ```
1. Log out and log back in if using Ubuntu with a default `~/.profile` file
which automatically adds `~/bin` to your `PATH` variable. This will cause
`~/bin` to be automatically added to your path. If you're missing Ubuntu's
default `~/.profile` file, you can copy it from the `/etc/skel` directory like
this:
    ```bash
    cp -i /etc/skel/.profile ~
    ```
    You can alternatively manually add the `~/bin` dir to your `PATH` with this
    code. Add this to the bottom of your `~/.bashrc` file if you don't have
    the `~/.profile` file mentioned above:
    ```bash
    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi
    ```
    Now log out and log back in again if you just added the `~/bin` dir to your
    `PATH` as described above. 
1. OR, re-source your `~/.bashrc` file if the `~/bin` dir *did* already exist
and was *already* in your `PATH`:
    ```bash
    # Same as running `source ~/.bashrc`
    . ~/.bashrc
    ```
1. Now you can use this command/executable directly anywhere you like, like
this:
    ```bash
    myscript
    # OR
    gs_myscript
    ```
