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

        useful_scripts/
        ├── apt-cacher-server_proxy.sh
        ├── apt-cacher-server_proxy_status.sh
        ├── apt-cacher-server_proxy_toggle.sh
        ├── desktop_file_install.sh -> ../Desktop_launchers/desktop_file_install.sh
        ├── desktop_file_uninstall.sh -> ../Desktop_launchers/desktop_file_uninstall.sh
        ├── install.sh
        ├── open_programming_tools.sh = quick script to load all the tools I need to do software development each day
        ├── sync_git_repo_from_pc1_to_pc2--notes.txt
        ├── sync_git_repo_from_pc1_to_pc2.sh = an EXCELLENT script to synchronize a git repo from one computer to another! SEE BELOW FOR DETAILS.
        └── touchpad_toggle.sh = attached to Ctrl + Alt + P Ubuntu shortcut key to quickly toggle my touchpad & 
                                 touchscreen on & off, & fix mouse scroll wheel speed

1. etc.

# Usage & Installation:
1. Most files contain comments with additional info, instructions, or helpful links to look at.
2. Many directories contain readmes, and some contain install scripts, such as my scripts to help install .desktop files. 
3. If a readme exists in a subfolder, take a look at it too for more install help or other usage information. 
4. Essentially, just read the readmes, headers, & other comments and it will become self-explanatory how to use or "install" something. If not, open up an issue or pull request and I'll address it. 

# `sync_git_repo_from_pc1_to_pc2.sh` Description & Details

This is an incredibly powerful and useful script, so I'm giving it a section all on its own. 

1. Sometimes you need to develop software on one machine (ex: a decent laptop, running an IDE like Eclipse) 
   while building on a remote server machine (ex: a powerful desktop, or a paid cloud-based server such as 
   AWS or Google Cloud--like this guy: https://matttrent.com/remote-development/). The problem, however, 
   is **"how do I sync from the machine I work on (ex: Personal Computer 1, or PC1) to the machine I build on
   (ex: Personal Computer 2, or PC2)?"**.  
   This script answers that problem. It uses `git` to sync from one to the other. Git is 
   preferred over `rsync` or other sync tools since they try to sync *everything* and on large repos 
   they take FOREVER (dozens of minutes, to hours)! This script is lightning-fast (seconds) and 
   ***safe***, because it always backs up any uncommitted changes you have on either PC1 or PC2
   before changing anything!
1. A typical run might take <= ~30 seconds, and require ~25 MB of data. This is a very small amount of data compared to other options when syncing very large repos, and this is something which you care about if running on a hotspot from your cell phone.
1. Run it from the *client* machine where you develop code (PC1), NOT the server where you will build or otherwise test or use the code (PC2)!
1. It MUST be run from a directory inside the repo you are syncing FROM.

## Installation and Usage:
See the headers at the top of these files for additonal information, installation, and usage:

1. "eRCaGuy_dotfiles/useful_scripts/sync_git_repo_from_pc1_to_pc2.sh"
2. "eRCaGuy_dotfiles/.sync_git_repo"

**See also this answer and writeup on StackOverflow: https://stackoverflow.com/questions/4216822/work-on-a-remote-project-with-eclipse-via-ssh/60315754#60315754**

Essentially, you just copy the .sync_git_repo file to ~/.sync_git_repo, update its parameters, and then run the script from any directory *inside the git repo* on PC1. This also assumes that PC2 already has the repo cloned, and that all your ssh keys are set up and functioning to both A) push and pull to/from the remote git repo on both PC1 and PC2, and B) ssh from PC1 into PC2. Again, see the instructions in the files above. 
