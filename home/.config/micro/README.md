This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

Micro's settings are stored in `~/.config/micro/settings.json`. 


## References

ie: **useful links for how to configure `micro`'s settings:**

1. All of the official help documentation - https://github.com/zyedidia/micro/tree/master/runtime/help. A few of the links I use the most are here: 
    1. https://github.com/zyedidia/micro/blob/master/runtime/help/defaultkeys.md
    1. https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md
    1. ***** https://github.com/zyedidia/micro/blob/master/runtime/help/commands.md
    1. ***** https://github.com/zyedidia/micro/blob/master/runtime/help/options.md
    1. https://github.com/zyedidia/micro/blob/master/runtime/help/plugins.md
1. Color schemes - https://github.com/zyedidia/micro/tree/master/runtime/colorschemes
1. For how to do custom filetype glob settings, such as this: 
    ```jsonc
    "*.md": {
        "softwrap": true
    },
    ```
    ...see here: 
        1. https://github.com/zyedidia/micro/blob/master/runtime/help/options.md#global-and-local-settings
        1. https://github.com/zyedidia/micro/issues/2702#issuecomment-1403124559
1. All issues or feature requests opened by me: https://github.com/zyedidia/micro/issues?q=is%3Aissue+author%3A%40me+


## Shortcut keys

See: 
1. https://github.com/zyedidia/micro/blob/master/runtime/help/defaultkeys.md
1. https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md

Many of the shortcut keys are the same as or very similar to Sublime Text's, including for multicursor support.

List of a few shortcuts to remind myself:
1. <kbd>Alt</kbd> + <kbd>N</kbd> = multi-word select, like <kbd>Ctrl</kbd> + <kbd>D</kbd> in Sublime Text. Very useful for mass-editing a common string or variable name in a file.
1. Be sure to turn OFF certain shortcuts in your `terminator` terminal to keep it from interfering. See my solution here: [Bug: Cannot word-select using Shift + Ctrl + Arrow Left/Right on Linux](https://github.com/zyedidia/micro/issues/2688)
1. <kbd>Alt</kbd> + <kbd>ArrowUp/Down</kbd> - move selected text or line up or down. Similar to <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>ArrowUp/Down</kbd> in Sublime Text. I think I'm going to change this shortcut key in `micro` to be like Sublime. 


## Useful commands in `micro`

Here are a few commands I want to write down.

Enter the command menu with <kbd>Ctrl</kbd> + <kbd>E</kbd>. You must then type the cmd. Exit the command menu without running the command with <kbd>Ctrl</kbd> + <kbd>Q</kbd>. The command menu supports <kbd>UpArrow</kbd> command history, and most of the commands have built-in <kbd>Tab</kbd> completion (note: `set filetype <type>`, however, does _not_ :().

#### Set the syntax highlighting color scheme

See a list of all color schemes here: https://github.com/zyedidia/micro/tree/master/runtime/colorschemes

```bash
set colorscheme default
set colorscheme monokai
show colorscheme
```

#### Change the syntax highlighting setting for the current window

Where is a list of all of the `filetype` options? I have no idea. [I asked here](https://github.com/zyedidia/micro/issues/2702#issuecomment-1403192973). Here are a few I've discovered:

```bash
set filetype shell      # for bash, sh, etc.
set filetype markdown   
```

#### Other

```bash
# bind a shortcut key
# See: 
# 1. https://github.com/zyedidia/micro/blob/master/runtime/help/commands.md
# 1. ***** https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md
#   1. *****+ List of all "bindable actions" and "bindable keys": 
#      https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md#bindable-actions-and-bindable-keys
# 1. https://github.com/zyedidia/micro/blob/master/runtime/help/defaultkeys.md
bind <key> <action>

# Make moving lines up and down the same as in Sublime Text
# (normally it is Alt + Up/Down in micro)
bind CtrlShiftUp MoveLinesUp
bind CtrlShiftDown MoveLinesDown
```
