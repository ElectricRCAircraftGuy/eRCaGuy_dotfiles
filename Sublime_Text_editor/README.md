This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [Helpful Links:](#helpful-links)
1. [Sublime Text Settings:](#sublime-text-settings)
1. [Packages to install](#packages-to-install)
1. [Packages I'm still evaluating and maybe you should install](#packages-im-still-evaluating-and-maybe-you-should-install)
1. [Research](#research)
    1. [Remote editing: edit a remote file in a local instance of Sublime Text](#remote-editing-edit-a-remote-file-in-a-local-instance-of-sublime-text)

<!-- /MarkdownTOC -->
</details>


<a id="helpful-links"></a>
# Helpful Links:

1. Main site: https://www.sublimetext.com/.
    1. Download & Install: https://www.sublimetext.com/3.
1. Learn to use it: spend a whole day or so carefully going through this 3rd-party "Sublime Tutor" tutorial: https://sublimetutor.com/.


<a id="sublime-text-settings"></a>
# Sublime Text Settings:

Get my Sublime Text settings files here: [eRCaGuy_dotfiles/home/.config/sublime-text](../home/.config/sublime-text).

To install the main `Preferences.sublime-settings` file, as well as all other syntax-specific/file-extension-specific `*.sublime-settings` preference files _which override that main preferences file for their respective file types_, simply copy them all to the Sublime Text 3 `/home/$USER/.config/sublime-text-3/Packages/User/` directory! On newer versions of Sublime Text, the directory is `/home/$USER/.config/sublime-text/Packages/User/` instead.

Run this command to **install all Sublime Text settings files:**
```bash
# Copy all Sublime Text settings files from this repo to your Sublime Text
# user settings folder

cd path/to/eRCaGuy_dotfiles
# See also: https://askubuntu.com/a/86844/327339
cp -i home/.config/sublime-text/Packages/User/*.sublime-settings \
    ~/.config/sublime-text/Packages/User/
```


<a id="packages-to-install"></a>
# Packages to install

To Install a package:

`Ctrl` + `Shift` + `P` --> "Package Control: Install Package"

These are the Sublime Text 3 packages I currently have installed and like to have installed:

1. **ANSIescape** - adds a syntax highlighter to escape ANSI color codes like the `less -RFX` command will do too
1. **Compare Side-By-Side** - has nothing on Meld, but works OK for quick side-by-side file comparisons
1. **Git** - I use this almost exclusively for `git blame` inside Sublime; otherwise I'm all about the command-line when it comes to git!
1. **[Package Control]** - comes default with Sublime; you better have this to install more packages
1. **Tabright** - causes all new tabs and files opened at the command-line to show up at the far right/end instead of immediately after the tab you currently have open! This helps a lot for organization, as now tabs automatically get sorted in chronological order as you open them, rather than being a big random conglomeration which is impossible to make sense of and/or go through chronologically.
1. **Asciidoctor** - https://github.com/asciidoctor/sublimetext-asciidoc - provides syntax highlighting in Sublime Text 3 for [asciidoctor](https://asciidoctor.org/) markup documents, such as all of the `*.adoc` documentation and website documents in the [various KiCad repos on GitLab](https://gitlab.com/kicad).
1. **Liquid** - allows you to do syntax highlighting on [Liquid template language](https://shopify.github.io/liquid/) documents, including Liquid Markdown and Liquid HTML. These templates are used by static Jekyll websites, such as those used on GitHub pages. Note that the syntax highlighting for Liquid Markdown, for instance, is essentially just Markdown syntax highlighting plus it shows the `---` `---` Front Matter section at the top of Jekyll pages in special colors, and it highlights all Liquid tags appropriately, such as Liquid comment blocks: `{% comment %} my comment {% endcomment %}` in green.
1. **MarkdownTOC** - for seamlessly and automatically generating an auto-updating Table of Contents in a Markdown document! This TOC will even auto-update itself each time you save! 
    1. See:
        1. https://packagecontrol.io/packages/MarkdownTOC
        1. https://github.com/naokazuterada/MarkdownTOC
        1. [my answer] [Stack Overflow: Markdown to create pages and table of contents?](https://stackoverflow.com/questions/11948245/markdown-to-create-pages-and-table-of-contents/64656967#64656967)
    1. _Caveat:_ the first heading level you use right after the Table of Contents insertion point _must_ be larger than or equal to all subsequent levels, or else subsequent levels which are higher than it will not display. Ex: if you begin with a `## Level 2 Heading`, you cannot then have a `# Level 1 Heading` afterwards, or else the ToC won't be generated properly. Instead, you should either A) begin with a `# Level 1 Heading`, since it's the highest level and can therefore have any level after it, _or_ B) never have any heading greater than the first heading level you use after the ToC. If doing B, that means that a `## Level 2 Heading` followed by another `## Level 2 Heading`, or a `### Level 3 Heading` or lower, would be fine, so long as you never have a `# Level 1 Heading` since you began with a `## Level 2 Heading`.
1. **SCSS** - syntax highlighting for [SASS](https://sass-lang.com/) ([Syntactically Awesome Style Sheets](https://en.wikipedia.org/wiki/Sass_(stylesheet_language))) (`*.scss` files) in Sublime Text. See: https://stackoverflow.com/questions/42159810/how-to-set-scss-syntax-in-sublime-3/45261710#45261710.
1. **Devicetree DTS Highlighting** - for syntax highlighting in Linux [devicetree](https://www.devicetree.org/) source files ([.dts](https://en.wikipedia.org/wiki/Devicetree) files).
1. **CaseConversion** - for quickly converting between camelCase and snake_case. See:
    1. Where I learned about it: https://superuser.com/a/635718/425838
    1. GitHub page: https://github.com/jdavisclark/CaseConversion
1. **Terminus** - a built-in terminal that runs either in a _panel_ at the bottom of the Sublime Text main window, OR in a _tab_ just like an open file. 
    1. Where I first learned about it (with animated gifs): [Sublime Text 3 - integrated terminal?](https://stackoverflow.com/a/55484753/4561887)
    1. Official Package Control page: https://packagecontrol.io/packages/Terminus


<a id="packages-im-still-evaluating-and-maybe-you-should-install"></a>
# Packages I'm still evaluating and maybe you should install

1. **Git blame**
    1. https://packagecontrol.io/packages/Git%20blame
    1. https://github.com/frou/st3-gitblame
    1. Issue/feature request I've opened up here: https://github.com/frou/st3-gitblame/issues/59
    1. **Conclusion:** naaah, you don't need this. I have decided _not_ to use this package. I recommend you just use my [`git blametool` command](../useful_scripts/git-blametool.sh) instead, which opens up the output of `git blame` in your favorite text editor (ex: Sublime Text by default).


<a id="research"></a>
# Research


<a id="remote-editing-edit-a-remote-file-in-a-local-instance-of-sublime-text"></a>
## Remote editing: edit a remote file in a local instance of Sublime Text

I did this but didn't have time to refine the process, experiment, and document it. Here are some links to get me started next time I need to do this again:
1. [Google search for "sublime text over ssh"](https://www.google.com/search?q=sublime+text+over+ssh&oq=sublime+text+over+ssh&aqs=chrome..69i57j69i60j69i65.190j0j9&sourceid=chrome&ie=UTF-8)
1. https://stackoverflow.com/questions/15958056/how-to-use-sublime-over-ssh
    1. https://stackoverflow.com/a/18107549/4561887
    1. https://stackoverflow.com/a/18538531/4561887 - most useful; it aliases `rmate` as `subl` so you can use it like `subl`, but on a remote machine
1. https://codexns.io/products/sftp_for_sublime/workflows - look into this

1. https://github.com/henrikpersson/rsub
1. https://github.com/textmate/rmate
1. https://github.com/aurora/rmate
    1. https://github.com/aurora/rmate/blob/master/rmate
1. https://acarril.github.io/posts/ssh-sripts-st3
1. [Google search for "rmate"](https://www.google.com/search?q=rmate&oq=rmate+&aqs=chrome.0.69i59l2j69i65l3.2593j0j9&sourceid=chrome&ie=UTF-8)

Unrelated note: need to do my sync script too!: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/issues/24#issuecomment-1401223948: 2-way sync over git; sync the files shown by `git status` when on a dirty branch.
