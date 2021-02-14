This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [Helpful Links:](#helpful-links)
1. [Sublime Text Settings:](#sublime-text-settings)
1. [Packages to install](#packages-to-install)
1. [Packages I'm still evaluating and maybe you should install](#packages-im-still-evaluating-and-maybe-you-should-install)

<!-- /MarkdownTOC -->
</details>


<a id="helpful-links"></a>
# Helpful Links:

1. Main site: https://www.sublimetext.com/.
    1. Download & Install: https://www.sublimetext.com/3.
1. Learn to use it: spend a whole day or so carefully going through this 3rd-party "Sublime Tutor" tutorial: https://sublimetutor.com/.


<a id="sublime-text-settings"></a>
# Sublime Text Settings:

To install the main `Preferences.sublime-settings` file, as well as all other syntax-specific/file-extension-specific `*.sublime-settings` preference files _which override that main preferences file for their respective file types_, simply copy them all to the Sublime Text 3 `/home/$USER/.config/sublime-text-3/Packages/User/` directory!


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


<a id="packages-im-still-evaluating-and-maybe-you-should-install"></a>
# Packages I'm still evaluating and maybe you should install

1. **Git blame**
    1. https://packagecontrol.io/packages/Git%20blame
    1. https://github.com/frou/st3-gitblame
    1. Issue/feature request I've opened up here: https://github.com/frou/st3-gitblame/issues/59
