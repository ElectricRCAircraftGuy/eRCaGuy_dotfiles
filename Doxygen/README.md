

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

Now edit the `Doxyfile` to your liking:
1. Set `RECURSIVE              = YES` to scan subdirectories.
1. Update `EXCLUDE_PATTERNS` as desired to exclude certain directories or files from being scanned.
    If doing a PIC32 Microchip MPLAB X IDE microcontroller project, be sure to exclude the build directories, and/or the entire `*.X` project directory if your source code is stored up one level from the `*.X` project directory. Example:
    ```bash
    EXCLUDE_PATTERNS =  */MyProject.X/* \
                        */test/* \
                        */examples/* \
                        *.test.h
    ```
1. Set `HAVE_DOT               = YES` since we installed GraphViz above and want the `dot`-generated call graphs. 
1. Set `CALL_GRAPH             = YES` to generate call graphs. 

Now generate doxygen documentation and call graphs. 

- On a mid-sized ~100 MB repo on a high end machine (see: https://gabrielstaples.com/dell_xps15_9530_setup/), this takes ~2.5 minutes:
- UPDATE: not sure if this is working yet to generate graphs. Need to investigate. It might actually take more like **6 hours** even on a high-end machine when generating call graphs.
```bash
time doxygen Doxyfile
```

If you see this note at the end, which I marked by `<========`, below: 
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

Immediate re-runs of `time doxygen Doxyfile` after this change are very fast: \~13 seconds in my case. 

After running the above, you'll now have an `html/` and `latex/` directory in your repo. The `html/` directory contains the HTML documentation, and the `latex/` directory contains the LaTeX documentation which is required to generate a PDF. 

Open the HTML documentation in Chrome:
```bash
google-chrome html/index.html
```

To generate a PDF from the LaTeX documentation, navigate to the `latex/` directory and run `make` [GS note: I have not confirmed this yet, as it failed to fully make for me]:
```bash
cd latex
time make
```
