#!/usr/bin/env python3

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# STATUS: WORKS and is usable, but the comments aren't finalized (ex: see the installation
# instructions below), and the program could use some cleaning up when I have time. Anyway, it does
# work at least!

# Print out basic stats on cpu load.

# CPU LOGGER INSTALLATION INSTRUCTIONS:
# 1. Add this alias to your ~/.bash_aliases file. Use it to view the log live at any time.
#       # Continually watch the live log output from "eRCaGuy_dotfiles/useful_scripts/cpu_logger.py"
#       alias gs_cpu_logger_watch='less -N --follow-name +F ~/cpu_log.log'
# 2. Auto-start the logger at boot by adding the following to your Ubuntu "Startup Applications" GUI program:
#   New "Startup Program" entry:
#       Name:       GS cpu_logger.py
#       # NB: use `chrt` here to have Linux raise the priority and use the soft real-time scheduler!
#       # See my answer: https://stackoverflow.com/a/71757858/4561887
#       Command:    sudo chrt -rr 1 /home/gabriel/GS/dev/eRCaGuy_dotfiles/useful_scripts/cpu_logger.py
#       Comment:    Start up the CPU logger, with auto-rotating logs, at boot.
# 3. Also install this executable by following the installation instructions at the top of the file:
#   "eRCaGuy_dotfiles/useful_scripts/cpu_load.py".
#   Run `cpu_load` to see your current CPU usage.
#   Sample run and output:
#       $ gs_cpu_load
#       Measuring CPU load for 2 seconds...
#       Overall: 15.21%
#       Individual CPUs: 13.60%  12.20%  15.20%  14.90%  14.60%  18.50%  15.80%  16.90%

# References
# 1. [my answer] https://stackoverflow.com/a/70760502/4561887
# 1. [my Q&A] https://unix.stackexchange.com/q/686424/114401


####### OLD NOTES TO UPDATE, START #######

# INSTALLATION INSTRUCTIONS:#### UPDATE THESE #####
# 1. Install RipGrep: https://github.com/BurntSushi/ripgrep#installation
# 2. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/cpu_logger.py" ~/bin/cpu_logger            # required
#       ln -si "${PWD}/cpu_logger.py" ~/bin/gs_cpu_logger         # optional; replace "gs" with your initials
# 3. Now you can use this command directly anywhere you like in any of these ways:
#   1. `cpu_logger`
#   2. `gs_cpu_logger`

# References: #### UPDATE THESE ####
# 1. https://askubuntu.com/questions/22021/how-to-log-cpu-load
# 1. https://unix.stackexchange.com/questions/295599/how-to-show-processes-that-use-more-than-30-cpu/295608#295608
# 1. https://stackoverflow.com/a/40088591/4561887
# 1. https://docs.python.org/3/library/logging.html

# Test commands:
#       eRCaGuy_dotfiles$ rgr foo -R boo
#       eRCaGuy_dotfiles$ rgr foo -R boo --stats "git & Linux cmds, help, tips & tricks - Gabriel.txt"

####### OLD NOTES TO UPDATE, END #######


##### https://unix.stackexchange.com/a/295608/114401   <========

import logging
# This must be imported explicitly, separately.
# See: https://stackoverflow.com/a/65814814/4561887
import logging.handlers
import os
import pathlib
import psutil
import subprocess
import time

# ============= this works but lets do it differently ==============
# MOVE THIS TO MY HELLO_WORLD REPO!
# cpu_percent_total = psutil.cpu_percent(interval=2)
# cpu_percent_cores = psutil.cpu_percent(percpu=True)
# cpu_percent_total_str = ('%.2f' % cpu_percent_total) + "%"
# cpu_percent_cores_str = [('%.2f' % x) + "%" for x in cpu_percent_cores]
# print('Total: {}'.format(cpu_percent_total_str))
# print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

# # Sanity check
# avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
# print("DEBUG PRINT: avg = {:.2f}%".format(avg))
# ==================================================================

# https://docs.python.org/3/library/logging.html

"""
To view live log output, run this.
See my ans: https://unix.stackexchange.com/a/687072/114401
        less -N --follow-name +F ~/cpu_log.log
        alias gs_cpu_logger_watch='less -N --follow-name +F ~/cpu_log.log'


        #########
        # Print the whole file once to the screen
        cat ~/cpu_log.log

        # Interactively look at the file from the beginning to the end;
        # use `-N` to show line numbers
        less -N ~/cpu_log.log

        # Continually view the most-recent lines in the log file output

        # Option A: with `watch`
        watch -n 1 'tail -n 10 ~/cpu_log.log'

        # Option B [BEST!] with `less`  <========= BEST WAY TO VIEW CONTINUAL OUTPUT ==========
        less -N +F ~/cpu_log.log
        # See: https://unix.stackexchange.com/a/373540/114401
        # This is the same as typing this:
        less -N ~/cpu_log.log
        # ...and then pressing Ctrl + End to have `less` continually load the latest content in the
        # file. Press Ctrl + C to interrupt this behavior and go back to being able to use
        # `less` like normal, scrolling up and down to view data as you desire. Then press
        # q to exit, like normal.
"""


# COMMENTED OUT: I'll use `sudo chrt -rr 1 <cmd>` instead when launching this
# program. See my answer: https://stackoverflow.com/a/71757858/4561887
#
# # Raise the priority of this process to have maximum priority (lowest "niceness").
# # See:
# # 1. https://www.ibm.com/docs/en/aix/7.2?topic=processes-changing-priority-running-process-renice-command
# # 1. How can a Linux/Unix Bash script get its own PID? - https://stackoverflow.com/a/2493659/4561887
# # 1. ***** https://docs.python.org/3/library/os.html#os.nice
# # 1. ***** https://stackoverflow.com/a/1023088/4561887
# # Example in bash: `renice --priority -20 --pid $BASHPID`
# niceness = os.nice(0)  # REQUIRES `sudo` (root) privileges to do this!
# print('niceness = {}'.format(niceness))
# niceness = os.nice(-100)
# print('niceness = {}'.format(niceness))  # should be -20


logger = logging.getLogger('my_logger')
logger.setLevel(logging.DEBUG)
log_file_size_bytes = 1024*1024*25  # 25 MiB
log_file_path = str(pathlib.Path.home()) + '/cpu_log.log'
handler = logging.handlers.RotatingFileHandler(log_file_path, maxBytes=log_file_size_bytes, backupCount=10)
# logger.addHandler(handler)
format = "%(asctime)s, %(levelname)s, %(message)s"  # https://stackoverflow.com/a/56369583/4561887
formatter = logging.Formatter(fmt=format, datefmt='%Y-%m-%d__%H:%M:%S')
handler.setFormatter(formatter)
logger.addHandler(handler)
# logging.basicConfig(
#     handlers=[handler],
#     format=format,
#     datefmt='%Y-%m-%d__%H:%M:%S',
# )

# Ensure anyone can read or modify the log file even though it was created by root
# See: https://stackoverflow.com/a/53474975/4561887
PERMISSIONS_EVERYONE_READ_WRITE = 0o666
os.chmod(log_file_path, PERMISSIONS_EVERYONE_READ_WRITE)

# for _ in range(10000):
#     logger.info('Hello world!')

t_measurement_sec = 4
loop_counter = 0
inode_number_old = os.stat(log_file_path).st_ino
while True:
    # ---------------------------------
    # 0. set up
    # ---------------------------------

    loop_counter += 1

    logger.info('======================== START of loop count {} =============================\n'
        .format(loop_counter));
    handler.setFormatter(None) # remove formatter (log header) for the following logged messages

    # reset file permissions on the newly-created log file after each log
    # rotation; log rotations can be detected by a changed inode number;
    # see:
    # 1. https://docs.python.org/3/library/os.html#os.stat_result.st_ino
    # 1. ***** https://stackoverflow.com/a/44407999/4561887
    #   1. *****+ [my answer] https://stackoverflow.com/a/74788970/4561887
    # 1. `ls -i` (or `ls -1i` for single column output), which shows the inode
    #    number of each file
    inode_number_new = os.stat(log_file_path).st_ino
    if inode_number_old != inode_number_new:
        print("Log file rotation just detected!")
        inode_number_old = inode_number_new
        os.chmod(log_file_path, PERMISSIONS_EVERYONE_READ_WRITE)

    # ---------------------------------
    # 1. log the output of `psutil` and `ps`
    # ---------------------------------

    logger.info("Output from `psutil`:")

    cpu_percent_cores = psutil.cpu_percent(interval=t_measurement_sec, percpu=True)
    avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
    cpu_percent_overall = avg
    cpu_percent_overall_str = ('%5.2f' % cpu_percent_overall) + '%'
    cpu_percent_cores_str = [('%5.2f' % x) + '%' for x in cpu_percent_cores]
    cpu_percent_cores_str = ', '.join(cpu_percent_cores_str)

    # Print Tab-delimited
    logger.info('===> Overall CPU usage: {} <===\t\tIndividual CPUs:\t{}\n'.format(
        cpu_percent_overall_str,
        cpu_percent_cores_str,
    ))

    # print('Overall: {}'.format(cpu_percent_overall_str))
    # print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

    logger.info("Output from `ps`:")

    # Popen: https://stackoverflow.com/a/4760517/4561887
    # See: https://unix.stackexchange.com/a/295608/114401
    # cmd = ps -eo %cpu,args | awk '$1 >= 30 {print}'
    cmd = ['ps', '-eo', '%cpu,args']#, '|', 'awk', "'$1 >= 30 {print}'"]
    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    out, err = p.communicate()
    # print(out.decode("utf-8"))
    lines = out.decode("utf-8").splitlines()
    # separate out the %cpu usage right at the front from the rest of the ps output
    splitlines = [line.split(maxsplit=1) for line in lines]
    # print(splitlines)

    # Convert to a list of [float cpu_pct, str cmd]
    cpu_processes_list = []
    for line in splitlines[1:]: # Skip first line since it contains a heading: `%CPU COMMAND`
        individual_cpu_usage_pct = float(line[0])
        cmd = line[1]
        cpu_processes_list.append([individual_cpu_usage_pct, cmd])
    cpu_processes_list.sort(reverse=True)  # sort highest-cpu-usage first

    # Obtain a list of the top 10 processes, and another list of the processes > X% cpu usage
    cpu_processes_top10_list = cpu_processes_list[:10]
    cpu_processes_above_threshold_list = []
    for process in cpu_processes_list:
        INDIVIDUAL_CPU_THRESHOLD_PCT = 15
        individual_cpu_usage_pct = process[0]
        if individual_cpu_usage_pct >= INDIVIDUAL_CPU_THRESHOLD_PCT:
            cpu_processes_above_threshold_list.append(process)

    # If overall cpu usage is > Y, log all processes > X, OR the top 10 processes, whichever is
    # the greater number of processes. This ensures that when the overall cpu usage is high, we log
    # *something*, instead of nothing, in the event no single process is > X
    OVERALL_CPU_THRESHOLD_PCT = 0  # set to 0 to **always** log the top processes!
    cpu_processes_list = cpu_processes_above_threshold_list
    if cpu_percent_overall > OVERALL_CPU_THRESHOLD_PCT:
        if len(cpu_processes_top10_list) > len(cpu_processes_above_threshold_list):
            cpu_processes_list = cpu_processes_top10_list

    # Log the high-cpu-usage processes
    handler.setFormatter(None) # remove formatter for these log msgs only
    num = 0
    for process in cpu_processes_list:
        num += 1
        num_str = "%2i" % num
        individual_cpu_usage_pct = process[0]
        individual_cpu_usage_pct_str = ('%5.2f' % individual_cpu_usage_pct) + "%"
        cmd_str = process[1]

        # Print Tab-delimited
        logger.info('\t{}/{})\t{}\tcmd:\t{}'.format(
                num_str,
                len(cpu_processes_list),
                individual_cpu_usage_pct_str,
                cmd_str,
        ))
    logger.info('') # print a single new-line

    # ---------------------------------
    # 2. Now also log the output of `top`
    # - I want something like the equivalent of `top -b -n 1 | head -n 50`
    # ---------------------------------

    logger.info("Output from `top`:\n")

    cmd = ['top', '-b', '-n', '1']
    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    out, err = p.communicate()
    lines = out.decode("utf-8").splitlines()
    NUM_LINES_TO_KEEP = 50
    lines = lines[:50]
    # print(lines)
    for line in lines:
        logger.info('{}'.format(line))
    logger.info('') # print a single new-line

    # ---------------------------------
    # 3. clean up
    # ---------------------------------

    handler.setFormatter(formatter)  # restore log format for next logs


# print("Measuring CPU load for {} seconds...".format(t_measurement_sec))
# cpu_percent_cores = psutil.cpu_percent(interval=t_measurement_sec, percpu=True)
# avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
# cpu_percent_overall_str = ('%.2f' % avg) + '%'
# cpu_percent_cores_str = [('%.2f' % x) + '%' for x in cpu_percent_cores]
# print('Overall: {}'.format(cpu_percent_overall_str))
# print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

