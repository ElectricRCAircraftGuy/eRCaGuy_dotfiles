#!/usr/bin/env python3

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


"""

GS
Feb. 2022

Learn how to parse or duplicate or use the output from the `ncdu` "ncurses disk usage" program, so
that you can parse it, process it, and act on it if desired!

Original Author: @pLumo: https://unix.stackexchange.com/a/689673/114401
7 Feb. 2022

With modifications to the original by Gabriel Staples

Usage:
    cd path/to/here
    ncdu -o- /boot | ./read_ncdu.py

To view the json output from `ncdu` in a "pretty" format, do this:
    # Install the `jq` (jQuery-like?) command-line JSON parser
    sudo apt update
    sudo apt install jq

    # Use it
    ncdu -o- /boot | jq .


References:
1. My question: https://unix.stackexchange.com/q/689668/114401
    1. This original script by @pLumo: https://unix.stackexchange.com/a/689673/114401
1. Ncdu Export File Format JSON file format definition: https://dev.yorhel.nl/ncdu/jsonfmt


"""

import sys, json

def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

def get_recursive(item):
    size = 0
    if isinstance(item, dict):
        name = item["name"]
        size = item["asize"]
    else:
        name = item[0]["name"]
        for sub in item:
            size += get_recursive(sub)[1]
    return (name, size)

data = json.loads(sys.stdin.read())

items=[]
for i in data[3][1:]:
    items.append(get_recursive(i))

sum_sizes = sum([item[1] for item in items])
biggest = max([item[1] for item in items])
print("------ {} --- {} -------".format(data[3][0]["name"], sizeof_fmt(sum_sizes)))

for item in sorted(items, key=lambda x:x[1], reverse=True):
    size=item[1]
    name=item[0]
    percent=(size/sum_sizes*100)

    print("{:10} {:8} [{}{}] {}".format(sizeof_fmt(item[1]), "({:.1f}%)".format(percent),
        ('#' * round(size/biggest*10)), ('-' * round(10-size/biggest*10)), item[0]))


"""
Sample output:

    eRCaGuy_dotfiles/useful_scripts$ ncdu -o- /boot | ./read_ncdu.py
    ------ /boot --- 272.3MiB -------
    100.2MiB   (36.8%)  [##########] initrd.img-5.13.0-28-generic
    100.2MiB   (36.8%)  [##########] initrd.img-5.13.0-27-generic
    11.2MiB    (4.1%)   [#---------] vmlinuz-5.11.0-46-generic
    9.7MiB     (3.6%)   [#---------] vmlinuz-5.13.0-28-generic
    9.7MiB     (3.6%)   [#---------] vmlinuz-5.13.0-27-generic
    9.7MiB     (3.6%)   [#---------] vmlinuz-5.13.0-25-generic
    7.5MiB     (2.7%)   [#---------] grub
    5.7MiB     (2.1%)   [#---------] System.map-5.13.0-28-generic
    5.7MiB     (2.1%)   [#---------] System.map-5.13.0-25-generic
    5.7MiB     (2.1%)   [#---------] System.map-5.13.0-27-generic
    5.6MiB     (2.1%)   [#---------] System.map-5.11.0-46-generic
    251.7KiB   (0.1%)   [----------] config-5.13.0-28-generic
    251.6KiB   (0.1%)   [----------] config-5.13.0-25-generic
    251.6KiB   (0.1%)   [----------] config-5.13.0-27-generic
    248.1KiB   (0.1%)   [----------] config-5.11.0-46-generic
    180.6KiB   (0.1%)   [----------] memtest86+_multiboot.bin
    180.1KiB   (0.1%)   [----------] memtest86+.elf
    178.4KiB   (0.1%)   [----------] memtest86+.bin
    16.0KiB    (0.0%)   [----------] lost+found
    4.0KiB     (0.0%)   [----------] efi
    28.0B      (0.0%)   [----------] initrd.img
    28.0B      (0.0%)   [----------] initrd.img.old
    25.0B      (0.0%)   [----------] vmlinuz
    25.0B      (0.0%)   [----------] vmlinuz.old

"""
