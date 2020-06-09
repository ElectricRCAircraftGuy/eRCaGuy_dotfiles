# git-diffn.sh

Originally answered on Stack Overflow here: [My answer to how to do "Git diff with line numbers (Git log with line numbers)"](https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers/61997003#61997003)

As of 24 May 2020, you can now use the third-party tool `git diffn` for this purpose. It's a light-weight wrapper around `git diff`, written in the `awk` pattern/action-based programming language. Here's a sample output from running `git diffn`:

[![enter image description here][2]][2]

# Table of Contents:
- [1/3: Demo of `git diffn`:](#13-demo-of-git-diffn)  
- [2/3: What is it?](#23-what-is-it)  
- [3/3: Installation](#33-installation)  

---

Here's a demo:

# 1/3: Demo of `git diffn`:

Create this file:

**hello_world.c:**

    #include <stdio.h>

    int main()
    {
        printf("Hello World\n");

        return 0;
    }

Commit it:

    git add hello_world.c
    git commit -m "add hello_world.c"

Change it to this and save the file:

**hello_world.c:**

    // Basic hello world example

    #include <stdio.h>

    int main(int argc, char *argv[])
    {
        printf("Hello Gabriel\n");
        
        int i = 700;
        printf("i = %i\n", i);
        return 0;
    }

Now run:

    git diff

Here's the output of `git diff` first for comparison purposes:

    $ git diff
    diff --git a/hello_world.c b/hello_world.c
    index e01704a..e971b73 100644
    --- a/hello_world.c
    +++ b/hello_world.c
    @@ -1,8 +1,12 @@
    +// Basic hello world example
    +
     #include <stdio.h>
     
    -int main()
    +int main(int argc, char *argv[])
     {
    -    printf("Hello World\n");
    -
    +    printf("Hello Gabriel\n");
    +    
    +    int i = 700;
    +    printf("i = %i\n", i);
         return 0;
    -}
    \ No newline at end of file
    +}

And a screenshot to show the color. Note that the red highlighted section is simply showing empty whitespace (spaces in this case) that could be deleted:

[![enter image description here][1]][1]

Now here's the output of `git diffn`. Notice it shows all line numbers perfectly! 

- Line numbers for _deleted lines_ are on the left, and show a `-` sign on both the far left AND to the right of the `:` to help you see better--whether your eyes like to scan down to the right of the colon or down on the far left of the screen.
- Line numbers for _added lines_ are farther to the right, and show a `+` sign on both the far left AND to the right of the `:`. 
- Line numbers for _unchanged lines_ shown for context are shown for both the  left (old file) AND the right (new file), separated by a `,`.

Output of `git diffn`:

    $ git diffn
    diff --git a/hello_world.c b/hello_world.c
    index e01704a..e971b73 100644
    --- a/hello_world.c
    +++ b/hello_world.c
    @@ -1,8 +1,12 @@
    +        1:+// Basic hello world example
    +        2:+
        1,   3: #include <stdio.h>
        2,   4: 
    -   3     :-int main()
    +        5:+int main(int argc, char *argv[])
        4,   6: {
    -   5     :-    printf("Hello World\n");
    -   6     :-
    +        7:+    printf("Hello Gabriel\n");
    +        8:+    
    +        9:+    int i = 700;
    +       10:+    printf("i = %i\n", i);
        7,  11:     return 0;
    -   8     :-}
    \ No newline at end of file
    +       12:+}

And a screenshot to show the color. Notice that the colons are NOT colored or stylized to match the surrounding text on the left and right. This is _intentional_ and designed-in behavior to act as a visual separator between the line numbers added on the left and the original `git diff` output on the right. 

[![enter image description here][2]][2]

# 2/3: What is it?

From the [top of `git-diffn.sh`][3]:

**DESCRIPTION:**

git-diffn.sh

1. a drop-in replacement for `git diff` which also shows line 'n'umbers! Use it *exactly* like `git diff`, except you'll see these beautiful line numbers as well to help you make sense of your changes. 
1. since it's just a light-weight awk-language-based wrapper around `git diff`, it accepts ALL options and parameters that `git diff` accepts. Examples:
    1. `git diffn HEAD~`
    1. `git diffn HEAD~3..HEAD~2`
1. works with any of your `git diff` color settings, even if you are using custom colors
    1. See my answer here for how to set custom diff colors, as well as to see a screenshot of custom-color output from `git diffn`: https://stackoverflow.com/questions/26941144/how-do-you-customize-the-color-of-the-diff-header-in-git-diff/61993060#61993060
    1. Here are some sample `git config` commands from my answer above to set custom `git diff` colors and attributes (text formatting):

            git config --global color.diff.meta "blue"
            git config --global color.diff.old "black red strike"
            git config --global color.diff.new "black green italic"
            git config --global color.diff.context "yellow bold"

1. in `git diffn`, color output is ON by default; if you want to disable the output color, you must use `--no-color` or `--color=never`. See `man git diff` for details. Examples: 

        git diffn --color=never HEAD~
        git diffn --no-color HEAD~3..HEAD~2

# 3/3: Installation

1. Windows (untested): this may work inside the bash terminal that comes with [Git for Windows][4], but is untested. Install Git for Windows. Open the bash terminal it comes with, and try to follow the instructions below. I need some testers who will test this in Git for Windows. Please see and answer here: https://github.com/git-for-windows/git/issues/2635. 
1. Mac (untested): use the terminal and follow the instructions below. You may need to install `gawk`. If so, try [this][5]: `brew install gawk`.
1. Linux (tested on Ubuntu 18.04 and works perfectly): follow the terminal instructions below.

**Option 1 (my recommendation):** download the whole repo and then create a symlink to the program so that you can easily receive updates by doing a `git pull` from the repo whenever you want.

First, `cd` to wherever you want to install this. Then run:

    git clone https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles.git
    cd eRCaGuy_dotfiles/useful_scripts
    mkdir -p ~/bin
    ln -si "${PWD}/git-diffn.sh" ~/bin/git-diffn

Done! Now just do the final step below!

**Option 2 (for those who just want the 1 file):** download just the one file one time.

    mkdir -p ~/bin
    cd ~/bin
    wget https://raw.githubusercontent.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/master/useful_scripts/git-diffn.sh
    chmod +x git-diffn.sh
    mv git-diffn.sh git-diffn

Done! Now just do the final step below!

**Final step:**

Now close and re-open your terminal, or re-source it with `. ~/.bashrc`, and you are done!

`git diffn` will now work as an exact drop-in replacement for `git diff`!

  [1]: https://i.stack.imgur.com/0iE0N.png
  [2]: https://i.stack.imgur.com/F6gyz.png
  [3]: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/git-diffn.sh
  [4]: https://gitforwindows.org/
  [5]: https://stackoverflow.com/a/39563982/4561887
