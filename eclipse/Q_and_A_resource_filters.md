This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

[I originally posted this Q&A on Stack Overflow here](https://stackoverflow.com/questions/70267494/how-to-exclude-all-parts-of-a-folder-in-eclipse-except-for-a-few-specific-sub-fo/70267495#70267495). _If you find it useful, please go upvote both the question and answer there or else it risks getting automatically deleted within the next year since it currently has a negative score._


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [Question: How to exclude all parts of a folder in Eclipse except for a few specific sub-folders within it](#question-how-to-exclude-all-parts-of-a-folder-in-eclipse-except-for-a-few-specific-sub-folders-within-it)
    1. [Similar questions](#similar-questions)
1. [Answer:](#answer)
    1. [Summary:](#summary)
    1. [Details:](#details)
    1. [Detailed example:](#detailed-example)
        1. [1. THE STEPS:](#1-the-steps)
        1. [2. Notes about properly adding necessary "Resource Filters":](#2-notes-about-properly-adding-necessary-resource-filters)
        1. [3. RESOURCE FILTER SETTINGS YOU SHOULD SET IN ORDER TO ACHIEVE THE DESIRED RESULT AS SPECIFIED IN THE QUESTION](#3-resource-filter-settings-you-should-set-in-order-to-achieve-the-desired-result-as-specified-in-the-question)
        1. [4. Other filter examples and results, demonstrating the extreme bugginess of Eclipse's Resource Filters feature:](#4-other-filter-examples-and-results-demonstrating-the-extreme-bugginess-of-eclipses-resource-filters-feature)
    1. [Conclusions:](#conclusions)
    1. [Going Further \[WRITE YOUR OWN MANUAL SCRIPT TO MAKE SYMLINKS\]:](#going-further-write-your-own-manual-script-to-make-symlinks)
    1. [Related:](#related)

<!-- /MarkdownTOC -->
</details>


---

<a id="question-how-to-exclude-all-parts-of-a-folder-in-eclipse-except-for-a-few-specific-sub-folders-within-it"></a>
# Question: How to exclude all parts of a folder in Eclipse except for a few specific sub-folders within it

This problem has plagued me for years.

I have a project folder tree. It has a build directory named "`output`", which stores build content, auto-generated source code, executables, etc. There are **hundreds of thousands** of folders and files in that `output` directory alone.

We want to EXCLUDE almost all of that folder to keep it from bogging down Eclipse's indexer and refresher, and since most of it is _not_ source code, but we must INCLUDE a few sub-folders from it so we can index their auto-generated source code and view C++ class and function definitions and variables and things from that auto-generated source code. 

How can we best accomplish this? 

Here is the project folder tree:

```text
my_project
    source
        ...
    dir1
    dir2
    dir3
    output
        board1
            build
                foo-lib1
                foo-lib2
                foo-lib3
                ...
                foo-lib99
                bar-lib1
                bar-lib2
                bar-lib3
                foo2-lib1
                foo2-lib2
            another-dir
                subdir1
                subdir2
            file1
            file2
            file3
        board2
            ...
        board99
    ...
    dir99999
```

Assume I want to *exclude* the entire `output` dir EXCEPT FOR the files in the directories `my_project/output/board1/build/foo-lib1` through `my_project/output/board1/build/foo-lib99`, which I want to _include_. I also may want to include a few other files or folders on a case-by-case basis in the future as I work on new libraries, and I want to include `my_project/output/board1/file1` through `file3`.

Again, here are the 100+ files and folders I'd like to NOT exclude from the `output` dir:

```
my_project/output/board1/build/foo-lib1
my_project/output/board1/build/foo-lib2
my_project/output/board1/build/foo-lib3
...
my_project/output/board1/build/foo-lib99

my_project/output/board1/another-dir/subdir1
my_project/output/board1/another-dir/subdir2

my_project/output/board1/file1
my_project/output/board1/file2
my_project/output/board1/file3
```

What's the best way to exclude the entire `output` dir **except** those files? (I'd like to **include** those files).

<a id="similar-questions"></a>
Similar questions
---

This is related to, but _not_ a duplicate of:
1. https://stackoverflow.com/questions/7498878/completely-exclude-certain-directories-from-eclipse-cdt-project
1. https://stackoverflow.com/questions/14221589/how-to-filter-resource-folders-in-a-certain-subpath-of-the-project-only

Neither of those are the same question, and neither of them had enough information to solve my problem.


---

<a id="answer"></a>
# Answer: 

<a id="summary"></a>
## Summary:

1. Follow section "1. THE STEPS" below. 
1. Then, implement the Resource Filters as described in section "3. RESOURCE FILTER SETTINGS YOU SHOULD SET IN ORDER TO ACHIEVE THE DESIRED RESULT AS SPECIFIED IN THE QUESTION". 

Done. The question is answered.


<a id="details"></a>
## Details:

Tested on Linux Ubuntu 18.04 in "Eclipse IDE for Embedded C/C++ Developers (includes Incubating components)":

- Version: 2021-06 (4.20.0)
- Build id: 20210612-2011

Note that the below instructions should also apply to and work in other Eclipse-based IDEs, such as [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html). Since the [Arduino PRO IDE](https://www.arduino.cc/pro/arduino-pro-ide) is apparently also Eclipse-based, it may work in that IDE as well. 

Sometimes I hate Eclipse due to nuances (and bugs/undesired behavior) like what I'll demonstrate below. But, it's important to document and share this knowledge, as it took me _several years_ to figure it all out, so here you go:


<a id="detailed-example"></a>
## Detailed example: 

This example shows how to:
1. exclude an entire folder
1. re-include it as an empty virtual folder
1. add Linked Folders as necessary, and then
1. add specialized rules to selectively include just what you want from them

Here are some examples to point out what DOES and does NOT work, and to show some techniques I use.

**The approach:** since we want to _exclude_ nearly all of the `output` dir in the project, we will first exclude ALL of it. Then, we will re-create that folder as a _virtual_ `output` folder which is empty. Then, we will add `board1` as a "Linked Folder", which is basically an Eclipse-based symbolic link, or symlink. Finally, we will add "Resource Filters" as necessary to include just what we want from the `my_project/output/board1` dir. 

You might ask: "Why exclude the `output` dir entirely first? Why not just do necessary _include_-style Resource Filters for that directory?" Here are some of my answers:

1. You canNOT just add the necessary _include_-style Resource Filters for contents within that `output` directory alone. It is not possible. Rather, adding even a *single* "Include only" Resource Filter automatically _excludes_ everything NOT explicitly included. That's not good. That seems like it would get really complicated quickly, trying to explicitly include the hundreds of thousands of files and folders we need included just to exclude one single directory (`output`) except for a few things within it. 
    1. Remember that to be included (assuming _any_ "Include only" Resource Filter is in use) a file or folder MUST be included by an "Include only" resource filter and NOT excluded by any "Exclude all" resource filter. 
1. A somewhat weak and not-very-great answer is: "You could totally do that. I just want to exclude it as soon as possible is all because it's so stinking huge it bogs down my system just having Eclipse try to refresh it to add its contents. And, the indexer immediately gets bogged down on trying to index it. So, let's just exclude it immediately." 
1. Another answer is that I suspect few people know about Eclipse "Virtual Folders", and sometimes they are really useful, so it's worth introducing them.
1. Referring back to reason 1 above: if you make a mistake with your resource filter and it tries to include hundreds of thousands of files again, you just froze your computer for 15 minutes while you either try to force-kill Eclipse or potentially even do a hard reboot to make Eclipse quit hogging up 100% of your resource. This won't happen as easily or as badly if you made the `output` dir a virtual folder instead, because at a bare minimum it at least keeps all of the immediate subdirs in the `output` dir which have NOT been added as Linked Folders from being refreshed and/or indexed.

<a id="1-the-steps"></a>
### 1. THE STEPS:

1. First, Turn OFF the indexer, so it doesn't bog down your system: Window --> Preferences --> C/C++ --> Indexer --> uncheck the "Enable indexer" box at the very top --> click "Apply and Close" at the bottom:
    1. [![enter image description here][1]][1]
1. Exclude the entire `output` dir: right-click your `my_project` project name in the Project Explorer --> Properties --> Resource --> Resource Filters --> click "Add Filter" --> choose "Exclude all", "Folders", check the box for "All children (recursive)", File and Folder Attributes, Project Relative Path, matches, "output", case sensitive, as shown here:
    1. [![enter image description here][2]][2]
    1. Do NOT type `output/` instead of `output`. With the trailing slash it will NOT work. 
    1. Click "OK" and "Apply and Close".  
1. Add `output` back as an empty Virtual Folder: right-click project name --> New --> Folder --> click "Advanced >>" --> choose "Folder is not located in the file system (Virtual Folder)" --> type in "output" as the "Folder name" --> click "Finish". Mine shows it in the Project Explorer with a little tiny "V" next to it now to indicate it is a "Virtual Folder":  
    [![enter image description here][3]][3]
1. Add `board1` as a "Linked Folder": right-click the newly-created `output` dir --> New --> Folder --> click "Advanced >>" --> choose "Link to alternate location (Linked Folder)" --> click "Browse" and navigate to the `my_project/output/board1` dir and select it --> click the "Open" button in the top-right to choose it --> click the "Resource Filters..." button to add resource filters NOW (see Important Note just below, and details on adding resource filters in the section below) --> click "Finish" back in the main "New Folder" window when done. 
    1. IMPORTANT NOTE: if you click "Finish" just above withOUT adding Resource Filters now, the _entire_ `board1` dir will get refreshed and added. If it contains too many files and folders for your system to handle, it may severely bog your system down and/or take a long time (many minutes, perhaps dozens of minutes) to complete. If it bogs your system down, you should have instead clicked the "Resource Filters..." button right in the main "New Folder" window and _added the necessary Resource Filters_ NOW _before_ you click the "Finish" button to finish adding this new Linked Folder!
    1. Note that once created, "Linked Folders" will have a little chain-link icon instead of the "V" icon on them.
1. If you didn't already do so above, add "Resource Filters" as necessary to include just what we want from the `my_project/output/board1` dir. See below for details.
1. Once done adding Resource Filters, turn the indexer back ON.

<a id="2-notes-about-properly-adding-necessary-resource-filters"></a>
### 2. Notes about properly adding necessary "Resource Filters":

Eclipse resource filters appear to be BADLY BROKEN. They only kinda-sorta work. Essentially, when trying to include or exclude a file or directory by path, including by "Project Relative Path" matches, it only works **one single level deep**. If you are trying to specify exact paths of files or folders to include or exclude, the work-around to keep all filters only **one level deep** is shown below:

**EXAMPLE OF RESOURCE FILTER SETTINGS WORKAROUND:**

```
>> ALL filters below have "Include only" and "File and Folder Attributes" 
selected. <<

Applies to (Files, Folders, or Fi_&_Fol (Files and folders))
  |      All children (recursive) checked?
  |       |  Filter Details (PRPm = Project Relative Path matches, 
  |       |  Name = Name matches)
  |       |   |   Case sensitive checked?
  |       |   |    | Regular expression checked?
  |       |   |    |  |  Filter text
  |       |   |    |  |  |
------------------------------------------------------------------------------

(THIS DOES **NOT** WORK DUE TO BUGS IN ECLIPSE)
Instead of applying this 1 resource filter to the `output` dir:

Fi_&_Fol  N  PRPm  Y  N  output/board1/build/foo*


(THIS **DOES** WORK because it keeps the filter levels limited to 
**1 level deep**)

...you must apply these 2 filters to separate dirs:

1. Apply this filter to the `output/board1` dir:
Folders   N  Name  Y  N  build

2. Then apply this filter to the `output/board1/build` dir once the filter 
above has included that dir:
Fi_&_Fol  N  Name  Y  N  foo*
```

<a id="3-resource-filter-settings-you-should-set-in-order-to-achieve-the-desired-result-as-specified-in-the-question"></a>
### 3. RESOURCE FILTER SETTINGS YOU SHOULD SET IN ORDER TO ACHIEVE THE DESIRED RESULT AS SPECIFIED IN THE QUESTION

_To set a Resource Filter_, **right-click the folder of interest in Eclipse** (note: you may have to Left-Click it first to bring it back into the proper context before Right-Click works again) --> **Properties** --> **Resource** --> **Resource Filters** --> **Add Filter** --> choose the options desired as shown below --> click **"OK"** to add the filter --> click **"Apply"** or **"Apply and Close"** to apply the filter. If you messed up the filter and accidentally typed in a buggy version of it, or if it includes too many files, your computer will freeze at this time. :)

Here is what the Resource Filter editor window looks like. This is a screenshot of the first filter below, listed as `Folders   N  Name  Y  N  build`:

[![enter image description here][4]][4] 

```
>> ALL filters below have "Include only" and "File and Folder Attributes" 
selected. <<

Applies to (Files, Folders, or Fi_&_Fol (Files and folders))
  |      All children (recursive) checked?
  |       |  Filter Details (PRPm = Project Relative Path matches, 
  |       |  Name = Name matches)
  |       |   |   Case sensitive checked?
  |       |   |    | Regular expression checked?
  |       |   |    |  |  Filter text
  |       |   |    |  |  |
------------------------------------------------------------------------------
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
1. Apply these filters to the `output/board1` dir:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
A) Include the `build` dir, which is 1 level deeper than the `board1` dir:
Folders   N  Name  Y  N  build

B) Include the `another-dir` dir, which is 1 level deeper than the `board1` dir:
Folders   N  Name  Y  N  another-dir

C) Include all files within the `board1` dir, which includes `file1` through 
`file3`. NB: do NOT use "Folders" or "Files and Folders" here! You MUST set it
to only "Files":
Files     N  Name  N  N  *

D) Alternatively, you could do this instead of the filter just above: include
files matching the "file*" pattern:
Files     N  Name  Y  N  file*

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
2. Apply these filters to the `output/board1/build` dir:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
A) Include all `foo-*` dirs, which are 1 level deeper than the `build` dir:
Folders   N  Name  Y  N  foo-*

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
3. Apply these filters to the `output/board1/another-dir` dir:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
A) NA: do nothing if you want EVERYTHING (all files and folders) to be included 
in this dir. 

B) Alternatively, you could match the "subdir*" folder pattern only:
Folders   N  Name  Y  N  subdir*
```

<a id="4-other-filter-examples-and-results-demonstrating-the-extreme-bugginess-of-eclipses-resource-filters-feature"></a>
### 4. Other filter examples and results, demonstrating the extreme bugginess of Eclipse's Resource Filters feature:

This is to show some filters which DO and do NOT work. 

Notes:
1. _You can individually apply "folder-level" filters to any folder in the project. Just beware that when using the "Project Relative Path", it is relative to the _root of the project_, _not_ to the folder path of the folder to which it is applied. So, use `output/board1/build/foo-lib1`, for instance, NOT `build/foo-lib1` to include the `foo-lib1` dir via a Resource Filter applied to the `build` dir._ 
    1. _Also keep in mind the **1-level-deep** bug as described above. This filter will only work when applied to the `build` dir. Applying it to any dir above that **should** work, but does not, since Eclipse's Resource Filters are very very very very very very very irritating and buggy._
1. _Many of the filers below which do NOT work actually cause Eclipse to freeze, and I have to _force kill Eclipse_. I do this on Linux by running `ps aux | grep -i eclipse` to see all Eclipse processes, including the Java one, then I kill them with `kill <pid1> <pid2>`, where `<pid1>` and 2 are what I noted in the output of the `ps` command._
1. _I also tried using a Virtual Folder I created named `output_` instead of `output`, in case there were conflicts with the top-project-level resource filter which exludes `output`, but it made no difference for any of the broken filters below._

---

_Note about using regex filters:_ see https://regex101.com/ for help building regular expressions properly. Example: this regular expression: 

```regex
my_project\/output\/board1\/build\/foo.*
```

OR this equivalent NON-regular expression wildcard match:

```
my_project/output/board1/build/foo*
```

...will match these paths:
```text
my_project/output/board1/build/foo-module1
my_project/output/board1/build/foo-module2
my_project/output/board1/build/foo-module3
...
my_project/output/board1/build/foo-module99
```

See that example yourself here: https://regex101.com/r/pRee5O/2 

---

```
>> ALL filters below have "Include only" and "File and Folder Attributes" 
selected. <<

Applies to (Files, Folders, or Fi_&_Fol (Files and folders))
  |      All children (recursive) checked?
  |       |  Filter Details (PRPm = Project Relative Path matches, 
  |       |  Name = Name matches)
  |       |   |   Case sensitive checked?
  |       |   |    | Regular expression checked?
  |       |   |    |  |  Filter text
  |       |   |    |  |  |
------------------------------------------------------------------------------
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Resource Filters applied to the `my_project/output` folder directly:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Does NOT work!
Fi_&_Fol  Y  PRPm  N  N  output/board1/build/foo-lib1

Does NOT work! It will show the "build" folder, looking like it works, but 
nothing is in it.
Fi_&_Fol  Y  PRPm  N  N  output/board1/build

Does NOT work! I don't know why. ALL dirs in `output/board1` still show up.
Fi_&_Fol  N  PRPm  N  N  output/board1/build

Does NOT work! I don't know why. ALL dirs in `output/board1` still show up.
Eclipse totally freezes when setting this filter.
Fi_&_Fol  N  PRPm  N  N  output/board1/build/foo*

Does NOT work! Nothing shows up inside the `output/board1` dir now.
Fi_&_Fol  Y  PRPm  N  N  output/board1/build/foo*

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Resource Filters applied to the `my_project/output/board1` folder directly:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Does NOT work! 
Fi_&_Fol  Y  PRPm  N  N  output/board1/build/foo-lib1

WORKS! The `output/board1/build` dir and all subdirs and files in that dir 
show up.
Folders   N  PRPm  N  N  output/board1/build

WORKS! Same as above.
Folders   Y  PRPm  N  N  output/board1/build

WORKS! The `output/board1/build` dir and all subdirs and files in that dir
show up.
Folders   N  Name  N  N  build

Does NOT work! Trailing slash (/) not allowed.
Folders   N  PRPm  N  N  output/board1/build/

Does NOT work! I don't know why.
Folders   N  PRPm  N  N  output/board1/build/foo-lib1

Does NOT work! I don't know why.
Folders   N  PRPm  N  Y  output\/board1\/build\/foo.*

Does NOT work! I don't know why.
Folders   Y  PRPm  N  Y  output\/board1\/build\/foo.*

Does NOT work! I don't know why.
Folders   N  PRPm  N  N  output/board1/build/foo*

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Resource Filters applied to the `my_project/output/board1/build` folder 
directly:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
WORKS!
Folders   N  Name  Y  N  foo*
```


<a id="conclusions"></a>
## Conclusions:

Overall, I have found Eclipse's Resource Filters to be HORRIBLY DIFFICULT TO MAKE WORK, HORRIBLY implemented, VERY BUGGY, HORRIBLY SLOW AND LIKELY TO FREEZE YOUR SYSTEM WHEN CONFIGURING, and HORRIBLY DOCUMENTED, but a little better than nothing.


<a id="going-further-write-your-own-manual-script-to-make-symlinks"></a>
## Going Further [WRITE YOUR OWN MANUAL SCRIPT TO MAKE SYMLINKS]:

An alternative to trying to get complicated with Eclipse's badly-broken Resource Filters might be to **write your own script** (in Python or Bash, for example) which acts on filters you create in a .gitignore-file-like fashion, which script then creates symlinks according to the filters in that file. You'd then simply use Eclipse to create the virtual `output` dir, followed by a Linked Folder to a custom dir you made with a bunch of symlinks in it to whatever resources you'd like to include. Done! This way, Eclipse just brings in your custom dir, and you manually manage the symlinks in that custom dir with your custom script and tools OUTSIDE of Eclipse, so that Eclipse's broken Resource Filters don't waste your life for days every time they freeze your system and screw up (because they won't be doing that anymore) since your script will manually manage the filtering instead).

Pros of the above-described filter script:
- you get full control
- Eclipse no longer freezes on your and wastes *hours* of your time while trying to configure filters

Cons:
- you have to periodically re-run your script to update the symlinks to include any new, matching files and folders which may have been created since you last ran the script

**Here is a starting script to do the above:**

First, do this one time:

```bash
cd path/to/repo

# Make your own `output` dir, which will contain symlinks. 
mkdir output_gs
# Add this to your .gitignore file
echo "/output_gs/" >> .gitignore
# OR, to not affect that file for others, add it to your
# private ".git/info/exclude" file instead
echo "/output_gs/" >> .git/info/exclude
```

Then, create this script here: `path/to/repo/output_gs/update_symlinks.sh`. Run it whenever you want to update the symlinks in your custom `output_gs` dir.

**update_symlinks.sh:**

```bash
#!/usr/bin/env bash

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "$0")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
SCRIPT_FILENAME="$(basename "$FULL_PATH_TO_SCRIPT")"

# 1. symlink all files 1 level inside board dir. 
# This symlinks over these files:
#   my_project/output/board1/file1
#   my_project/output/board1/file2
#   my_project/output/board1/file3
dir_source="$SCRIPT_DIRECTORY/../output/board1"
dir_target="$SCRIPT_DIRECTORY/board1"
mkdir -p "$dir_target"
cd "$dir_target"
find "$dir_source" -maxdepth 1 -type f | xargs -I{} -- ln -srf "{}" .

# 2. symlink all dirs of interest inside the board build dir

# 2.A: first, all of these files (I've added more than what were originally in
# the question, for demo purposes):
#   my_project/output/board1/build/foo-lib1
#   my_project/output/board1/build/foo-lib2
#   my_project/output/board1/build/foo-lib3
#   ...
#   my_project/output/board1/build/foo-lib99
#
#   my_project/output/board1/build/bar-lib1
#   my_project/output/board1/build/bar-lib2
#   
#   my_project/output/board1/build/foo2-lib1
#   my_project/output/board1/build/foo2-lib2
#
#   my_project/output/board1/build/bar2-lib1
#   my_project/output/board1/build/bar2-lib2
dir_source="$SCRIPT_DIRECTORY/../output/board1/build"
dir_target="$SCRIPT_DIRECTORY/board1/build"
mkdir -p "$dir_target"
cd "$dir_target"
find "$dir_source" -maxdepth 1 \
| xargs -I{} -- basename "{}" \
| grep -E '(^foo-.*|^bar-.*|^foo2-.*|^bar2-.*)' \
| sort -u \
| xargs -I{} -- ln -srf "$dir_source/{}" .

# 2.B: all files and folders in "my_project/output/board1/another-dir"
# which begin with `subdir`:
dir_source="$SCRIPT_DIRECTORY/../output/board1/another-dir"
dir_target="$SCRIPT_DIRECTORY/board1/another-dir"
mkdir -p "$dir_target"
cd "$dir_target"
find "$dir_source" -maxdepth 1 \
| xargs -I{} -- basename "{}" \
| grep -E '(^subdir.*)' \
| sort -u \
| xargs -I{} -- ln -srf "$dir_source/{}" .
```


<a id="related"></a>
## Related:
1. The links in the question
1. My Eclipse setup doc: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/eclipse
    1. [Direct link to it on Google Drive][5]

<sub>Keywords: Eclipse Resource Filters, eclipse resource filter "one level deep" bug; Eclipse include some files and folders, eclipse exclude all but a few files and folders</sub>


  [1]: https://i.stack.imgur.com/w3K11.png
  [2]: https://i.stack.imgur.com/xmbdr.png
  [3]: https://i.stack.imgur.com/3GV3O.png
  [4]: https://i.stack.imgur.com/zlkCw.png
  [5]: https://docs.google.com/document/d/1LbuxOsDHfpMksGdpX5X-7l7o_TIIVFPkH2eD23cXUmA/edit?usp=sharing
