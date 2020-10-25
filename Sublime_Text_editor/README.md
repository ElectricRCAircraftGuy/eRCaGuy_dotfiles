This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# Sublime Text Settings:

To install the main `Preferences.sublime-settings` file, as well as all other syntax-specific/file-extension-specific `*.sublime-settings` preference files _which override that main preferences file for their respective file types_, simply copy them all to the Sublime Text 3 `/home/$USER/.config/sublime-text-3/Packages/User/` directory!

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
