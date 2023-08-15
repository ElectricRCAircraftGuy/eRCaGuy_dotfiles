# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# INSTALLATION:
#
# Copy and paste this file, or symlink it, into your user's home directory. It
# will then be automatically loaded by `gdb` next time you run `gdb`. Example
# commands:
#
#       cd path/to/here
#       # copy it
#       cp -i .gdbinit ~
#       # OR (my preference) symlink it
#       ln -si "${PWD}/.gdbinit" ~
#
#
# REFERENCES:
# 1. https://sdimitro.github.io/post/scripting-gdb/
# 1. ***** My huge answer here, and all of the references at the bottom of it: How to print the
# entire `environ` variable, containing strings of all of your C or C++ program's environment
# variables, in GDB: https://stackoverflow.com/a/76903706/4561887

# Print all environment variables stored inside the `extern char **environ`
# variable which is automatically available in all C and C++ programs in Linux!
# See:
# - `extern char **environ;` -
#   https://man7.org/linux/man-pages/man7/environ.7.html
# - My answer here, which has this function in it: https://stackoverflow.com/a/76903706/4561887
# - My answer here on how to use `printf` in GDB: https://stackoverflow.com/a/76903487/4561887
define print_environ
    set $i = 0
    while (environ[$i] != 0x0)
        printf "environ[%i]: \e[;94m%p\e[m: \"%s\"\n", $i, environ[$i], environ[$i++]
    end
end
# An alias to the function above, so I can type my initials (`gs_`) and press Tab Tab to find all of
# my custom commands easily.
define gs_print_environ
    print_environ
end
