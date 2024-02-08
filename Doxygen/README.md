

# Doxygen installation and setup


## Chat with GitHub Copilot

ElectricRCAircraftGuy: how do I run `doxygen` in a repo?

GitHub Copilot: To run Doxygen in a repository, follow these steps:

1. **Navigate to your repository**: Open a terminal and navigate to your repository using the `cd` command.

2. **Create a Doxygen configuration file**: If your repository doesn't already have a Doxygen configuration file (usually named `Doxyfile`), you can create one by running `doxygen -g Doxyfile` in the terminal. This will create a `Doxyfile` with default settings.

3. **Edit the Doxygen configuration file**: Open the `Doxyfile` in a text editor. You'll likely want to change some settings. For example, you might want to set `INPUT` to the directory containing your source code, and `RECURSIVE` to `YES` if you want Doxygen to scan subdirectories. If you want to generate call graphs, make sure you have Graphviz installed and set `HAVE_DOT` to `YES` and `CALL_GRAPH` to `YES`.

4. **Run Doxygen**: Once you've configured `Doxyfile` to your liking, you can generate the documentation by running `doxygen Doxyfile` in the terminal. This will generate documentation in the format and location specified in your `Doxyfile`.

5. **View the documentation**: If you've generated HTML documentation (the default), you can view it by opening the `index.html` file in a web browser. This file will be in the directory specified by the `OUTPUT_DIRECTORY` and `HTML_OUTPUT` settings in your `Doxyfile`.

Remember, to get the most out of Doxygen, you should comment your code following the Doxygen commenting style. You can find more information about this in the [official Doxygen manual](http://www.doxygen.nl/manual/docblocks.html).


## Setup and usage

Install it per my instructions here: [Ask Ubuntu: How to install Doxygen on Ubuntu?](https://askubuntu.com/a/1502796/327339)

Install GraphViz:
```bash
sudo apt update
sudo apt install graphviz

# Ensure it is now installed
dot -V  # shows the version
```

Basic Doxygen usage:

```bash
# Create a new Doxygen configuration file named Doxyfile
doxygen -g Doxyfile
```

Now **edit the `Doxyfile` to change it from its defaults and modify it your liking.** Here are my recommended changes to make, starting from the default `Doxyfile` you just created above:

1. Set `OUTPUT_DIRECTORY       = ../MyProject.Doxygen` to force the `html/` and `latex/` directories to be created in a `MyProject.Doxygen/` directory up one level from the root of your repo, assuming you are in the root of your repo when you run `doxygen Doxyfile`.
1. Set `CREATE_SUBDIRS         = YES` to distribute files among subdirectories so you don't have hundreds of thousands of autogenerated files in one directory, which can drastically slow down your filesystem.
1. Adjust `LOOKUP_CACHE_SIZE` as needed based on the note at the end of the `doxygen Doxyfile` run (search this document below for "LOOKUP_CACHE_SIZE"). If not sure, just set it to 2:
    ```bash
    LOOKUP_CACHE_SIZE      = 2
    ```
1. Set `EXTRACT_ALL            = YES` to cause it to document *all* functions and symbols, not just those with Doxygen comments. This is **really** important if you want to generate call and caller graphs of content you have *not* put Doxygen comments over, as it will otherwise only generate graphs for functions which have Doxygen comments above them.

1. Set the following to enable full documentation for private and static functions. 

    The benefit of disabling these (setting them to `NO`) is that it will reduce the number of functions in the call and caller graphs, making them easier to read and understand when you are looking for _inter_-file function calls (ie: interactions *between* files), rather than _intra_-file function calls (ie: interactions *within* a single file). But, the huge downside of disabling these is that with them disabled, I can't get a full picture of what's going on, such as when local (file-`static`) FreeRTOS tasks are called, for instance! So, just _enable_ (set to `YES`) all of them instead, to get a full picture of what's going on:

    ```bash
    EXTRACT_ALL            = YES
    EXTRACT_PRIVATE        = YES
    EXTRACT_PRIV_VIRTUAL   = YES
    EXTRACT_PACKAGE        = YES
    EXTRACT_STATIC         = YES
    EXTRACT_LOCAL_CLASSES  = YES  # is already YES by default
    EXTRACT_LOCAL_METHODS  = YES  # only affects Objective-C code
    EXTRACT_ANON_NSPACES   = YES
    RESOLVE_UNNAMED_PARAMS = YES  # is already YES by default
    ```

1. Set `RECURSIVE              = YES` to scan subdirectories.
1. Update `EXCLUDE_PATTERNS` as desired to exclude certain directories or files from being scanned.

    If doing a PIC32 Microchip MPLAB X IDE microcontroller project, be sure to exclude the build directories, and/or the entire `*.X` project directory if your source code is stored up one level from the `*.X` project directory. Example:

    ```bash
    EXCLUDE_PATTERNS =  */MyProject.X/* \
                        */test/* \
                        */examples/* \
                        *.test.h
    ```

1. Set `GENERATE_TREEVIEW      = YES` to generate a tree view (in the left side panel) of the files in the HTML documentation. Note that I still like to keep `DISABLE_INDEX          = NO` as well. 
1. Set `HAVE_DOT               = YES` since we installed GraphViz above and want the `dot`-generated call graphs. 
1. Set `CALL_GRAPH             = YES` to generate call graphs, meaning graphs of the functions that a given function calls. 
1. Set `CALLER_GRAPH           = YES` to generate caller graphs, meaning graphs of the functions that call a given function.
1. Set `DOT_IMAGE_FORMAT       = svg` (instead of `png`) to get SVG images, which have _searchable text on them!_ You can now use <kbd>Ctrl</kbd> + <kbd>F</kbd> in your browser to search for text on the images to find different functions and symbols and things!

1. Set `INTERACTIVE_SVG        = NO` to make these SVG images non-interactive, which means non-zoomable and non-pannable, _but larger_. Although I love the interactive SVG files, I don't like that they are much smaller and harder to see initially, so I prefer to disable the interactive SVG files. If you use `INTERACTIVE_SVG        = YES`, instead, then they become interactive and you can zoom in and out and pan around to see the details of the images (call and caller graphs), _but_ the images are much smaller and harder to see initially, which I find really annoying despite the amazing interactive nature.

1. Set `DOT_GRAPH_MAX_NODES    = 50` (which is the default) to not show too many nodes on call graphs. Truncated nodes, meaning: nodes with not all arrows to or from them shown, are shown as _red boxes_. Search this document for the word "red box" below for details. Ensure you have set `MAX_DOT_GRAPH_DEPTH    = 0` too, which is the default, to not limit the graph nodal depth. 

    IMPORTANT!: while you can increase the value of `DOT_GRAPH_MAX_NODES` to be > 50 (ex: 200) to show more nodes, I actually recommend you do *not* do that! Instead, simply click on any red nodes (boxes) in a graph to bring up that node's graph and see all of the unshown connections. In this way, graphs are more manageable and not too cluttered, and you can just drill down into individual nodes, in particular the red-box ones, to see missing connections as needed.


Now **generate doxygen documentation and call graphs.** 

- On a mid-sized \~100 MB repo on a high end machine (see: https://gabrielstaples.com/dell_xps15_9530_setup/), this takes \~9.5 minutes. 
    - NB: Be sure to add your project's build output to the `EXCLUDE_PATTERNS` setting or else it will try to doxygenate all of the intermediate build files as well, resulting in `doxygen` run-times as long as _6+ hours_ in this same repo that otherwise takes only 10 minutes!
```bash
# Generate doxygen documentation and call and caller graphs, using your 
# `Doxyfile` configuration file
time doxygen Doxyfile
```

You can also make a run script to easily run doxygen in your repo to ensure that it is always run from the root of your repo, so that relative paths in the `Doxyfile`, such as that set by `OUTPUT_DIRECTORY`, are always correct and based relative to the repo root!: 

Create a new file in your repo called `Doxyfile_run_doxygen.sh`, and mark it executable:
```bash
# create the file
touch Doxyfile_run_doxygen.sh
# make it executable
chmod +x Doxyfile_run_doxygen.sh
```

Now, place the following into it:

**`Doxyfile_run_doxygen.sh`:**

```bash
#!/usr/bin/env bash

# See: https://stackoverflow.com/a/60157372/4561887
FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[-1]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

cd "$SCRIPT_DIRECTORY"

DOXYFILE="Doxyfile"  # name/path of the doxygen configuration file
OUTPUT_DIRECTORY="$(grep "^OUTPUT_DIRECTORY" "$DOXYFILE" | cut -d "=" -f 2 | tr -d " ")"

echo "Generating Doxygen documentation..."
time doxygen "$DOXYFILE"

echo ""
echo "Doxygen documentation generated in \"$OUTPUT_DIRECTORY\"." 
echo "Opening the Doxygen documentation in the Google Chrome web browser..."
echo "Running cmd:  google-chrome \"$OUTPUT_DIRECTORY/html/index.html\""
echo ""
google-chrome "$OUTPUT_DIRECTORY/html/index.html"
```

After running `time doxygen Doxyfile`, or `./Doxyfile_run_doxygen.sh`, if you see this note at the end, which I marked by `<========`, below: 
```
Patching output file 1315/1316
Patching output file 1316/1316
type lookup cache used 59497/65536 hits=845227 misses=60975
symbol lookup cache used 65536/65536 hits=711737 misses=122390
Note: based on cache misses the ideal setting for LOOKUP_CACHE_SIZE is 1 at the cost of higher memory usage.  <========
finished...
```

...then you should edit your `Doxyfile` and set `LOOKUP_CACHE_SIZE` to the value the note indicates (1 in my case), as follows:
```bash
LOOKUP_CACHE_SIZE      = 1
```

Immediate re-runs of `time doxygen Doxyfile` or `./Doxyfile_run_doxygen.sh` after the initial run + making this change, are very fast, taking only \~14 seconds in my case.

After running the doxygen commands above, you'll now have an `html/` and `latex/` directory at the location specified by `OUTPUT_DIRECTORY`, ex: in `../MyProject.Doxygen/`. The `html/` directory contains the HTML documentation, and the `latex/` directory contains the LaTeX documentation which is required to generate a PDF. 

Open the HTML documentation in Chrome:
```bash
google-chrome ../MyProject.Doxygen/html/index.html
```

To generate a PDF from the LaTeX documentation, navigate to the `latex/` directory and run `make` [GS note: I have not confirmed this yet, as it failed to fully make for me]:
```bash
cd ../MyProject.Doxygen/latex
time make
```


## Box colors in call graphs and caller graphs

See here: https://www.doxygen.nl/manual/diagrams.html, under the section "The elements in the graphs generated by the dot tool have the following meaning". 

- **White boxes** are classes or structs or files. 
- **Red boxes** are "truncated nodes", which means they have more arrows to or from them than are shown in the graph, because the `DOT_GRAPH_MAX_NODES` value is too small so the `dot` graph tool removed some arrows to not clutter the graph. 

    IMPORTANT!: while you can increase the value of `DOT_GRAPH_MAX_NODES` to be > 50 to show more nodes, I actually recommend you do *not* do that! Instead, simply click on any red nodes (boxes) in a graph to bring up that node's graph and see all of the unshown connections. 

    The [source above](https://www.doxygen.nl/manual/diagrams.html) says (emphasis added): 

    > A box with a **red border** indicates **a node that has more arrows than are shown!** In other words: the graph is truncated with respect to this node. The reason why a graph is sometimes truncated is to prevent images from becoming too large. For the graphs generated with dot doxygen tries to limit the width of the resulting image to 1024 pixels.

    And the settings in the `Doxyfile` which control this, state (emphasis added with `**`): 

    > ```python
    > # The DOT_GRAPH_MAX_NODES tag can be used to set the maximum number of nodes
    > # that will be shown in the graph. If the number of nodes in a graph becomes
    > # larger than this value, doxygen will truncate the graph, which is visualized
    > # by representing a node as a **red box**. Note that doxygen if the number of direct
    > # children of the root node in a graph is already larger than
    > # DOT_GRAPH_MAX_NODES then the graph will not be shown at all. Also note that
    > # the size of a graph can be further restricted by MAX_DOT_GRAPH_DEPTH.
    > # Minimum value: 0, maximum value: 10000, default value: 50.
    > # This tag requires that the tag HAVE_DOT is set to YES.
    > 
    > DOT_GRAPH_MAX_NODES    = 50
    > ```

- **"Black" (actually: _dark grey_) boxes** are the functions whose graph is currently being shown.
- **Light grey boxes** (what [they call](https://www.doxygen.nl/manual/diagrams.html) just normal "gray") are "undocumented":

    > A gray box indicates an undocumented class.
