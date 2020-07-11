#!/usr/bin/python2

"""
This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

Author: Gabriel Staples

INSTALLATION INSTRUCTIONS:
0. Install dependencies:
        sudo apt install python-rosbag 
1. Create a symlink in ~/bin to this script so you can run it from anywhere:
        cd /path/to/here
        mkdir -p ~/bin
        ln -si "${PWD}/ros_readbagfile.py" ~/bin/gs_ros_readbagfile
2. Now you can use the `gs_ros_readbagfile` command directly anywhere you like.

References:
1. http://wiki.ros.org/rosbag/Cookbook
1. https://pypi.org/project/pyrosbag/
1. Python2 `rosbag` Code API documentation: https://docs.ros.org/api/rosbag/html/python/
- `read_messages()` API documentation: 
   https://docs.ros.org/api/rosbag/html/python/rosbag.bag.Bag-class.html#read_messages
1. http://wiki.ros.org/rospy/Overview/Time
1. https://www.geeksforgeeks.org/python-exit-commands-quit-exit-sys-exit-and-os-_exit/

Install Dependencies:
Source: https://zoomadmin.com/HowToInstall/UbuntuPackage/python-rosbag
    sudo apt install python-rosbag 

Note: as far as I can tell, rosbag runs only in Python2, not Python3 :(

Pros of this script: really easy to use; requires only 1 terminal, and NO `roscore` running.
Cons: this Python implementation runs ~13x slower than "OPTION 1", as described in 
"eRCaGuy_dotfiles/git & Linux cmds, help, tips & tricks - Gabriel.txt", so it might take up to 
1 to 2+ minutes to process an entire bag file instead of only like 5 to 10 seconds.

TODO: 
1. convert this entire Python script to a C++ program using the [C++ rosbag
API](http://wiki.ros.org/rosbag/Code%20API#cpp_api), to hopefully achieve a speed-up of ~13x
or so.

"""

import rosbag

import os
import sys

# `topics=None` means to read ALL topics; see:
# https://docs.ros.org/api/rosbag/html/python/rosbag.bag.Bag-class.html#read_messages
READ_ALL_TOPICS = None


def printHelp():
    cmd_name = os.path.basename(sys.argv[0])
    help = """
Usage: {} <mybagfile.bag> [topic1] [topic2] [topic3] [...topicN]

Reads and prints all messages published on the specified topics from the specified ROS bag file. If
no topics are specified, it will print ALL messages published on ALL topics found in the bag file.
For large bag files, on the order of 10 to 20 GB or so, expect the script to take on the order of
1 to 4 minutes or so assuming you have a fast Solid-State Drive (SSD). 

TODO: converting this script from Python to C++ could potentially speed this up by an estimated
factor of 13x or so, decreasing the processing time from a couple minutes to perhaps a dozen
seconds.

Examples: 
1. Print all messages published to the "/speed", "/vel", and "/dist" topics and stored in the 
"mybagfile.bag" ROS bag file to the screen:
    {} mybagfile.bag /speed /vel /dist
2. Same as above, except also stores the printed output into an output file, "output.txt" as well:
    {} mybagfile.bag /speed /vel /dist | tee output.txt
3. [MY FAVORITE] Same as above, except also times how long the whole process takes:
    time {} mybagfile.bag /speed /vel /dist | tee output.txt
""".format(cmd_name, cmd_name, cmd_name, cmd_name)

    print(help)


class Args:
    """
    Argument variables for the `main()` func
    """
    bag_file_in = ""
    topics_to_read = READ_ALL_TOPICS


def printArgs(args):
    print("args.bag_file_in = {}".format(args.bag_file_in))
    print("args.topics_to_read = {}".format(args.topics_to_read))


def parseArgs():
    args = Args()

    if len(sys.argv) == 1:
        print("ERROR: no input args; 1 minimum required.")
        printHelp()
        sys.exit()
    
    if len(sys.argv) >= 2:
        if sys.argv[1] == "-h" or sys.argv[1] == "--help":
            printHelp()
            sys.exit()

        args.bag_file_in = sys.argv[1] 
    
    if len(sys.argv) >= 3:
        args.topics_to_read = sys.argv[2:]

    print("Scanning ROS bag file \"{}\"".format(args.bag_file_in))
    print("for the following topics:")
    if not args.topics_to_read:
        # list is empty
        print("  ALL TOPICS in the bag file")
    else:
        for topic in args.topics_to_read:
            print("  {}".format(topic))

    print("=======================================")
    return args


def printMsgsInBagFile(args):
    no_msgs_found = True
    # Establish counters to keep track of the message number being received under each topic name
    msg_counters = {} # empty dict
    total_count = 0
    bag_in = rosbag.Bag(args.bag_file_in)
    for topic, msg, t in bag_in.read_messages(args.topics_to_read):
        total_count += 1
        no_msgs_found = False
        # Keep track of individual message counters for each message type
        if msg_counters.has_key(topic) == False:
            msg_counters[topic] = 1;
        else:
            msg_counters[topic] += 1;

        # Print topic name and message receipt info
        print("topic:           " + topic)
        print("msg #:           %u" % msg_counters[topic])
        # the comma at the end prevents the newline char being printed at the end in Python2; see:
        # https://www.geeksforgeeks.org/print-without-newline-python/
        print("timestamp (sec):"),
        print("%.9f" % t.to_sec()) 
        print("- - -")

        # Print the message
        print(msg)
        print("=======================================")

    if no_msgs_found:
        print("NO MESSAGES FOUND IN THESE TOPICS")

    print("Total messages found = {}.".format(total_count))
    ##### TODO: PRINT MESSAGE COUNT FOR EACH MSG TYPE TOO! ie: just print all key/value pairs in the 
    # `msg_counters` dict. What order to print them in? Probably just alphabetical.

    print("DONE.")


# If this file is called directly, as opposed to imported, run this:
if __name__ == '__main__':
    args = parseArgs()
    # printArgs(args) # for debugging
    printMsgsInBagFile(args)