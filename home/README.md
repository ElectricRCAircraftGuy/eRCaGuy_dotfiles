This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

## Notes

These files in this `home` directory all go in your Linux Ubuntu home directory: `~`, AKA: `$HOME`, AKA: `/home/my_username`.

**Reminder:** you cannot open up the [.git_editor.sublime-project](.git_editor.sublime-project) file in Sublime Text to edit it as a _text file_. This is because it has a Sublime Text _project file_ extension (`.sublime-project`), so Sublime Text reads it as a _project file_ instead of letting you edit it as a _text file_. To overcome this, simply open it in `gedit` or some other text editor to edit it as a _text file_.

    gedit .git_editor.sublime-project

You can also use `nano` at the command-line:

    nano .git_editor.sublime-project

Or, use `cat` to just _view_ its contents:

    cat .git_editor.sublime-project


## Eclipse User Dictionary Setup
See [.eclipse-user-dictionary--README.md](.eclipse-user-dictionary--README.md).

## Terminal Setup: Installation & Usage Instructions for `.profile`, `.bashrc`, `.bash_aliases`, and `.bash_aliases_private`

### 1. Installation

The `~/.profile` file [sources][source_vs_export] (imports) `~/.bashrc` if it exists, which (near the very end of it) sources `~/.bash_aliases` if it exists, which (at the very end of it) sources `~/.bash_aliases_private` if it exists. This segmentation and hierarchy is intentional. 

To install these files, first make backup copies of your local files, if they already exist, so you don't accidentally overwrite them and lose everything you already have:
```bash
mkdir -p ~/bak
cp -i ~/.profile ~/bak
cp -i ~/.bashrc ~/bak
cp -i ~/.bash_aliases ~/bak
cp -i ~/.bash_aliases_private ~/bak
```

Now, copy over the files from this repo to your computer. We will copy `.profile`, `.bashrc`, and `.bash_aliases_private` so that you can freely modify _only your own copy_ of each. However, for `.bash_aliases`, let's do something different: we will create a symlink (symbolic link) to it from your home dir to the `.bash_aliases` file in this repo so that you'll always get this repo's latest updates whenever you pull this repo, and so that _if you do decide to change or add something there that will benefit everyone_ you can then easily open up a Pull Request on GitHub to request that I pull your changes in that file back into the main repo.

```bash
cd path/to/eRCaGuy_dotfiles/home
# Copy these files
cp -i .profile ~/.profile
cp -i .bashrc ~/.bashrc
cp -i .bash_aliases_private ~/.bash_aliases_private
# Make a symlink to this file
ln -si "${PWD}/.bash_aliases" ~/.bash_aliases
```

Now close and re-open all of your terminals, OR re-source your `~/.bashrc` file in each terminal by running this in each of them:
```bash
. ~/.bashrc
```

With the above configuration, add all of your personal configuration settings to `~/.bash_aliases_private`. If there are duplicate bash aliases or functions, the definitions in this `~/.bash_aliases_private` file will override anything inside `~/.bashrc` prior to this code block:
```bash
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
...and will override anything inside `~/.bash_aliases` prior to this code block:
```bash
# Import this "~/.bash_aliases_private" file, if it exists.
if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi
```

Note that anything in the very bottom of your `~/.bashrc` file, after the code just above which imports the `~/.bash_aliases` file, will override all other files, including the `~/.bash_aliases` and `~/.bash_aliases_private` files, since the definitions which are made _last_ are the ones which stick when the sourcing process is complete. 


### 2. Background information

On Linux distributions, such as Linux Ubuntu, your `~/.profile` file gets called each time you open a terminal. The `.profile` file provided here sources (imports) your `~/.bashrc` bash startup file, if it exists and if you are running bash, as well as adds your `~/bin` and `~/.local/bin` executable (binary) directories to your `PATH` so long as those directories exist too. 

Your `~/.bashrc` file is known as your "bash terminal startup file". Since it is sourced (imported) by the `~/.profile` file each time a terminal is opened, it can be used to configure your terminal environment. This includes configuring or setting environment variables, modifying your `PATH`, setting terminal colors, auto-completion, setting a terminal title, etc. 

Read more about bash sourcing and exporting variables in my answer here: [Stack Overflow: Unix: What is the difference between source and export?][source_vs_export].

One important environment variable to configure is your primary prompt string, known as Prompt String 1, or `PS1`. This is the string that shows at the beginning of your prompt, and usually contains your username, computer name, current path, etc, followed by the `$` symbol. You can, however, fully customize this prompt string, including its colors! Read more about it here: https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Prompts. It even allows you to [customize the terminal title](https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title), or show your currently-checked-out `git` repo whenever you are inside of a folder containing a `git` repository. I have modified this variable for you, to perform both of these operations. 

The `.bashrc` file is also a popular place to define custom bash `alias`es, which are function-like command-substitutions you can call at the command-line, as well as bash functions. Read more about bash aliases just below. 


### 3. About Bash Aliases

What's a bash "alias"? An `alias` is a command you can call that will call something else. It's kind of like a bash function, but more simplistic: an alias in bash is more like a macro in C. See `help alias` for more details. 

You can create a bash alias in the `~/.bashrc`, `~/.bash_aliases`, or `~/.bash_aliases_private` file by adding a line like this:
```bash
alias ll='ls -alF'
```

Now, after opening up a new bash terminal, OR re-sourcing your `~/.bashrc` file in your existing terminal by calling `. ~/.bashrc`, you can call `ll`, and it is as though you had typed `ls -alF` since that is what you aliased `ll` to above!

To see ALL of your currently-available aliases in your terminal, call `alias`. To see just what is inside of a given alias, call `alias some_alias`. Here's an example call and output. Notice how calling `alias some_alias` shows the exact definition of `some_alias` (`ll` in this case)!:
```bash
$ alias ll
alias ll='ls -alF'
```

Aliases can be **overridden!** This means if you have the following, only the *last* version of this alias definition remains in force:
```bash
alias ll='ls -a'
alias ll='ls -alF'  # only this last definition remains in force
```

So, calling `alias ll` to ask what the current definition of `ll` is will reveal the following:
```bash
$ alias ll
alias ll='ls -alF'
```

Bash functions can also be overridden in this way. The last definition is what remains in force.

Each time you add or edit an alias in one of the files above, you must get your terminal to re-source it (re-import it) before it is available for usage in its new form. There are 3 ways to do this:

1. (Method 1) Close and re-open your terminal.
1. (Methods 2 and 3) Manually re-source it like this:
    ```bash
    # recommended, since this is the POSIX-compliant way to do it
    . ~/.bashrc
    # OR (same thing for bash)
    source ~/.bashrc
    ```

  [source_vs_export]: https://stackoverflow.com/questions/15474650/unix-what-is-the-difference-between-source-and-export/62626515#62626515
