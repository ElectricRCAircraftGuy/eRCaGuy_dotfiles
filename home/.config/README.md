This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

This folder will contain important user application settings I wish to back up and share. 


## See also

1. [../../useful_apps/README.md](../../useful_apps/README.md) - see my notes on many of the applications I like (which may store their settings in your `~/.config` dir) here.


## Notes

Many/most Linux applications store your persistent, user configuration files and settings inside your `~/.config/` dir. Any application that wishes to, simply creates a dir for itself here and uses it.

Examples: 
1. `~/.config/micro` - settings for the [`micro`](https://github.com/zyedidia/micro) mouse-enabled-CLI text editor
1. `~/.config/subime-text` - settings for the Sublime Text GUI text editor

So, I'll back up some of my `~/.config` settings files I find most important, or which I have customized. 


## How to "install" my custom settings into your user profile

You can either back up your old configs, then copy over mine, or symlink over mine. You can also just open up the files of interest and manually copy/paste whichever settings you want from within the respective files. 

Here is an example of how to use my `micro` settings for yourself:

```bash
# First, move your current settings into a backup copy
mv ~/.config/micro/bindings.json ~/.config/micro/bindings.json.bak
mv ~/.config/micro/settings.json ~/.config/micro/settings.json.bak

# Now, get my settings from this repo

cd path/to/here

# Method 1 (what I frequently use): symlink over the files so I can easily 
# update this repo changes I make to them later.
ln -si "${PWD}/bindings.json" ~/.config/micro/
ln -si "${PWD}/settings.json" ~/.config/micro/

# Method 2 (what you may prefer to use): copy over the files
cp bindings.json ~/.config/micro/
cp settings.json ~/.config/micro/
```
