[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FElectricRCAircraftGuy%2FeRCaGuy_dotfiles&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views+%28today+%2F+total%29&edge_flat=false)](https://hits.seeyoufarm.com)

[>> Sponsor Me on GitHub <<](https://github.com/sponsors/ElectricRCAircraftGuy)

Gabriel Staples

- These are my Linux Ubuntu configuration files and commonly-used scripts--most of which I've written myself. 
- This project is well-maintained, highly-used by myself, and highly-functional. It's not experimental, it's what I use every day. Feel free to use or borrow from it yourself. 
- Disclaimer: any content herein is my own unless stated otherwise. This repo contains my own beliefs, opinions, words and works. They are _not_ endorsed by nor espoused by any of my past nor present employers.


## Also very useful:
1. My [eRCaGuy_hello_world](https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world) repo.
1. [useful_startup_programs.md](useful_startup_programs.md)
1. [README_git_submodules.md](README_git_submodules.md) - how to use git submodules


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC autolink="true" autoanchor="true" style="ordered" -->

1. [Project: eRCaGuy_dotfiles](#project-ercaguy_dotfiles)
1. [Status:](#status)
1. [Hey! I feel so smart! / Help! I feel dumb!](#hey-i-feel-so-smart--help-i-feel-dumb)
1. [Description of contents](#description-of-contents)
1. [_Git submodules and Git LFS:_ how to clone this repo and all git submodules and git lfs files](#git-submodules-and-git-lfs-how-to-clone-this-repo-and-all-git-submodules-and-git-lfs-files)
        1. [References:](#references)
        1. [To clone this repo plus all sub-repos \(git submodules\) and all `git lfs` Large File Storage files...](#to-clone-this-repo-plus-all-sub-repos-git-submodules-and-all-git-lfs-large-file-storage-files)
        1. [To update this repo:](#to-update-this-repo)
        1. [To add a repo as a submodule inside another repo:](#to-add-a-repo-as-a-submodule-inside-another-repo)
1. [Here are some of the contents contained herein:](#here-are-some-of-the-contents-contained-herein)
1. [Installation & Usage:](#installation--usage)
1. [Useful Applications](#useful-applications)
1. [Useful Scripts](#useful-scripts)
    1. [See useful_scripts/README.md](#see-useful_scriptsreadmemd)
1. [Misc. Install Instructions:](#misc-install-instructions)

<!-- /MarkdownTOC -->
</details>


<a id="project-ercaguy_dotfiles"></a>
# Project: eRCaGuy_dotfiles
https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


<a id="status"></a>
# Status:
Done and works. I use this daily on all of my Linux computers, including for my family and young kids.


<a id="hey-i-feel-so-smart--help-i-feel-dumb"></a>
# Hey! I feel so smart! / Help! I feel dumb!

1. I feel so smart...and wow, this is easy! --> you probably aren't. 
1. I feel so dumb, and wow, this is hard! --> you're getting there.
1. I feel like I know so much, but it turns out it's really complicated, and there's ~~so much~~ infinite more that I _don't_ know than what I do! --> you are becoming an expert.

I think it takes 8 to 15 years to get out of the slump at the bottom and start heading upwards on the right:

Artist's depiction of the [Dunning-Kruger effect](https://en.wikipedia.org/wiki/Dunning%e2%80%93Kruger_effect):
<a href="https://user-images.githubusercontent.com/6842199/248150378-fb71c67b-5833-4b7e-be75-8d1817f0e5d8.png">
    <p align="left" width="100%">
        <img width="50%" src="https://user-images.githubusercontent.com/6842199/248150378-fb71c67b-5833-4b7e-be75-8d1817f0e5d8.png">
    </p>
</a>
<sub>Source: I first saw this exact image (not the concept, but this particular image) on <a href="https://stackoverflow.com/users/3666197/user3666197">@user3666197's Stack Overflow profile here</a>. I don't know where they got it from.</sub>


<a id="description-of-contents"></a>
# Description of contents
This project started out as just a few helpful nuggets I like to put in my `~/.bashrc` file, for example, as well as some scripts and other configuration files, but I decided to make it a place I put all sorts of reference scripts, files, shortcuts, Linux tips & tricks, Eclipse documentation, etc, I've built up over the years. 


<a id="how-to-clone-whole-repo"></a>
<a id="git-submodules-and-git-lfs-how-to-clone-this-repo-and-all-git-submodules-and-git-lfs-files"></a>
# _Git submodules and Git LFS:_ how to clone this repo and all git submodules and git lfs files 
**(including tracked binary files, such as PDFs)**

This repo contains [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), which simply means that this is a git repo which contains other git repos. It also uses [`git lfs` (Large File Storage)](https://git-lfs.com/) to more-efficiently store certain binary files, such as PDFs. 

<a id="references"></a>
### References:
1. `git submodule`s
    1. [my answer] [How to update all git submodules in a repo (two ways to do two _very different_ things!)](https://stackoverflow.com/a/74470585/4561887)
    1. For more on git submodules, see the `= git submodules: =` section of my "git & Linux cmds doc" notes in my [eRCaGuy_dotfiles](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles) repo here: [eRCaGuy_dotfiles/git & Linux cmds, help, tips & tricks - Gabriel.txt](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/git%20%26%20Linux%20cmds%2C%20help%2C%20tips%20%26%20tricks%20-%20Gabriel.txt).
    1. Official `git submodule` documentation: https://git-scm.com/book/en/v2/Git-Tools-Submodules
    1. _Note: the start of the `git submodule` notes below were originally copied from my eRCaGuy_hello_world repo [here](https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world#how-to-clone-this-repo-and-all-git-submodules)._
1. `git lfs`
    1. \*\*\*\*\* https://git-lfs.github.com/ (new link: https://git-lfs.com/) - how to begin tracking files, such as PDF files, with `git lfs`:
        ```bash
        git lfs status
        # list all `git lfs`-tracked files
        git lfs ls-files
        # see if `git lfs` is installed, and which file types it is tracking
        cat .gitattributes  

        git lfs install
        git lfs track "*.pdf"
        git lfs track "*.PDF"
        git add .gitattributes
        git add *.pdf   # add all *.pdf files
        git add *.PDF   # add all *.PDF files
        git add -A      # (optional) add ALL (`-A`) files

        # Check LFS status; useful after `git add`--see here:
        # https://stackoverflow.com/a/54452098/4561887
        # - Look for `-> LFS:` markers to indicate a file will be getting backed up via Git LFS
        #   rather than via regular Git. Ex: 
        #
        #           # this file will be backed up by Git LFS
        #           linux/systemd-by-example-book_GS_edit.pdf (Git: 0ef9976 -> LFS: 0ef9976)
        #           # but this file will be backed up by regular Git
        #           linux/systemd-by-example-book_GS_edit.pdf (Git: 0ef9976 -> File: 774ea46)
        #
        git lfs status

        # list all `git lfs`-tracked files--ie: files which will be or are backed up by Git LFS
        git lfs ls-files  
        
        # See if `git lfs` is installed, and which file types it is tracking
        # - Sample output if `git lfs` is tracking all *.pdf and *.PDF files:
        #
        #       *.pdf filter=lfs diff=lfs merge=lfs -text
        #       *.PDF filter=lfs diff=lfs merge=lfs -text
        #
        cat .gitattributes  

        git commit -m "Begin tracking PDF files with 'git lfs'"
        ```
    1. My `git lfs` notes: [How to use `git lfs` as a basic user: this covers the question: "What is the difference between `git lfs fetch`, `git lfs fetch --all`, `git lfs pull`, and `git lfs checkout`?"](https://stackoverflow.com/a/72610495/4561887)
    1. [How can I tell if a file will be uploaded to `git lfs` correctly?](https://stackoverflow.com/a/54452098/4561887)
    1. See the parts [of my answer here](https://unix.stackexchange.com/a/731663/114401) titled, "(Figure out which file extensions to add to git lfs next)" and "Quick reference: list extensions of all files > 10 kiB in size (`-size +10k`)".  
        Example of the latter:
        ```bash
        find . -not \( -path "./.git" -type d -prune \) \
            -type f -size +10k -printf '%s\t%p\n' \
            | awk '{printf("%13.6f kiB ", $1/(1024)); \
            for (i=2; i<NF; i++) printf("%s ", $i); printf("%s\n", $NF)}' \
            | sort -rn \
            | awk '{print($NF)}' \
            | sed 's/.*\///' | grep -oE "(^[^.]*$|\.[^0-9]*[\.]?[^0-9]*$)" | sort -u
        ```

<a id="to-clone-this-repo-plus-all-sub-repos-git-submodules-and-all-git-lfs-large-file-storage-files"></a>
### To clone this repo plus all sub-repos (git submodules) and all `git lfs` Large File Storage files...

...you must do the following:
```bash
# Clone this repo
git clone https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles.git
# cd into the freshly-cloned repo
cd eRCaGuy_dotfiles
# Pull all Git LFS files (large binary files, such as PDFs, tracked with `git lfs`)
git lfs pull
# Recursively clone and update all subrepos (git submodules) it may contain
git submodule update --init --recursive
```

<a id="to-update-this-repo"></a>
### To update this repo:

See especially my answer here: [How to update all git submodules in a repo (two ways to do two _very different_ things!)](https://stackoverflow.com/a/74470585/4561887):
```bash
# 1. Update the outer repo by pulling the latest from upstream

# 1.A. Regular `git pull`
git pull
# 1.B. Also pull LFS (Large File Storage) files; see my answer: 
# https://stackoverflow.com/a/72610495/4561887
git lfs pull

# 2. Then, update the subrepos (two ways to do two *very different* things!):

# 2.A. Pull subrepo changes

# Option 1: AS A **USER** OF THE OUTER REPO, pull the latest changes of the
# sub-repos as previously specified (pointed to as commit hashes) by developers
# of this outer repo.
# - This recursively updates all git submodules to their commit hash pointers as
#   currently committed in the outer repo.
git submodule update --init --recursive

# Option 2. AS A **DEVELOPER** OF THE OUTER REPO, update all subrepos to force
# them each to pull the latest changes from their respective upstreams (ex: via
# `git pull origin main` or `git pull origin master`, or similar, for each
# sub-repo). 
git submodule update --init --recursive --remote

# 2.B. now add and commit these subrepo changes
git add -A
git commit -m "Update all subrepos to their latest upstream changes"
```

<a id="to-add-a-repo-as-a-submodule-inside-another-repo"></a>
### To add a repo as a submodule inside another repo:

```bash
# General format
git submodule add URL_to_repo
# or
git submodule add URL_to_repo path/to/where/you/want/to/put/it

# Examples:
git submodule add https://github.com/ElectricRCAircraftGuy/ripgrep_replace.git
git submodule add https://gitlab.com/ElectricRCAircraftGuy/systemd-by-example.git
# etc.
```


<a id="here-are-some-of-the-contents-contained-herein"></a>
# Here are some of the contents contained herein:
1. [git & Linux cmds, help, tips & tricks - Gabriel.txt](git%20%26%20Linux%20cmds%2C%20help%2C%20tips%20%26%20tricks%20-%20Gabriel.txt) - a general note-taking document where I jot down Linux commands, examples, notes about how to use `gdb`, `bazel`, various command-line tools, build tools, etc. 
    1. It's kind of a general place where I write down things I learn which I know I will need later and don't want to forget. _Correction: it's actually more correct to say I **know** I will forget them, so I write them down so I can come back and reference them later._
    1. I can't remember what I learned, but I *can* remember where I wrote it down, so I frequently reference this document to remind myself what I learned.
1. `git diffn` drop-in-replacement program to show `git diff` with line 'n'umbers. As a thin `awk`-language-based wrapper around `git diff` it supports ALL options and features that `git diff` does! Learn [how to install and use it here](useful_scripts/README_git-diffn.md). Screenshot:
    1. ![`git diffn` screenshot](useful_scripts/git-diffn_screenshot_cropped.png)
1. `git blametool`. See: [useful_scripts/README.md](useful_scripts/README.md).
    1. [![](https://i.stack.imgur.com/5D4oE.jpg)](https://i.stack.imgur.com/5D4oE.jpg)
1. `git branch_`. Same as `git branch` except don't show "hidden", user-backed-up branches. See my answer here: [Hide but still save a branch with GIT?](https://stackoverflow.com/a/66574807/4561887)
1. [ssh key setup information](home/.ssh)
    1. including a really good `gs_ssh` alias which automatically sources a custom `.bashrc` file in your ssh environment whenever you log in!
1. .bashrc file which contains:
    1. `ls` aliases such as `ll`, `la`, & `l`
    1. Prompt String 1 (`PS1`) modifications to add terminal titles, current git branch name checked out [VERY USEFUL FEATURE!], bash shell level, etc
        1. ![bash shell terminal prompt showing current git branch!](./bashrc_sample_terminal_prompt.png)
    1. ssh aliases
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
1. Useful scripts: see [section below](#useful-scripts)
    1. Ripgrep fuzzy finder, "rgf.sh".
    1. Ripgrep Replace, `rgr` ([useful_scripts/rg_replace.sh](useful_scripts/rg_replace.sh)). This is a wrapper around Ripgrep to give it a find-and-replace feature to replace contents on your disk.
1. etc.


<a id="installation--usage"></a>
# Installation & Usage:

**Update 18 Sept. 2022:** The installation script isn't kept up-to-date at all really. However, pretty much every single file in this entire repo has detailed, stand-alone installation instructions for it in the comments at the top of it. So, just follow those instead, for within each individual file you'd like to use or install.

**Note:** _the installation script isn't kept up-to-date very well._ It falls behind frequently as I add new features and useful scripts, then I periodically have to update it again. So, it's not a bad idea to run this installation command anyway, to let it install whatever it can, but then still _manually look into the [useful_scripts](useful_scripts) folder, the [home](home) folder, and elsewhere, for other scripts or tools in this repo which this install script doesn't yet install_. 

**To run the install script for this _eRCaGuy_dotfiles_ project:**

    ./install_all.sh

Edit this script first if customization is desired. It's all interactive, however, so it won't overwrite anything without your permission. 

_However, it's still a good idea to back up your home directory first before running the installation script and to: 1) read the installation prompts carefully as it asks you to for permission to overwrite something, and 2) make sure you back any of those files it's prompting you about before allowing it to overwrite them._

**Additionally:**  

1. Most files contain comments with additional info, instructions, or helpful links to look at.
2. Many directories contain readmes, and some contain install scripts, such as my scripts to help install **.desktop** files. 
3. If a readme exists in a subfolder, take a look at it too for more install help or other usage information. 
4. Essentially, just read the readmes, headers, & other comments and it will become self-explanatory how to use or "install" something. If not, open up an issue or pull request and I'll address it. 


<a id="useful-applications"></a>
# Useful Applications
Good applications to install right after you install Linux.  
See: [useful_apps/README.md](useful_apps/README.md).


<a id="useful-scripts"></a>
# Useful Scripts 

<a id="see-useful_scriptsreadmemd"></a>
## See [useful_scripts/README.md](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/useful_scripts#ercaguy_dotfilesuseful_scripts)

Here is a list of all of the scripts provided in the "useful_scripts" directory. Some of these are so amazingly useful to me, and powerful, they deserve a section all on their own! 

**Therefore, I have created an additional readme to describe a few of these scripts in greater detail here: [useful_scripts/README.md](https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/useful_scripts#ercaguy_dotfilesuseful_scripts).**

Here is a list of some select scripts which I find _especially useful_, in a rough order of which ones I use most first:
1. touchpad_toggle.sh
1. open_programming_tools.sh
1. git-diffn.sh
1. git-changes.sh
1. git-blametool.sh
1. sync_git_repo_from_pc1_to_pc2.sh
1. git-branch_.sh
1. rgr / rg_replace
1. sublf.sh
1. ros_readbagfile.py
1. git-filechange-search.sh
1. find_and_replace.sh
1. tmux-session.sh


(tree generated w/`tree eRCaGuy_dotfiles/useful_scripts`):

```
eRCaGuy_dotfiles$ tree useful_scripts/
useful_scripts/
├── apt-cacher-server_proxy.sh
├── apt-cacher-server_proxy_status.sh
├── apt-cacher-server_proxy_toggle.sh
├── chm2html.py
├── desktop_file_install.sh -> ../Desktop_launchers/desktop_file_install.sh
├── desktop_file_uninstall.sh -> ../Desktop_launchers/desktop_file_uninstall.sh
├── find_and_replace.sh
├── find_and_replace_test_folder
│   ├── readme.md
│   ├── test1.cpp
│   ├── test1.txt
│   ├── test2.cpp
│   ├── test2.txt
│   └── test3.txt
├── git-blametool.sh
├── git-branch_.sh
├── git-changes.sh
├── git-diffc.sh
├── git-diffn_screenshot_cropped.png
├── git-diffn_screenshot.png
├── git-diffn.sh
├── git-disable-all-repos_test_subrepo
│   └── test_repo
│       ├── new text file (another copy).txt
│       ├── new text file (copy).txt
│       └── new text file.txt
├── git-disable-repos.sh
├── git-filechange-search.sh
├── git-tree.txt
├── install_all.sh -> ../install_all.sh
├── Link to ElectricRCAircraftGuy - Chrome-Case-Sensitive-Find A case-sensitive Find tool (recommended to use Ctrl + Alt + F) for the Google Chrome Browser.desktop
├── Link to ElectricRCAircraftGuy - eRCaGuy_PyTerm A datalogging serial terminal-console written in Python (I hope to extend it to Telnet and others later).desktop
├── Link to ElectricRCAircraftGuy - git-tree New git features 1) graphically view all your branches in a hierarchical fashion based on forking or desired dependencies; 2) cascade recursive rebases down the line.desktop
├── Link to ElectricRCAircraftGuy - PDF2SearchablePDF `pdf2searchablepdf input.pdf` = voila! ''input_searchable.pdf'' is created & now has searchable text!.desktop
├── open_programming_tools.sh
├── ping_loop.sh
├── README_git-diffn.md
├── README_git-sync_repo_from_pc1_to_pc2.md
├── README.md
├── README_ros_readbagfile.md
├── rgf.sh
├── rgr -> rg_replace.sh
├── rg_replace.sh
├── ros_readbagfile.py
├── ros_readbagfile_sample_output
│   ├── README.md
│   └── topics.yaml
├── scratch_work
│   └── gawk_git_diff_with_line_numbers.sh
├── sublf.sh
├── sync_git_repo_from_pc1_to_pc2--notes.md
├── sync_git_repo_from_pc1_to_pc2.sh
├── tmux-session.sh
├── touchpad_toggle.sh
└── wip
    ├── git-logn.sh
    └── !GS note--wip = "work in progress".txt

6 directories, 51 files
```


<a id="misc-install-instructions"></a>
# Misc. Install Instructions:

1. Install `speedtest` by Ookla:
    1. Go here: https://www.speedtest.net/apps/cli --> scroll to the bottom and click "Download for Linux" --> right-click on the correct architecture option from the download menu dropdown list which shows up, and go to "Copy link address". This is the address used in the `wget` line below. Here, I show it for the `x86_64` (64-bit processor) option.

    ```bash
    # Tested in Ubuntu 18.04
    mkdir -p ~/Downloads/Install_Files/speedtest--ookla
    cd ~/Downloads/Install_Files/speedtest--ookla
    wget https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz
    FILENAME="ookla-speedtest-1.1.1-linux-x86_64.tgz"
    # strip off extension to derive the dirname; see: https://stackoverflow.com/a/965072/4561887
    DIRNAME="${FILENAME%.*}"
    mkdir -p "$DIRNAME"
    tar -xvzf "$FILENAME" --directory="$DIRNAME"
    cd "$DIRNAME"
    mkdir -p ~/bin
    ln -si "$(pwd)/speedtest" ~/bin/speedtest
    # log out and log back in now if this is the first time you've created and used the 
    # ~/bin dir, as this will automatically add it to your $PATH variable in Ubuntu.
    # Otherwise, `speedtest` is ready to use immediately.
    ```
    
    1. After extracting `speedtest` as shown above, a **markdown readme** for it is found in `~/Downloads/Install_Files/speedtest--ookla/ookla-speedtest-1.1.1-linux-x86_64/speedtest.md`.


---

_This repo contains my own content and opinions and does not reflect opinions nor content on behalf of any employer._
