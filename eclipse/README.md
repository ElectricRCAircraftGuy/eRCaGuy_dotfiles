This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [Q&A](#qa)
1. [Screenshot of my Eclipse setup:](#screenshot-of-my-eclipse-setup)
1. [Why Eclipse?](#why-eclipse)
    1. [Eclipse](#eclipse)
    1. [Edit locally, build remotely](#edit-locally-build-remotely)
    1. [Sublime Text](#sublime-text)
1. [How to Install and Set Up Eclipse?](#how-to-install-and-set-up-eclipse)

<!-- /MarkdownTOC -->
</details>

Click here to jump straight down to the instructions on [How to Install and Set Up Eclipse](#how-to-install-and-set-up-eclipse).

1. [Eclipse install instructions on Google Drive][install-eclipse-google-drive] [recommended--always the most up-to-date]
1. [Eclipse install instructions PDF in this repo][install-eclipse-pdf] [manually generated periodically from the online source above]


<a id="qa"></a>
# Q&A
1. How to Install and Set Up Eclipse--see below.
1. Why Eclipse? See below. In short: because it's _indexer_ is far better than that of any other IDE or text editor I've ever used, including much better than that of Microsoft Visual Studio Code (MS VSCode).
1. Advanced topic on Resource Filters and selectively including or excluding files and directories: [How to exclude all parts of a folder in Eclipse except for a few specific sub-folders within it](Q_and_A_resource_filters.md)


<a id="screenshot-of-my-eclipse-setup"></a>
# Screenshot of my Eclipse setup:

<p align="left" width="100%">
    <img width="100%" src="images/Eclipse_IDE _arduino_file.png"> 
</p>


<a id="why-eclipse"></a>
# Why Eclipse?

The two main text editors/IDEs I use for all my professional and hobby software development are:

1. [**Eclipse**](https://www.eclipse.org/) and 
1. [**Sublime Text 3**](https://www.sublimetext.com/). 
    1. See also my [eRCaGuy_dotfiles/Sublime_Text_editor](../Sublime_Text_editor) folder.

It is my strong desirement/requirement that whatever IDE or text editor I use be _cross-platform_ and run on at least Windows, Mac, and Linux (ex: Ubuntu), and both of these editors meet that requirement too. (My primary operating system is Linux Ubuntu. Prior to that it was Windows. Most of my coworkers use Mac.)

**Other popular text editor/IDE options in general include:**

1. Microsoft Visual Studio Code
1. Atom
1. Netbeans
1. etc. 

However, I have found Eclipse + Sublime Text 3 to be more-than-adequate for my needs, and to work well for me. **Eclipse** has a great indexer, to easily jump around code to see function implementations and variable declarations and things simply by `Ctrl` + `click`ing on the code, and **Sublime Text 3** has excellent multi-cursor line editing support and other modern, advanced features to make editing really efficient. I literally work with *both* editors open at the same time, frequently jumping back and forth between the two editors, even within the same file at the same time, to make different kinds of edits and to navigate the code.

<a id="eclipse"></a>
## Eclipse

**Eclipse** is a popular, albeit very heavy (\~250 MB+ installed size, and commonly requiring from 1 GB to _32+ GB_ of RAM, depending on the project size it's trying to index), free and open source, and generally no-cost, IDE and text editor which supports a variety of microcontroller platforms, and which has custom variations adopted by or created by many companies. This means that if you learn it once, you get to have that knowledge benefit you in many other scenarios too. 

I use the main "**Eclipse IDE For C/C++ Developers**" for pretty much all my coding, plus some plugins for Python, Markdown, web development, etc.  Then, I compile at the Linux terminal command-line and debug with `gdb` at the Linux terminal command-line. For writing Arduino code, I use the _regular Eclipse IDE for C/C++ Developers_, with _zero_ Arduino plugins. I just tell Eclipse that `*.ino` files are C++ source files, and that's it! Now, its indexer perfectly indexes all of the Arduino source code. Then, I build the Arduino source code either in the regular Arduino IDE, or using the new [`arduino-cli` command-line](https://github.com/arduino/arduino-cli). 

**Eclipse-based 3rd-party editors/IDEs include:**

1. [System Workbench for STM32](https://www.openstm32.org/System%2BWorkbench%2Bfor%2BSTM32)
1. [recommended for STM32 microcontroller development] [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)
1. [Arduino Pro IDE](https://github.com/arduino/arduino-pro-ide)
1. Etc.

Each of these is something I either have used or may use in the future, so it means my Eclipse knowledge, experience, and know-how gets to be transferred and re-used, which is always nice. Since Eclipse is free and open source and no-cost, it also means I can use it both _at home_ _and_ on _any OS at any company I may choose to work for_, so long as they build at the command-line and give me admin rights to install software (the latter of which is a requirement for me to choose to work somewhere--or else I won't work for that company, _period_).

<a id="edit-locally-build-remotely"></a>
## Edit locally, build remotely

1. If you need to use **Eclipse** to edit locally but build remotely, here is the solution I have come up with, which works quite well: [eRCaGuy_dotfiles/useful_scripts/README_git-sync_repo_from_pc1_to_pc2.md](../useful_scripts/README_git-sync_repo_from_pc1_to_pc2.md). Essentially, you download and edit the source code locally, and use a bash script I wrote to sync your edits to the remote machine for building remotely. You then build at the command-line. For remote debugging, I just use the plain old `gdb` or `lldb` command-line debuggers via a terminal ssh session. 
1. The free and open source and no cost **Microsoft Visual Studio** Code has also reportedly come up with an excellent solution for remote development on a local machine, which reportedly works extremely well! You'll need to install the VS Code main application on your local machine, a VS Code Server on the remote machine, and open an automated ssh tunnel between the two. This is done via their "Remote Development extension pack". I haven't used it yet, but you can read more and see installation instructions here: https://code.visualstudio.com/docs/remote/ssh. People tell me it runs very fast. I presume this must be because the remote server handles all the hard work and just has to pass screen update information to your local machine over ssh, thereby minimizing data throughput and lag.

<a id="sublime-text"></a>
## Sublime Text

**Sublime Text 3** is a popular, and _very light-weight_ (\~15 MB installed size) text editor which is NOT free and open source. It is no-cost to install and use indefinitely, with no trial period expiration or software lock-outs, but you are legally required to [buy a license for \~$80 here for continued use](https://www.sublimehq.com/store/text). It's a great editor, and worth the cost. As far as installed size and RAM usage go, if Eclipse is an _aircraft carrier_, Sublime Text is a _jet ski_. BUT, if you need to be able to navigate code quickly, via an advanced indexer, on multi-million-line 100 GB code repos, Eclipse is the way to go. 

The unique attributes of both Eclipse and Sublime Text have led me to use them literally together, at the same time, on the same code, even within the same files at once. Even on small projects, such as Arduino microcontroller code, I use both editors at once. 


<a id="how-to-install-and-set-up-eclipse"></a>
# How to Install and Set Up Eclipse?

The image above is what my Eclipse looks like once fully set up. This is showing an Arduino code example in a `*.ino` file, inside the normal IDE installation folder, which I added as an Eclipse project so I can easily navigate and jump around the entire Arduino and AVR-libc source code that comes with any given Arduino IDE. I really like this setup for writing and developing Arduino and other code. And again, I am using _zero_ Arduino plugins! This is just regular Eclipse with a couple generic plugins and some plugins and themes to get the dark style. 

To build the Arduino source code, I just open up the regular IDE, set the preferences to "use external editor", and build and upload right from the regular Arduino IDE.

**To install and set up Eclipse, see my instructions here:**

1. [On Google Drive online][install-eclipse-google-drive] [recommended--always the most up-to-date]
1. [PDF][install-eclipse-pdf] [manually generated periodically from the online source above]


END


  [install-eclipse-google-drive]: https://docs.google.com/document/d/1LbuxOsDHfpMksGdpX5X-7l7o_TIIVFPkH2eD23cXUmA/edit?usp=sharing
  [install-eclipse-pdf]: Eclipse%20setup%20instructions%20on%20a%20new%20Linux%20(or%20other%20OS)%20computer.pdf
