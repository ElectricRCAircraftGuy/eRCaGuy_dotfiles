#!/usr/bin/env python3

# NB: on some systems, you may need to use one of these hash-bang lines above instead:
#       #!/usr/bin/python3
#   OR:
#       #!/usr/local/bin/python3
#
# Run `which python3` to see which Python 3 binary executable your system's environment is
# configured to use by default.
#
# See also:
# https://stackoverflow.com/questions/2429511/why-do-people-write-usr-bin-env-python-on-the-first-line-of-a-python-script

"""
This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

Author: Gabriel Staples

INSTALLATION INSTRUCTIONS:
0. Install dependencies:
    Source: https://zoomadmin.com/HowToInstall/UbuntuPackage/python-rosbag
            sudo apt install python-rosbag   # for python2 (deprecated)
            sudo apt install python3-rosbag  # for python3 (also doesn't seem to work now)
    If those two commands above don't work, try these cmds instead.
    Source:
    1. https://stackoverflow.com/a/64310922/4561887
    1. >>>> See also my own answer here <<<<: https://stackoverflow.com/a/69368883/4561887
            pip install bagpy
            pip3 install bagpy               # for python3 (this seems to be the new requirement!) <===
            # OR, if the above cmd ultimately fails due to permissions errors, use `sudo` too:
            sudo pip3 install bagpy
1. Create a symlink in ~/bin to this script so you can run it from anywhere:
            cd /path/to/here
            mkdir -p ~/bin
            ln -si "${PWD}/ros_readbagfile.py" ~/bin/gs_ros_readbagfile
            ln -si "${PWD}/ros_readbagfile.py" ~/bin/ros_readbagfile
2. If this is the first time ever creating the "~/bin" dir, then log out and log back in to your
   Ubuntu user account to cause Ubuntu to automatically add your ~/bin dir to your executable PATH.
   OR, you can just re-source your Ubuntu `~/.profile` file by running this:
            . ~/.profile
   - Note: if your terminal still says it cannot find the command when
   trying to run it, you may need to ensure `~/bin` is part of your `PATH` variable.
   See my answer here for details:
   https://answers.ros.org/question/371583/ros_readbagfile-command-not-found/?answer=403354#post-id-403354
   - You'll especially need to see my answer above if running either a non-default `~/.profile` file
   in Ubuntu, or if running a non-Ubuntu Linux derivative such as Arch Linux.
   - If on Ubuntu, you can find a backup copy of the default `~/.profile` file in
   `/etc/skel/.profile`. Copy that file to your home (`~`) dir if you'd like to restore your
   `~/.profile` file to its default configuration.
3. Now you can use the command `gs_ros_readbagfile` OR `ros_readbagfile` directly
   anywhere you like.

TUTORIAL DEMO:
For a usage demo, see this ROS tutorial I wrote here: "Reading messages from a bag file":
http://wiki.ros.org/ROS/Tutorials/reading%20msgs%20from%20a%20bag%20file

References:
1. http://wiki.ros.org/rosbag/Cookbook
1. https://pypi.org/project/pyrosbag/
1. Python2 `rosbag` Code API documentation: https://docs.ros.org/api/rosbag/html/python/
- `read_messages()` API documentation:
   https://docs.ros.org/api/rosbag/html/python/rosbag.bag.Bag-class.html#read_messages
1. http://wiki.ros.org/rospy/Overview/Time
1. https://www.geeksforgeeks.org/python-exit-commands-quit-exit-sys-exit-and-os-_exit/

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
import textwrap

# `topics=None` means to read ALL topics; see:
# https://docs.ros.org/api/rosbag/html/python/rosbag.bag.Bag-class.html#read_messages
READ_ALL_TOPICS = None


def printHelp():
    cmd_name = os.path.basename(sys.argv[0])
    help = textwrap.dedent(f"""
        Usage: {cmd_name} <mybagfile.bag> [topic1] [topic2] [topic3] [...topicN]

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
            {cmd_name} mybagfile.bag /speed /vel /dist
        2. Same as above, except also stores the printed output into an output file, "output.yaml" as well:
            {cmd_name} mybagfile.bag /speed /vel /dist | tee output.yaml
        3. [MY FAVORITE] Same as above, except also times how long the whole process takes:
            time {cmd_name} mybagfile.bag /speed /vel /dist | tee output.yaml

        Note: for a basic example of how to import YAML files in Python, so you can then import and
        manipulate the *.yaml files generated above, see:
        https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/tree/master/python/yaml_import

        TUTORIAL DEMO:
        For a usage demo, see this ROS tutorial I wrote here: "Reading messages from a bag file":
        http://wiki.ros.org/ROS/Tutorials/reading%20msgs%20from%20a%20bag%20file

        '{cmd_name}' is part of eRCaGuy_dotfiles:
        https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/useful_scripts/ros_readbagfile.py
        """)

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
    print("# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    args = Args()

    if len(sys.argv) == 1:
        print("# ERROR: no input args; 1 minimum required.")
        printHelp()
        sys.exit()

    if len(sys.argv) >= 2:
        if sys.argv[1] == "-h" or sys.argv[1] == "--help":
            printHelp()
            sys.exit()

        args.bag_file_in = sys.argv[1]

    if len(sys.argv) >= 3:
        args.topics_to_read = sys.argv[2:]

    print("# Scanning ROS bag file \"{}\"".format(args.bag_file_in))
    print("# for the following topics:")
    if not args.topics_to_read:
        # list is empty
        print("#    ALL TOPICS in the bag file")
    else:
        for topic in args.topics_to_read:
            print("#    {}".format(topic))

    print("# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

    return args


def printMsgsInBagFile(args):
    no_msgs_found = True
    # Establish counters to keep track of the message number being received under each topic name
    msg_counters = {} # empty dict
    total_count = 0
    bag_in = rosbag.Bag(args.bag_file_in)
    for topic, msg, t in bag_in.read_messages(args.topics_to_read):
        print("\n# =======================================")
        total_count += 1
        no_msgs_found = False
        # Keep track of individual message counters for each message type
        if topic not in msg_counters:
            msg_counters[topic] = 1;
        else:
            msg_counters[topic] += 1;

        # Print topic name and message receipt info
        print("# topic:           " + topic)
        print("# msg_count:       %u" % msg_counters[topic])
        # the comma at the end prevents the newline char being printed at the end in Python2; see:
        # https://www.geeksforgeeks.org/print-without-newline-python/
        print("# timestamp (sec): {:.9f}".format(t.to_sec())),
        print("# - - -")

        # Print the message
        print(msg)

    print("")
    print("# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

    print("# Total messages found: {:>16}".format(total_count))
    print("#")
    for topic in msg_counters:
        print("#    {:<30} {:>4}".format(topic + ":", msg_counters[topic]))
    if no_msgs_found:
        print("# NO MESSAGES FOUND IN THESE TOPICS")
    print("#")
    print("# DONE.")
    print("# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")


# If this file is called directly, as opposed to imported, run this:
if __name__ == '__main__':
    args = parseArgs()
    # printArgs(args) # for debugging
    printMsgsInBagFile(args)
