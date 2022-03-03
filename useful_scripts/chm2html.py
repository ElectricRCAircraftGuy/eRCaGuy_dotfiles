#!/usr/bin/python3

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

"""
chm2html.py
- convert .chm files to .html, using the command shown here, with a few extra features (folder names, shortcuts, etc):
http://www.ubuntugeek.com/how-to-convert-chm-files-to-html-or-pdf-files.html
- (this is my first ever python shell script to be used as a bash replacement)

Gabriel Staples
www.ElectricRCAircraftGuy.com
Written: 2 Apr. 2018
Updated: 2 Apr. 2018

INSTALLATION INSTRUCTIONS:
- See my answer here: https://askubuntu.com/a/1021427/327339
1. Create a `~/bin` directory if you don't already have one:
        mkdir ~/bin
2. Make a symlink to chm2html.py in your `~/bin` directory:
        ln -s ~/path/to/chm2html.py ~/bin/chm2html
3. Log out of Ubuntu then log back in, or reload your paths with:
        source ~/.bashrc
4. Use it! `chm2html myFile.chm`. This automatically converts the .chm file and places the .html
files into a new folder called ./myFile, then it creates a symlink called ./myFile_index.html which
points to ./myFile/index.html.

References:
- ***** [MY OWN ANSWER with this code] https://askubuntu.com/a/1021427/327339
- http://www.ubuntugeek.com/how-to-convert-chm-files-to-html-or-pdf-files.html
  - format: `extract_chmLib book.chm outdir`
- http://www.linuxjournal.com/content/python-scripts-replacement-bash-utility-scripts
- http://www.pythonforbeginners.com/system/python-sys-argv

USAGE/Python command format: `./chm2html.py fileName.chm`
 - make a symbolic link to this target in ~/bin: `ln -s ~/GS/dev/shell_scripts-Linux/chm2html/chm2html.py ~/bin/chm2html`
   - Now you can call `chm2html file.chm`
 - This will automatically convert the fileName.chm file to .html files by creating a fileName directory where you are,
then it will also create a symbolic link right there to ./fileName/index.html, with the symbolic link name being
fileName_index.html

"""


import sys, os

if __name__ == "__main__":
    # print("argument = " + sys.argv[1]); # print 1st argument; DEBUGGING
    # print(len(sys.argv)) # DEBUGGING

    # get file name from input parameter
    if (len(sys.argv) <= 1):
        print("Error: missing .chm file input parameter. \n"
              "Usage: `./chm2html.py fileName.chm`. \n"
              "Type `./chm2html -h` for help. `Exiting.")
        sys.exit()

    if (sys.argv[1]=="-h" or sys.argv[1]=="h" or sys.argv[1]=="help" or sys.argv[1]=="-help"):
        print("Usage: `./chm2html.py fileName.chm`. This will automatically convert the fileName.chm file to\n"
              ".html files by creating a directory named \"fileName\" right where you are, then it will also create a\n"
              "symbolic link in your current folder to ./fileName/index.html, with the symbolic link name being fileName_index.html")
        sys.exit()

    file = sys.argv[1] # Full input parameter (fileName.chm)
    name = file[:-4] # Just the fileName part, withOUT the extension
    extension = file[-4:]
    if (extension != ".chm"):
        print("Error: Input parameter must be a .chm file. Exiting.")
        sys.exit()

    # print(name) # DEBUGGING
    # Convert the .chm file to .html
    command = "extract_chmLib " + file + " " + name
    print("Command: " + command)
    os.system(command)

    # Make a symbolic link to ./name/index.html now
    pwd = os.getcwd()
    target = pwd + "/" + name + "/index.html"
    # print(target) # DEBUGGING
    # see if target exists
    if (os.path.isfile(target) == False):
        print("Error: \"" + target + "\" does not exist. Exiting.")
        sys.exit()
    # make link
    ln_command = "ln -s " + target + " " + name + "_index.html"
    print("Command: " + ln_command)
    os.system(ln_command)

    print("Operation completed successfully.")
