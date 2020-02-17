Gabriel Staples

This project is well-maintained, highly-used by myself, and highly-functional. It's not experimental, it's what I use every day. Feel free to use or borrow from it yourself. 

# Project: eRCaGuy_dotfiles
https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Description of contents
This project started out as just a few helpful nuggets I like to put in my `~/.bashrc` file, for example, as well as some scripts and other configuration files, but I decided to make it a place I put all sorts of reference scripts, files, shortcuts, Linux tips & tricks, Eclipse documentation, etc, I've built up over the years. 

## Here's some of the contents contained herein:
1. .bashrc file which contains:
    1. `ls` aliases such as `ll`, `la`, & `l`
    1. Prompt String 1 (`PS1`) modifications to add terminal titles, current git branch name checked out [VERY USEFUL FEATURE!], bash shell level, etc
        1. ![bash shell terminal prompt showing current git branch!](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/bashrc_sample_terminal_prompt.png)
    1. ssh alias
    1. function to set terminal title
    1. ability to open up default tabs (with unique titles) for rapid launching of tabs in a terminal for development work
1. .gitconfig file with meld as my difftool, `git lg` alias, etc
1. Preferences.sublime-settings = Sublime Text 3 settings I like
1. .gitignore example
1. .imwheelrc config to improve mouse wheel scroll speed in Chrome
1. Templates for right-click --> Create New Document menu in GUI file manager
1. Desktop launchers (.desktop) files, including install/uninstall scripts
1. Arduino tools & resources
    1. How to enable uploading to boards by adding user to "dialout" group
    1. How to enable flashing bootloaders with USBasp tool by setting up proper udev rule
1. Eclipse tools & resources, including a reference & setup manual I've written:
    1. Eclipse setup instructions on a new Linux (or other OS) computer.pdf
    1. Eclipse color theme to make it have syntax highlighting that looks exactly like Sublime Text 3 (thanks to Jeremy Shepherd!)
1. /etc/udev/rules.d/ udev rules
1. NoMachine remote login setup info
1. Useful scripts (tree generated w/`tree eRCaGuy_dotfiles/useful_scripts`):
```
    useful_scripts/
    ├── apt-cacher-server_proxy.sh
    ├── apt-cacher-server_proxy_status.sh
    ├── apt-cacher-server_proxy_toggle.sh
    ├── desktop_file_install.sh -> ../Desktop_launchers/desktop_file_install.sh
    ├── desktop_file_uninstall.sh -> ../Desktop_launchers/desktop_file_uninstall.sh
    ├── install.sh
    ├── open_programming_tools.sh = quick script to load all the tools I need to do software development each day
    └── touchpad_toggle.sh = attached to Ctrl + Alt + P Ubuntu shortcut key to quickly toggle my touchpad & 
                             touchscreen on & off, & fix mouse scroll wheel speed
```
1. etc.

# Usage & Installation:
1. Most files contain comments with additional info, instructions, or helpful links to look at.
2. Many directories contain readmes, and some contain install scripts, such as my scripts to help install .desktop files. 
3. If a readme exists in a subfolder, take a look at it too for more install help or other usage information. 
4. Essentially, just read the readmes, headers, & other comments and it will become self-explanatory how to use or "install" something. If not, open up an issue or pull request and I'll address it. 

